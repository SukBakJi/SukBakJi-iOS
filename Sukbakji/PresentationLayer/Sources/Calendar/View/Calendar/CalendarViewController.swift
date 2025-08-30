//
//  CalendarViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CalendarViewController: UIViewController {
    
    private let calendarView = CalendarView()
    private let calendarViewModel = CalendarViewModel()
    private let univViewModel = UnivViewModel()
    private let alarmViewModel = AlarmViewModel()
    private let disposeBag = DisposeBag()
    private let isLoading = BehaviorRelay<Bool>(value: false)
    
    private var calendarHeightConstraint: Constraint?
    private var dateSelectHeightConstraint: Constraint?
    private var selectedIndexPath: IndexPath?
    
    private var alarmFBCView = AlarmFBCView(target: UIViewController())
    
    override func loadView() {
        self.view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindCollectionView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
        setAPI()
    }
}

extension CalendarViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        calendarView.calendarDetailTableView.isScrollEnabled = false
        calendarView.calendarBackgroundView.snp.makeConstraints { make in
            calendarHeightConstraint = make.height.equalTo(300).constraint
        }
        calendarView.calendarDetailTableView.snp.makeConstraints { make in
            dateSelectHeightConstraint = make.height.equalTo(8).constraint
        }

        calendarView.notificationButton.addTarget(self, action: #selector(notification_Tapped), for: .touchUpInside)
        calendarView.mypageButton.addTarget(self, action: #selector(schoolCalendar_Tapped), for: .touchUpInside)
        calendarView.univSettingButton.addTarget(self, action: #selector(schoolSetting_Tapped), for: .touchUpInside)
        calendarView.alarmButton.addTarget(self, action: #selector(alarm_Tapped), for: .touchUpInside)
    }
    
    @objc private func notification_Tapped() {
        let notificationViewController = NotificationViewController()
        self.navigationController?.pushViewController(notificationViewController, animated: true)
    }
    
    @objc private func schoolCalendar_Tapped() {
        let univCalendarViewController = UnivCalendarViewController()
        self.navigationController?.pushViewController(univCalendarViewController, animated: true)
    }
    
    @objc private func schoolSetting_Tapped() {
        let univSearchViewController = UnivSearchViewController()
        self.navigationController?.pushViewController(univSearchViewController, animated: true)
    }
    
    @objc func alarm_Tapped() {
        alarmFBCView = AlarmFBCView(target: self)
        
        self.view.addSubview(alarmFBCView)
        alarmFBCView.alpha = 0
        alarmFBCView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.alarmFBCView.alpha = 1
        }
    }
    
    @objc private func alarmSettingComplete() {
        alarmFBCView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, animations: {
            self.calendarView.alarmCompleteImageView.alpha = 1 // 나타나게
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.calendarView.alarmCompleteImageView.alpha = 0 // 투명하게
                }) { _ in
                    self.calendarView.alarmCompleteImageView.removeFromSuperview()
                }
            }
        }
    }
}
    
extension CalendarViewController {
    
    private func setAPI() {
        calendarViewModel.loadUpComing()
        univViewModel.loadUnivList()
        alarmViewModel.loadAlarmList()
        
        Observable
            .combineLatest(
                calendarViewModel.upComingSchedules.take(1),
                univViewModel.univList.take(1),
                alarmViewModel.alarmList.take(1)
            )
            .do(onSubscribe: { [weak self] in
                self?.isLoading.accept(true)
            }, onDispose: { [weak self] in
                // 정상/에러 상관없이 구독 종료 시 로딩 해제
                self?.isLoading.accept(false)
            })
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                // 필요 시 추가 후처리 가능 (없으면 비워두기)
            }, onError: { _ in
                // 에러 시에도 로딩은 onDispose에서 내려가므로 여기서는 알림만
                // self?.showToast("불러오기에 실패했어요") 등
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        isLoading
          .asDriver()
          .drive(calendarView.activityIndicator.rx.isAnimating)
          .disposed(by: disposeBag)

        calendarView.calendarMainCollectionView.rx.observe(CGSize.self, "contentSize")
            .compactMap { $0?.height }
            .map { $0 + 65 } // 기존 상수 보정치 유지
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] h in
                self?.calendarHeightConstraint?.update(offset: h)
                self?.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        univViewModel.univList
            .subscribe(onNext: { univList in
                if !univList.isEmpty {
                    self.calendarView.univAlertView.isHidden = true
                    self.calendarView.univAlertImageView.isHidden = true
                    self.calendarView.univSettingButton.setTitle("⠀⠀⠀⠀⠀⠀⠀모든 학교  ", for: .normal)
                } else {
                    self.calendarView.univAlertView.isHidden = false
                    self.calendarView.univAlertImageView.isHidden = false
                    self.calendarView.univSettingButton.setTitle("대학교를 설정하세요!  ", for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        calendarView.upComingCalendarCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        calendarViewModel.upComingSchedules
            .subscribe(onNext: { scheduleList in
                if scheduleList.isEmpty {
                    self.calendarView.upComingCalendarCollectionView.isHidden = true
                    self.calendarView.noUnivView.isHidden = false
                } else {
                    self.calendarView.upComingCalendarCollectionView.isHidden = false
                    self.calendarView.noUnivView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        calendarViewModel.upComingSchedules
            .bind(to: calendarView.upComingCalendarCollectionView.rx.items(cellIdentifier: UpComingCalendarCollectionViewCell.identifier, cellType: UpComingCalendarCollectionViewCell.self)) { _, schedule, cell in
                cell.prepare(upComingList: schedule)
            }
            .disposed(by: disposeBag)
        
        alarmViewModel.alarmList
            .subscribe(onNext: { alarmList in
                self.calendarView.calendarMainCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        calendarView.calendarDetailTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        calendarViewModel.dateSelectSchedules
            .bind(to: calendarView.calendarDetailTableView.rx.items(cellIdentifier: CalendarDetailTableViewCell.identifier, cellType: CalendarDetailTableViewCell.self)) { _, schedule, cell in
                cell.prepare(dateSelectList: schedule)
            }
            .disposed(by: disposeBag)
        
        calendarView.calendarDetailTableView.rx.observe(CGSize.self, "contentSize")
            .compactMap { $0?.height }
            .map { max($0, 8) } // 최소 높이 8 유지(기존 로직 반영)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] h in
                self?.dateSelectHeightConstraint?.update(offset: h)
                self?.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.isAlarmComplete)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.alarmSettingComplete()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        self.calendarView.calendarMainCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        calendarView.days
            .bind(to:
                    calendarView.calendarMainCollectionView.rx.items(cellIdentifier: CalendarMainCollectionViewCell.identifier, cellType: CalendarMainCollectionViewCell.self)) { index, day, cell in
                
                let currentMonthStartIndex = self.calendarView.startDayOfTheWeek()
                let isCurrentMonth = index >= currentMonthStartIndex &&
                index < currentMonthStartIndex + self.calendarView.endDate()
                
                let today = Date()
                let todayComponents = Calendar.current.dateComponents([.day, .month, .year], from: today)
                let calendarComponents = Calendar.current.dateComponents([.month, .year], from: self.calendarView.calendarDate)
                let isToday = day == "\(todayComponents.day!)" &&
                todayComponents.month == calendarComponents.month &&
                todayComponents.year == calendarComponents.year
                cell.updateDay(day: day, isToday: isToday, isCurrentMonth: isCurrentMonth)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                if let dayInt = Int(day), dayInt > 0 {
                    var components = self.calendarView.calendar.dateComponents([.year, .month], from: self.calendarView.calendarDate)
                    components.day = dayInt
                    if let date = self.calendarView.calendar.date(from: components) {
                        let dateString = dateFormatter.string(from: date)
                        // 알람이 있는 날짜인지 확인
                        if self.alarmViewModel.alarmList.value.contains(where: { $0.alarmDate == dateString }) {
                            cell.dotImageView.isHidden = false
                        } else {
                            cell.dotImageView.isHidden = true
                        }
                    }
                } else {
                    cell.dotImageView.isHidden = true
                }
            }
                    .disposed(by: disposeBag)
        
        calendarView.calendarMainCollectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] selectedDay in
                guard let self = self else { return }
                
                let dayNum = Int(selectedDay) ?? 0
                let date = calendarView.dateLabel.text ?? ""
                let replacedString = date.replacingOccurrences(of: " ", with: "")
                let reReplacedString = replacedString.replacingOccurrences(of: "년|월", with: "-", options: .regularExpression)
                
                if dayNum <= 9 {
                    calendarViewModel.loadDateSelect(date: "\(reReplacedString)0\(selectedDay)")
                } else {
                    calendarViewModel.loadDateSelect(date: "\(reReplacedString)\(selectedDay)")
                }
            })
            .disposed(by: disposeBag)
        
        calendarView.calendarMainCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                if let previousIndexPath = self.selectedIndexPath, previousIndexPath != indexPath {
                    self.calendarView.calendarMainCollectionView.deselectItem(at: previousIndexPath, animated: false)
                    if let cell = self.calendarView.calendarMainCollectionView.cellForItem(at: previousIndexPath) as? CalendarMainCollectionViewCell {
                        cell.isSelected = false
                    }
                }
                
                self.selectedIndexPath = indexPath
                if let cell = self.calendarView.calendarMainCollectionView.cellForItem(at: indexPath) as? CalendarMainCollectionViewCell {
                    cell.isSelected = true
                }
            })
            .disposed(by: disposeBag)
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == calendarView.calendarMainCollectionView {
            let width = self.calendarView.weekStackView.frame.width / 7
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 200, height: 108)
        }
    }
}

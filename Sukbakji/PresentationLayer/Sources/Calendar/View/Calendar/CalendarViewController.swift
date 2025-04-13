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
    private let viewModel = CalendarViewModel()
    private let disposeBag = DisposeBag()
    
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

        callAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.calendarHeightConstraint?.update(offset: calendarView.calendarMainCollectionView.contentSize.height + 65)
    }
}

extension CalendarViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        calendarView.calendarBackgroundView.snp.makeConstraints { make in
            calendarHeightConstraint = make.height.equalTo(300).constraint
        }
        calendarView.calendarDetailTableView.snp.makeConstraints { make in
            dateSelectHeightConstraint = make.height.equalTo(10).constraint
        }

        calendarView.notificationButton.addTarget(self, action: #selector(notification_Tapped), for: .touchUpInside)
        calendarView.mypageButton.addTarget(self, action: #selector(schoolCalendar_Tapped), for: .touchUpInside)
        calendarView.univSettingButton.addTarget(self, action: #selector(schoolSetting_Tapped), for: .touchUpInside)
        calendarView.alarmButton.addTarget(self, action: #selector(alarm_Tapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(alarmSettingComplete), name: .isAlarmComplete, object: nil)
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
                    self.calendarView.alarmCompleteImageView.removeFromSuperview() // 뷰 제거
                }
            }
        }
    }
}
    
extension CalendarViewController {
    
    private func callAPI() {
        calendarView.activityIndicator.startAnimating()
        DispatchQueue.global().async {
            sleep(1)
            self.setAPI()
            DispatchQueue.main.async {
                self.calendarView.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func setAPI() {
        viewModel.loadUnivList()
        viewModel.loadUpComingSchedule()
        viewModel.loadAlarmList()
    }
    
    private func bindViewModel() {
        viewModel.univList
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
        
        viewModel.upComingSchedules
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
        
        viewModel.upComingSchedules
            .bind(to: calendarView.upComingCalendarCollectionView.rx.items(cellIdentifier: UpComingCalendarCollectionViewCell.identifier, cellType: UpComingCalendarCollectionViewCell.self)) { _, schedule, cell in
                cell.prepare(upComingList: schedule)
            }
            .disposed(by: disposeBag)
        
        viewModel.alarmDates
            .subscribe(onNext: { alarmDates in
                self.calendarView.calendarMainCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        calendarView.calendarDetailTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.dateSelectSchedules
            .bind(to: calendarView.calendarDetailTableView.rx.items(cellIdentifier: CalendarDetailTableViewCell.identifier, cellType: CalendarDetailTableViewCell.self)) { _, schedule, cell in
                cell.prepare(dateSelectList: schedule)
            }
            .disposed(by: disposeBag)
        
        viewModel.dateSelectSchedules
            .subscribe(onNext: { scheduleList in
                if scheduleList.count >= 1 {
                    self.expandHeight(num: scheduleList.count)
                } else {
                    self.reduceHeight()
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        self.calendarView.calendarMainCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        calendarView.days
            .bind(to:
                    calendarView.calendarMainCollectionView.rx.items(cellIdentifier: CalendarMainCollectionViewCell.identifier, cellType: CalendarMainCollectionViewCell.self)) { index, day, cell in
                
                cell.updateDay(day: day)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
                
                if let dayInt = Int(day), dayInt > 0 {
                    var components = self.calendarView.calendar.dateComponents([.year, .month], from: self.calendarView.calendarDate)
                    components.day = dayInt
                    if let date = self.calendarView.calendar.date(from: components) {
                        let dateString = dateFormatter.string(from: date)
                        // 알람이 있는 날짜인지 확인
                        if self.viewModel.alarmDates.value.contains(where: { $0.alarmDate == dateString }) {
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
//                    viewModel.loadDateSelect(date: "\(reReplacedString)0\(selectedDay)")
                    viewModel.loadTestData()
                } else {
//                    viewModel.loadDateSelect(date: "\(reReplacedString)\(selectedDay)")
                    viewModel.loadTestData2()
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
    
    private func expandHeight(num: Int) {
        let addHeight: CGFloat = CGFloat(44 * num + 8)
        
        self.dateSelectHeightConstraint?.update(offset: addHeight)
        self.view.layoutIfNeeded()
    }
    
    private func reduceHeight() {
        let minusHeight: CGFloat = 8
        
        self.dateSelectHeightConstraint?.update(offset: minusHeight)
        self.view.layoutIfNeeded()
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

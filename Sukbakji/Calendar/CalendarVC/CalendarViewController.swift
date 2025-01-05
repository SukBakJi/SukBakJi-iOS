//
//  CalendarViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/15/24.
//

import UIKit
import SnapKit
import Alamofire
import Then
import RxSwift
import RxCocoa
import RxDataSources

class CalendarViewController: UIViewController {
    
    let dateSelectViewModel = DateSelectViewModel()
    let upComingViewModel = UpComingViewModel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleView = UIView().then {
        $0.backgroundColor = .white
    }
    private let titleLabel = UILabel().then {
        $0.text = "캘린더"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 22)
    }
    private let notificationButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Notification"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    private let mypageButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Mypage"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray200
    }
    private let dateLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let univSettingButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Down"), for: .normal)
        $0.setTitle("대학교를 설정하세요!  ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(UIColor(named: "Coquelicot"), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    private let calendarBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(named: "ViewBackground")
        $0.layer.cornerRadius = 10
    }
    private lazy var weekStackView = UIStackView()
    private lazy var calendarMainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CalendarMainCollectionViewCell.self, forCellWithReuseIdentifier: CalendarMainCollectionViewCell.identifier)
        cv.allowsSelection = true
        cv.allowsMultipleSelection = false
        cv.backgroundColor = .clear
        
        return cv
    }()
    private let univAlertImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Rectangle")
    }
    private let univAlertView = UIView().then {
        $0.backgroundColor = UIColor(hexCode: "FF5614")
        $0.layer.cornerRadius = 10
    }
    private let univAlertLabel = UILabel().then {
        $0.text = "대학교 설정하고 일정을 확인해 보세요!"
        $0.textColor = .white
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private var calendarDetailTableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(CalendarDetailTableViewCell.self, forCellReuseIdentifier: CalendarDetailTableViewCell.identifier)
        $0.layer.masksToBounds = true// any value you want
        $0.layer.shadowOpacity = 0.2// any value you want
        $0.layer.shadowRadius = 2 // any value you want
        $0.layer.shadowOffset = .init(width: 0, height: 0.2)
        $0.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    private let upComingLabel = UILabel().then {
        $0.text = "다가오는 일정"
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let upComingImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Date")
    }
    private var upComingCalendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UpComingCalendarCollectionViewCell.self, forCellWithReuseIdentifier: UpComingCalendarCollectionViewCell.identifier)
        cv.allowsSelection = false
        cv.backgroundColor = .clear
        cv.layer.masksToBounds = false// any value you want
        cv.layer.shadowOpacity = 0.2// any value you want
        cv.layer.shadowRadius = 2 // any value you want
        cv.layer.shadowOffset = .init(width: 0, height: 0.2)
        
        return cv
    }()
    private let alarmButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Alarm"), for: .normal)
    }
    private let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.color = UIColor(named: "Coquelicot")
    }
    
    private let disposeBag = DisposeBag()
    
    private var calendarHeightConstraint: NSLayoutConstraint?
    private var dateSelectHeightConstraint: NSLayoutConstraint?
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var calendarDate = Date()
    private var days = BehaviorRelay<[String]>(value: [])
    
    private var selectedIndexPath: IndexPath?
    
    private var alarmDatas: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        configureCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
//        getAlarmList()
//        setUpComingAPI()
//        getUnivList()
//        callAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // collectionView의 contentSize로 backgroundView의 높이 업데이트
        calendarHeightConstraint?.constant = calendarMainCollectionView.contentSize.height + 65
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(955)
        }
        
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(95)
        }
        
        self.titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(11)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(26)
        }
        
        self.titleView.addSubview(mypageButton)
        mypageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalTo(titleLabel)
            make.height.width.equalTo(48)
        }
        mypageButton.addTarget(self, action: #selector(schoolCalendar_Tapped), for: .touchUpInside)
        
        self.titleView.addSubview(notificationButton)
        notificationButton.snp.makeConstraints { make in
            make.trailing.equalTo(mypageButton.snp.leading)
            make.centerY.equalTo(titleLabel)
            make.height.width.equalTo(48)
        }
        
        self.titleView.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(115)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.contentView.addSubview(univSettingButton)
        univSettingButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(158)
            make.height.equalTo(30)
        }
        univSettingButton.addTarget(self, action: #selector(schoolSetting_Tapped), for: .touchUpInside)
        
        self.contentView.addSubview(calendarBackgroundView)
        calendarBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        calendarHeightConstraint = calendarBackgroundView.heightAnchor.constraint(equalToConstant: 300)
        calendarHeightConstraint?.isActive = true
        
        self.calendarBackgroundView.addSubview(weekStackView)
        self.weekStackView.distribution = .fillEqually
        weekStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.trailing.equalToSuperview().inset(7)
            make.height.equalTo(40)
        }
        
        calendarMainCollectionView.tag = 1
        self.calendarBackgroundView.addSubview(calendarMainCollectionView)
        calendarMainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weekStackView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(7)
            make.bottom.equalToSuperview().inset(5)
        }
        
        self.contentView.addSubview(univAlertImageView)
        univAlertImageView.snp.makeConstraints { make in
            make.top.equalTo(univSettingButton.snp.bottom).offset(5.5)
            make.trailing.equalToSuperview().inset(20)
        }
        univAlertImageView.isHidden = true
        
        self.contentView.addSubview(univAlertView)
        univAlertView.snp.makeConstraints { make in
            make.top.equalTo(univAlertImageView.snp.bottom)
            make.trailing.equalToSuperview().inset(8)
            make.height.equalTo(36)
        }
        univAlertView.isHidden = true
        
        self.univAlertView.addSubview(univAlertLabel)
        univAlertLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(12)
            make.height.equalTo(14)
        }
        
        self.contentView.addSubview(calendarDetailTableView)
        calendarDetailTableView.snp.makeConstraints { make in
            make.top.equalTo(calendarBackgroundView.snp.bottom)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(10)
        }
        dateSelectHeightConstraint = calendarDetailTableView.heightAnchor.constraint(equalToConstant: 10)
        dateSelectHeightConstraint?.isActive = true
        
        self.contentView.addSubview(upComingLabel)
        upComingLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarDetailTableView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.contentView.addSubview(upComingImageView)
        upComingImageView.snp.makeConstraints { make in
            make.centerY.equalTo(upComingLabel)
            make.leading.equalTo(upComingLabel.snp.trailing).offset(4)
            make.height.width.equalTo(20)
        }
        
        upComingCalendarCollectionView.tag = 2
        self.contentView.addSubview(upComingCalendarCollectionView)
        upComingCalendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(upComingLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(108)
        }
        
        self.view.addSubview(alarmButton)
        alarmButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(112)
            make.trailing.equalToSuperview().inset(24)
            make.height.width.equalTo(60)
        }
        alarmButton.addTarget(self, action: #selector(alarm_Tapped), for: .touchUpInside)
        
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    private func configureCalendar() {
        self.configureWeekLabel()
        self.bindCollectionView()
        self.configureDate()
    }
    
    private func configureWeekLabel() {
        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            label.textAlignment = .center
            label.font = UIFont(name: "SUITE-SemiBold", size: 14)
            self.weekStackView.addArrangedSubview(label)
        }
    }
    
    private func configureDate() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        self.updateCalendar()
    }
    
    private func startDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self.calendarDate) - 1
    }
    
    private func endDate() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
    }
    
    private func updateTitle(){
        let date = self.dateFormatter.string(from: self.calendarDate)
        self.dateLabel.text = date
    }
    
    private func updateDays(){
        days.accept([])
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let totalDays = startDayOfTheWeek + self.endDate()
        
        let day = (0..<totalDays).map { day -> String in
            return day < startDayOfTheWeek ? "" : "\(day - startDayOfTheWeek + 1)"
        }
        days.accept(day)
        
        self.calendarMainCollectionView.reloadData()
    }
    
    private func updateCalendar() {
        self.updateTitle()
        self.updateDays()
    }
    
    private func callAPI() {
        activityIndicator.startAnimating()
        DispatchQueue.global().async {
            sleep(1)
            self.setAlarmListAPI()
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func bindCollectionView() {
        self.calendarMainCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // daysRelay를 collectionView에 바인딩
        days
            .bind(to: calendarMainCollectionView.rx.items(cellIdentifier: CalendarMainCollectionViewCell.identifier, cellType: CalendarMainCollectionViewCell.self)) { index, day, cell in
                
                cell.updateDay(day: day)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                if let dayInt = Int(day), dayInt > 0 {
                    var components = self.calendar.dateComponents([.year, .month], from: self.calendarDate)
                    components.day = dayInt
                    if let date = self.calendar.date(from: components) {
                        let dateString = dateFormatter.string(from: date)
                        // 알람이 있는 날짜인지 확인
                        if self.alarmDatas.contains(dateString) {
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
        
        calendarMainCollectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] selectedDay in
                guard let self = self else { return }
                
                let dayNum = Int(selectedDay) ?? 0
                let date = dateLabel.text ?? ""
                let replacedString = date.replacingOccurrences(of: " ", with: "")
                let reReplacedString = replacedString.replacingOccurrences(of: "년|월", with: "-", options: .regularExpression)
                
                if dayNum <= 9 {
                    setDateSelectAPI(date: "\(reReplacedString)0\(selectedDay)")
                } else {
                    setDateSelectAPI(date: "\(reReplacedString)\(selectedDay)")
                }
            })
            .disposed(by: disposeBag)
        
        // 선택된 indexPath 처리 (선택된 셀 스타일 업데이트용)
        calendarMainCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                if let previousIndexPath = self.selectedIndexPath, previousIndexPath != indexPath {
                    self.calendarMainCollectionView.deselectItem(at: previousIndexPath, animated: false)
                    if let cell = self.calendarMainCollectionView.cellForItem(at: previousIndexPath) as? CalendarMainCollectionViewCell {
                        cell.isSelected = false
                    }
                }
                
                // 새로운 셀 선택
                self.selectedIndexPath = indexPath
                if let cell = self.calendarMainCollectionView.cellForItem(at: indexPath) as? CalendarMainCollectionViewCell {
                    cell.isSelected = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setUnivListAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendarUniv.path
        
        APIService().getWithAccessToken(of: APIResponse<UnivList>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                if !response.result.univList.isEmpty {
                    self.univAlertView.isHidden = true
                    self.univAlertImageView.isHidden = true
                    self.univSettingButton.setTitle("모든 학교  ", for: .normal)
                }
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    private func setUpComingData() {
        upComingCalendarCollectionView.delegate = nil
        upComingCalendarCollectionView.dataSource = nil
        
        upComingCalendarCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.upComingViewModel.upComingItems
            .observe(on: MainScheduler.instance)
            .bind(to: self.upComingCalendarCollectionView.rx.items(cellIdentifier: UpComingCalendarCollectionViewCell.identifier, cellType: UpComingCalendarCollectionViewCell.self)) { index, item, cell in
                cell.prepare(upComingResult: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUpComingAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendarSchedule.path
        
        APIService().getWithAccessToken(of: APIResponse<UpComing>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                let resultData = response.result.scheduleList.filter { $0.dday >= 0 && $0.dday <= 10 }
                self.upComingViewModel.upComingItems = Observable.just(resultData)
                self.setUpComingData()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    private func setDateSelectData() {
        calendarDetailTableView.delegate = nil
        calendarDetailTableView.dataSource = nil
        
        calendarDetailTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<DateSelectSection>(
            configureCell: { _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarDetailTableViewCell.identifier, for: indexPath) as? CalendarDetailTableViewCell else {
                    return UITableViewCell()
                }
                cell.prepare(dateSelectList: item)
                return cell
            }
        )
        
        self.dateSelectViewModel.dateSelectItems
                .map { [DateSelectSection(items: $0)] } // 각 아이템을 섹션으로 만듦
                .observe(on: MainScheduler.instance)
                .bind(to: self.calendarDetailTableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
    }
    
    private func setDateSelectAPI(date: String) {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendarScheduleDate(date).path
        
        let params = [
            "date": date
        ] as [String : Any]
        
        APIService().getWithAccessTokenParameters(of: APIResponse<DateSelect>.self, url: url, parameters: params, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                self.dateSelectViewModel.dateSelectItems = Observable.just(response.result.scheduleList)
                let resultCount = response.result.scheduleList.count
                if resultCount >= 1 {
                    self.expandHeight(num: resultCount)
                } else {
                    self.reduceHeight()
                }
                self.setDateSelectData()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    private func expandHeight(num: Int) {
        let addHeight: CGFloat = CGFloat(44 * num + 10) // 늘리고 싶은 높이 값을 설정 (예시)
        
        self.dateSelectHeightConstraint?.constant = addHeight
        self.view.layoutIfNeeded()
    }
    
    private func reduceHeight() {
        let minusHeight: CGFloat = 10 // 줄이고 싶은 높이 값을 설정 (예시)
        
        self.dateSelectHeightConstraint?.constant = minusHeight
        self.view.layoutIfNeeded()
    }
    
    private func setAlarmListAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendarAlarm.path
        
        APIService().getWithAccessToken(of: APIResponse<AlarmList>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                let alarmData = response.result.alarmList
                for i in 0..<alarmData.count {
                    self.alarmDatas.append(alarmData[i].alarmDate)
                }
                self.calendarMainCollectionView.reloadData()
            default:
                AlertController(message: response.message).show()
            }
        }
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
        let alarmFBCView = AlarmFBCView(target: self)
        
        self.view.addSubview(alarmFBCView)
        alarmFBCView.alpha = 0
        alarmFBCView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            alarmFBCView.alpha = 1
        }
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            let width = self.weekStackView.frame.width / 7
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 200, height: 108)
        }
    }
}

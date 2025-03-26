//
//  CalendarView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/20/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class CalendarView: UIView {
    
    let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    var calendarDate = Date()
    var days = BehaviorRelay<[String]>(value: [])
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
    let titleView = UIView().then {
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then {
        $0.text = "캘린더"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 22)
        $0.textColor = .gray900
    }
    let notificationButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Notification"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    let mypageButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Mypage"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let dateView = UIView().then {
        $0.backgroundColor = .clear
    }
    let dateLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let univSettingButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Down"), for: .normal)
        $0.setTitle("대학교를 설정하세요!  ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(.orange700, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    let calendarBackgroundView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 10
    }
    lazy var weekStackView = UIStackView()
    lazy var calendarMainCollectionView: UICollectionView = {
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
    let univAlertImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Rectangle")
    }
    let univAlertView = UIView().then {
        $0.backgroundColor = .orange500
        $0.layer.cornerRadius = 10
    }
    let univAlertLabel = UILabel().then {
        $0.text = "대학교 설정하고 일정을 확인해 보세요!"
        $0.textColor = .white
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    var calendarDetailTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(CalendarDetailTableViewCell.self, forCellReuseIdentifier: CalendarDetailTableViewCell.identifier)
    }
    let upComingView = UIView().then {
        $0.backgroundColor = .clear
    }
    let upComingLabel = UILabel().then {
        $0.text = "다가오는 일정"
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    let upComingImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Date")
    }
    var upComingCalendarCollectionView: UICollectionView = {
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
        cv.layer.shadowRadius = 1 // any value you want
        cv.layer.shadowOffset = .init(width: 0, height: 0.2)
        
        return cv
    }()
    let alarmButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Alarm"), for: .normal)
    }
    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.color = .orange700
    }
    let alarmCompleteImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_AlarmComplete")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        configureCalendar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(mypageButton)
        titleView.addSubview(notificationButton)
        titleView.addSubview(backgroundLabel)
        
        contentView.addSubview(dateView)
        dateView.addSubview(dateLabel)
        dateView.addSubview(univSettingButton)
        
        contentView.addSubview(calendarBackgroundView)
        calendarBackgroundView.addSubview(weekStackView)
        calendarBackgroundView.addSubview(calendarMainCollectionView)
        
        contentView.addSubview(univAlertImageView)
        contentView.addSubview(univAlertView)
        univAlertView.addSubview(univAlertLabel)
        
        contentView.addSubview(calendarDetailTableView)
        
        contentView.addSubview(upComingView)
        upComingView.addSubview(upComingLabel)
        upComingView.addSubview(upComingImageView)
        upComingView.addSubview(upComingCalendarCollectionView)
        
        addSubview(alarmButton)
        addSubview(activityIndicator)
        addSubview(alarmCompleteImageView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(955)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(95)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(11)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(26)
        }
        
        mypageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalTo(titleLabel)
            make.height.width.equalTo(48)
        }
        
        notificationButton.snp.makeConstraints { make in
            make.trailing.equalTo(mypageButton.snp.leading)
            make.centerY.equalTo(titleLabel)
            make.height.width.equalTo(48)
        }
        
        backgroundLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        dateView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(95)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(61)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        univSettingButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(158)
            make.height.equalTo(30)
        }
        
        calendarBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        self.weekStackView.distribution = .fillEqually
        weekStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.trailing.equalToSuperview().inset(7)
            make.height.equalTo(40)
        }

        calendarMainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weekStackView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(7)
            make.bottom.equalToSuperview().inset(5)
        }
        
        univAlertImageView.snp.makeConstraints { make in
            make.top.equalTo(univSettingButton.snp.bottom).offset(5.5)
            make.trailing.equalToSuperview().inset(20)
        }
        
        univAlertView.snp.makeConstraints { make in
            make.top.equalTo(univAlertImageView.snp.bottom)
            make.trailing.equalToSuperview().inset(8)
            make.height.equalTo(36)
        }
        
        univAlertLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(12)
            make.height.equalTo(14)
        }
        
        calendarDetailTableView.snp.makeConstraints { make in
            make.top.equalTo(calendarBackgroundView.snp.bottom)
            make.trailing.leading.equalToSuperview()
        }
        
        upComingView.snp.makeConstraints { make in
            make.top.equalTo(calendarDetailTableView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(169)
        }
        
        upComingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        upComingImageView.snp.makeConstraints { make in
            make.centerY.equalTo(upComingLabel)
            make.leading.equalTo(upComingLabel.snp.trailing).offset(4)
            make.height.width.equalTo(20)
        }
        
        upComingCalendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(upComingLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(108)
        }
        
        alarmButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(112)
            make.trailing.equalToSuperview().inset(24)
            make.height.width.equalTo(60)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        alarmCompleteImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(112)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(215)
        }
        alarmCompleteImageView.alpha = 0
    }
    
    private func configureCalendar() {
        self.configureWeekLabel()
        self.configureDate()
    }
    
    private func configureWeekLabel() {
        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            label.textAlignment = .center
            label.font = UIFont(name: "SUITE-SemiBold", size: 14)
            label.textColor = .gray900
            self.weekStackView.addArrangedSubview(label)
        }
    }
    
    private func configureDate() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        self.updateCalendar()
    }
    
    private func updateCalendar() {
        self.updateTitle()
        self.updateDays()
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
}

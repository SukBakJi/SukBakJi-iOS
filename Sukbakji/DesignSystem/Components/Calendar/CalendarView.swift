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
        $0.backgroundColor = .white
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
        
        return cv
    }()
    let noUnivView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    let layerImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Layer")
    }
    var noUnivLabel = UILabel().then {
        $0.text = "대학교를 설정하고\n일정을 확인해 보세요!"
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let alarmButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Alarm"), for: .normal)
    }
    let activityIndicator = UIActivityIndicatorView(style: .large).then {
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
        upComingView.addSubview(noUnivView)
        noUnivView.addSubview(layerImageView)
        noUnivView.addSubview(noUnivLabel)
        upComingView.addSubview(upComingCalendarCollectionView)
        
        addSubview(alarmButton)
        addSubview(activityIndicator)
        addSubview(alarmCompleteImageView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(noUnivView.snp.bottom).offset(120)
        }
        
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(26)
        }
        
        mypageButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(titleLabel)
            $0.height.width.equalTo(48)
        }
        
        notificationButton.snp.makeConstraints {
            $0.trailing.equalTo(mypageButton.snp.leading)
            $0.centerY.equalTo(titleLabel)
            $0.height.width.equalTo(48)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        dateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(61)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        univSettingButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(158)
            $0.height.equalTo(30)
        }
        
        calendarBackgroundView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        weekStackView.distribution = .fillEqually
        weekStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.trailing.equalToSuperview().inset(7)
            $0.height.equalTo(40)
        }

        calendarMainCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(7)
            $0.bottom.equalToSuperview().inset(5)
        }
        
        univAlertImageView.snp.makeConstraints {
            $0.top.equalTo(univSettingButton.snp.bottom).offset(5.5)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        univAlertView.snp.makeConstraints {
            $0.top.equalTo(univAlertImageView.snp.bottom)
            $0.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(36)
        }
        
        univAlertLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.leading.equalToSuperview().inset(12)
            $0.height.equalTo(14)
        }
        
        calendarDetailTableView.snp.makeConstraints {
            $0.top.equalTo(calendarBackgroundView.snp.bottom).offset(8)
            $0.trailing.leading.equalToSuperview()
        }
        
        upComingView.snp.makeConstraints {
            $0.top.equalTo(calendarDetailTableView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(169)
        }
        
        upComingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        upComingImageView.snp.makeConstraints {
            $0.centerY.equalTo(upComingLabel)
            $0.leading.equalTo(upComingLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(20)
        }
        
        upComingCalendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(upComingLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(108)
        }
        upComingCalendarCollectionView.isHidden = true
        
        noUnivView.snp.makeConstraints {
            $0.top.equalTo(upComingLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(108)
            $0.width.equalTo(200)
        }
        
        layerImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(8)
        }
        
        noUnivLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(layerImageView.snp.trailing).offset(10)
            $0.height.equalTo(52)
        }
        
        alarmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(112)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(60)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
        alarmCompleteImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(112)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
            $0.width.equalTo(215)
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
    
    func startDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self.calendarDate) - 1
    }
    
    func endDate() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
    }
    
    private func updateTitle(){
        let date = self.dateFormatter.string(from: self.calendarDate)
        self.dateLabel.text = date
    }
    
    private func updateDays() {
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let numberOfDaysInMonth = self.endDate()

        // 이전 달 계산
        let prevMonthDate = calendar.date(byAdding: .month, value: -1, to: calendarDate)!
        let daysInPrevMonth = calendar.range(of: .day, in: .month, for: prevMonthDate)?.count ?? 30
        let leadingDays = (daysInPrevMonth - startDayOfTheWeek + 1)...daysInPrevMonth

        // 이번 달 날짜
        let currentMonthDays = (1...numberOfDaysInMonth)

        // 다음 달 채워야 하는 개수
        let totalGridCount = ((startDayOfTheWeek + numberOfDaysInMonth) % 7 == 0)
            ? startDayOfTheWeek + numberOfDaysInMonth
            : ((startDayOfTheWeek + numberOfDaysInMonth) / 7 + 1) * 7
        let trailingDaysCount = totalGridCount - (startDayOfTheWeek + numberOfDaysInMonth)
        let trailingDays: [Int] = trailingDaysCount > 0 ? Array(1...trailingDaysCount) : []

        var fullDays: [(day: String, isCurrentMonth: Bool)] = []

        leadingDays.forEach { fullDays.append(("\($0)", false)) }
        currentMonthDays.forEach { fullDays.append(("\($0)", true)) }
        trailingDays.forEach { fullDays.append(("\($0)", false)) }

        self.days.accept(fullDays.map { $0.day })

        self.calendarMainCollectionView.reloadData()
    }
}

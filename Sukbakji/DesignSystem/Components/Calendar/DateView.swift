//
//  DateView.swift
//  Sukbakji
//
//  Created by jaegu park on 1/5/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

protocol dateProtocol:AnyObject {
    func dateSend(data: String)
}

class DateView: UIView {
    
    var mainView = UIView().then {
       $0.backgroundColor = .white
       $0.layer.cornerRadius = 12
    }
    var backButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Dismiss"), for: .normal)
    }
    var yearLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    var previousButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Left"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_LeftDisabled"), for: .disabled)
    }
    var monthLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    var nextButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Right"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RightDisabled"), for: .disabled)
    }
    lazy var weekStackView = UIStackView()
    lazy var alarmDateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(AlarmDateCollectionViewCell.self, forCellWithReuseIdentifier: AlarmDateCollectionViewCell.identifier)
        cv.allowsSelection = true
        cv.allowsMultipleSelection = false
        cv.backgroundColor = .clear
        
        return cv
    }()
    
    private let disposeBag = DisposeBag()
    
    private let calendar = Calendar.current
    private let dateYearFormatter = DateFormatter()
    private let dateMonthFormatter = DateFormatter()
    private let now = Date()
    private var calendarYear = Date()
    private var calendarMonth = Date()
    private var calendarDate = Date()
    
    private var dateData: String = ""
    
    weak var delegate: dateProtocol?
    
    private var selectedIndexPath: IndexPath?
    
    private var days = BehaviorRelay<[String]>(value: [])
    
    init() {
        super.init(frame: .zero)
        setUI()
        configureCalendar()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(48)
            $0.height.equalTo(420)
        }
        
        mainView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.height.width.equalTo(32)
        }
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        mainView.addSubview(yearLabel)
        yearLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(21)
        }
        
        mainView.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(18)
            $0.trailing.equalToSuperview().inset(19.5)
            $0.height.width.equalTo(20.5)
        }
        nextButton.addTarget(self, action: #selector(goToNextMonth), for: .touchUpInside)
        
        mainView.addSubview(monthLabel)
        monthLabel.snp.makeConstraints {
            $0.centerY.equalTo(nextButton)
            $0.trailing.equalTo(nextButton.snp.leading).offset(-6)
            $0.height.equalTo(21)
        }
        
        mainView.addSubview(previousButton)
        previousButton.snp.makeConstraints {
            $0.centerY.equalTo(nextButton)
            $0.trailing.equalTo(monthLabel.snp.leading).offset(-6)
            $0.height.width.equalTo(20.5)
        }
        previousButton.addTarget(self, action: #selector(goToPreviousMonth), for: .touchUpInside)
        
        mainView.addSubview(weekStackView)
        weekStackView.distribution = .fillEqually
        weekStackView.snp.makeConstraints {
            $0.top.equalTo(yearLabel.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(7)
            $0.height.equalTo(40)
        }
        
        mainView.addSubview(alarmDateCollectionView)
        alarmDateCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(7)
            $0.bottom.equalToSuperview().inset(5)
        }
    }
    
    private func configureCalendar() {
        self.configureWeekLabel()
        self.bindCollectionView()
        self.configureDate()
        self.updateButtonStates()
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
        let componentsYear = self.calendar.dateComponents([.year], from: Date())
        let componentsMonth = self.calendar.dateComponents([.month], from: Date())
        self.calendarYear = self.calendar.date(from: componentsYear) ?? Date()
        self.calendarMonth = self.calendar.date(from: componentsMonth) ?? Date()
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateYearFormatter.dateFormat = "yyyy년"
        self.dateMonthFormatter.dateFormat = "MM월"
        self.updateCalendar()
    }
    
    private func startDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self.calendarDate) - 1
    }
    
    private func endDate() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
    }
    
    private func updateTitle(){
        let dateYear = self.dateYearFormatter.string(from: self.calendarYear)
        let dateMonth = self.dateMonthFormatter.string(from: self.calendarMonth)
        self.yearLabel.text = dateYear
        self.monthLabel.text = dateMonth
    }
    
    private func updateDays(){
        days.accept([])
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let totalDays = startDayOfTheWeek + self.endDate()
        
        let day = (0..<totalDays).map { day -> String in
            return day < startDayOfTheWeek ? "" : "\(day - startDayOfTheWeek + 1)"
        }
        days.accept(day)
        
        self.alarmDateCollectionView.reloadData()
    }
    
    private func updateCalendar() {
        self.updateTitle()
        self.updateDays()
    }
    
    private func bindCollectionView() {
        self.alarmDateCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        days
            .bind(to: alarmDateCollectionView.rx.items(cellIdentifier: AlarmDateCollectionViewCell.identifier, cellType: AlarmDateCollectionViewCell.self)) { index, day, cell in
                cell.updateDay(day: day)
            }
            .disposed(by: disposeBag)
        
        alarmDateCollectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] selectedDay in
                guard let self = self else { return }
                
                let dayNum = Int(selectedDay)
                let date = yearLabel.text!
                let month = monthLabel.text!
                
                if dayNum! >= 10 {
                    dateData = "\(date) \(month) \(selectedDay)일"
                } else {
                    dateData = "\(date) \(month) 0\(selectedDay)일"
                }
                
                self.delegate?.dateSend(data: self.dateData)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.alpha = 0
                }) { _ in
                    self.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        alarmDateCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.alarmDateCollectionView.reloadItems(at: [indexPath])
            })
            .disposed(by: disposeBag)
    }
    
    private func updateButtonStates() {
        let isPrevDisabled = calendar.component(.year, from: calendarDate) == calendar.component(.year, from: now)
            && calendar.component(.month, from: calendarDate) <= calendar.component(.month, from: now)
        previousButton.isEnabled = !isPrevDisabled

        let isNextDisabled = calendar.component(.year, from: calendarDate) >= calendar.component(.year, from: now)
            && calendar.component(.month, from: calendarDate) >= 12
        nextButton.isEnabled = !isNextDisabled
    }
    
    @objc private func dismissView() {
       UIView.animate(withDuration: 0.3, animations: {
          self.alpha = 0
       }) { _ in
          self.removeFromSuperview()
       }
    }
    
    @objc private func goToPreviousMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: -1, to: calendarDate) else { return }

        if calendar.isDate(newDate, equalTo: now, toGranularity: .year),
           calendar.component(.month, from: newDate) < calendar.component(.month, from: now) {
            return
        }

        calendarDate = newDate
        calendarMonth = newDate
        updateCalendar()
        updateButtonStates()
    }
    
    @objc private func goToNextMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: 1, to: calendarDate) else { return }

        if calendar.component(.year, from: newDate) > calendar.component(.year, from: now) {
            return
        }

        calendarDate = newDate
        calendarMonth = newDate
        updateCalendar()
        updateButtonStates()
    }
}

extension DateView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.weekStackView.frame.width / 7
        return CGSize(width: width, height: width)
    }
}

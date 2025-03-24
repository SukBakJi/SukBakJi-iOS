//
//  MyAlarmView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/28/25.
//

import UIKit
import SnapKit
import Then

class MyAlarmView: UIView {
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var calendarDate = Date()
    
    let navigationbarView = NavigationBarView(title: "내 알람")
    let addAlarmButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Add"), for: .normal)
    }
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let dateLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    let dateSelectButton = UIButton().then {
        $0.setImage(UIImage(named: "More 2"), for: .normal)
    }
    var myAlarmTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(MyAlarmTableViewCell.self, forCellReuseIdentifier: MyAlarmTableViewCell.identifier)
    }
    let alarmCompleteImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_AlarmComplete")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        configureDate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white

        addSubview(navigationbarView)
        addSubview(addAlarmButton)
        addSubview(backgroundLabel)
        addSubview(dateLabel)
        addSubview(dateSelectButton)
        addSubview(myAlarmTableView)
        addSubview(alarmCompleteImageView)
    }
    
    private func setupConstraints() {
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        addAlarmButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(47)
            $0.trailing.equalToSuperview().inset(8)
            $0.height.width.equalTo(48)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(backgroundLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        dateSelectButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(2)
            $0.height.equalTo(32)
        }
        
        myAlarmTableView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        alarmCompleteImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(112)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(215)
        }
        alarmCompleteImageView.alpha = 0
    }
    
    private func configureDate() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        let date = self.dateFormatter.string(from: self.calendarDate)
        dateLabel.text = date
    }
}


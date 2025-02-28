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
    }
    
    private func setupConstraints() {
        navigationbarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(95)
        }
        
        addAlarmButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(47)
            make.trailing.equalToSuperview().inset(8)
            make.height.width.equalTo(48)
        }
        
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationbarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        dateSelectButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(dateLabel.snp.trailing).offset(2)
            make.height.equalTo(32)
        }
        
        myAlarmTableView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureDate() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        let date = self.dateFormatter.string(from: self.calendarDate)
        dateLabel.text = date
    }
}


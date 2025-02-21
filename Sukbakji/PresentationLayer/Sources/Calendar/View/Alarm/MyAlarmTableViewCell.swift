//
//  MyAlarmTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/12/24.
//

import UIKit
import Then
import SnapKit

protocol MyAlarmTableViewCellSwitchDelegate: AnyObject {
    func alarmSwitchToggled(cell: MyAlarmTableViewCell, isOn: Bool)
    func editToggled(cell: MyAlarmTableViewCell)
}

class MyAlarmTableViewCell: UITableViewCell {

    static let identifier = String(describing: MyAlarmTableViewCell.self)
    
    weak var delegate: MyAlarmTableViewCellSwitchDelegate?
    
    private let labelView = UIView().then {
        $0.backgroundColor = UIColor(red: 253/255, green: 233/255, blue: 230/255, alpha: 1.0)
        $0.layer.cornerRadius = 6
    }
    private let univLabel = UILabel().then {
        $0.textColor = UIColor(named: "Coquelicot")
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let alarmNameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let alarmDateLabel = UILabel().then {
        $0.textColor = .gray600
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    }
    private let editButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.gray400, for: .normal)
    }
    private let onOffSwitch = UISwitch().then {
        $0.onTintColor = UIColor(named: "Coquelicot")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
       setUI()
    }
    
    private func setUI() {
        self.contentView.backgroundColor = UIColor.orange50
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.gray200.cgColor
        self.contentView.clipsToBounds = true
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 24, bottom: 12, right: 24))
        
        self.contentView.addSubview(labelView)
        labelView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
        self.labelView.addSubview(univLabel)
        univLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(14)
        }
        
        self.contentView.addSubview(alarmNameLabel)
        alarmNameLabel.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(21)
        }
        
        self.contentView.addSubview(alarmDateLabel)
        alarmDateLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmNameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(17)
        }
        
        self.contentView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        editButton.addTarget(self, action: #selector(editToggled), for: .touchUpInside)
        
        self.contentView.addSubview(onOffSwitch)
        onOffSwitch.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(31)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(31)
            make.width.equalTo(51)
        }
        onOffSwitch.addTarget(self, action: #selector(onOffSwitchToggled), for: .valueChanged)
    }
    
    @objc private func onOffSwitchToggled() {
        delegate?.alarmSwitchToggled(cell: self, isOn: onOffSwitch.isOn)
    }
    
    @objc private func editToggled() {
        delegate?.editToggled(cell: self)
    }

    func prepare(alarmList: AlarmList) {
        self.univLabel.text = alarmList.alarmUnivName
        self.alarmNameLabel.text = alarmList.alarmName
        self.alarmDateLabel.text = "\(alarmList.alarmDate) \(alarmList.alarmTime)"
        if alarmList.onoff == 1 {
            self.onOffSwitch.isOn = true
        } else {
            self.onOffSwitch.isOn = false
        }
    }
}

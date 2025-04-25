//
//  MyAlarmTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/12/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

protocol MyAlarmTableViewCellDelegate: AnyObject {
    func alarmSwitch_Toggled(cell: MyAlarmTableViewCell, isOn: Bool)
    func editButton_Tapped(cell: MyAlarmTableViewCell)
}

class MyAlarmTableViewCell: UITableViewCell {

    static let identifier = String(describing: MyAlarmTableViewCell.self)
    
    private var disposeBag = DisposeBag()
    weak var delegate: MyAlarmTableViewCellDelegate?
    
    private let labelView = UIView().then {
        $0.backgroundColor = .orange50
        $0.layer.cornerRadius = 4
    }
    private let univLabel = UILabel().then {
        $0.textColor = .orange600
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let alarmNameLabel = UILabel().then {
        $0.textColor = .gray900
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
        $0.onTintColor = .orange600
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // DisposeBag 재설정
    }
    
    private func setUI() {
        self.contentView.backgroundColor = UIColor.gray50
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.gray200.cgColor
        self.contentView.clipsToBounds = false
        
        self.contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(12)
        }
        
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
        editButton.addTarget(self, action: #selector(editButton_Tapped), for: .touchUpInside)
        
        self.contentView.addSubview(onOffSwitch)
        onOffSwitch.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(31)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(31)
            make.width.equalTo(51)
        }
        onOffSwitch.addTarget(self, action: #selector(alarmSwitch_Toggled), for: .valueChanged)
    }
    
    @objc private func editButton_Tapped() {
        delegate?.editButton_Tapped(cell: self)
    }
    
    @objc private func alarmSwitch_Toggled() {
        delegate?.alarmSwitch_Toggled(cell: self, isOn: onOffSwitch.isOn)
    }

    func prepare(alarmList: AlarmList) {
        let formattedDate = DateUtils.formatDateString(alarmList.alarmDate)
        self.univLabel.text = alarmList.alarmUnivName
        self.alarmNameLabel.text = alarmList.alarmName
        let formattedTime = TimeHelper.convertTimeToAMPM(time: alarmList.alarmTime)
        self.alarmDateLabel.text = "\(formattedDate ?? "")  \(formattedTime)"
        if alarmList.onoff == 1 {
            self.onOffSwitch.isOn = true
        } else {
            self.onOffSwitch.isOn = false
        }
    }
}

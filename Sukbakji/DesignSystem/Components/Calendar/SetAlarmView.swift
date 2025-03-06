//
//  SetAlarmView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/28/25.
//

import UIKit
import SnapKit
import Then

class SetAlarmView: UIView, dateProtocol {
    
    var alarmTimeViewHeightConstraint: Constraint?
    
    let pickerHour = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var pickerMinute = [String]()
    let pickerDay = ["오전", "오후"]
    var day: String = "오전"
    var hour: String = "8"
    var minute: String = "00"
    var timeValue: String = "8:00"
    var dateValue: String = ""
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
    let navigationbarView = NavigationBarView(title: "알람 설정")
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let setAlarmView = UIView().then {
        $0.backgroundColor = .clear
    }
    let setAlarmLabel = UILabel().then {
        $0.text = "알람을 설정해 보세요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let alarmInfoLabel = UILabel().then {
        $0.text = "나만의 일정을 만들고 알림을 받아 보세요"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray500
    }
    let univView = UIView().then {
        $0.backgroundColor = .clear
    }
    let univLabel = UILabel().then {
        $0.text = "학교"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let univTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "학교를 선택해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let dropButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Down2"), for: .normal)
    }
    let warningImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningUnivLabel = UILabel().then {
        $0.text = "학교는 필수 선택입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    let alarmNameView = UIView().then {
        $0.backgroundColor = .clear
    }
    let alarmNameLabel = UILabel().then {
        $0.text = "알람 이름"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let alarmNameTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "알람 이름을 입력해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Delete"), for: .normal)
    }
    let warningImageView2 = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningAlarmNameLabel = UILabel().then {
        $0.text = "알람 이름은 필수 입력입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    let alarmDateView = UIView().then {
        $0.backgroundColor = .clear
    }
    let alarmDateLabel = UILabel().then {
        $0.text = "알람 날짜"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let alarmDateTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let dateButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_CalendarButton"), for: .normal)
    }
    let alarmTimeView = UIView().then {
        $0.backgroundColor = .clear
    }
    let alarmTimeLabel = UILabel().then {
        $0.text = "시간 설정"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let dateLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let timeButton = UIButton().then {
        $0.setTitle("오전 8:00", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(.orange700, for: .normal)
    }
    let pickerView = UIView().then {
        $0.backgroundColor = .gray100
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.gray300.cgColor
    }
    let alarmPickerView = UIPickerView().then {
        $0.backgroundColor = .clear
    }
    let setButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitleColor(.gray500, for: .disabled)
        $0.setTitle("알람 설정하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.gray200, for: .normal)
        $0.setBackgroundColor(.gray200, for: .disabled)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        displayCurrentDate()
        appendMinute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        addSubview(navigationbarView)
        addSubview(backgroundLabel)
        
        contentView.addSubview(setAlarmView)
        setAlarmView.addSubview(setAlarmLabel)
        setAlarmView.addSubview(alarmInfoLabel)
        
        contentView.addSubview(univView)
        univView.addSubview(univLabel)
        univView.addSubview(univTextField)
        univView.addSubview(dropButton)
        univView.addSubview(warningImageView)
        univView.addSubview(warningUnivLabel)
        
        contentView.addSubview(alarmNameView)
        alarmNameView.addSubview(alarmNameLabel)
        alarmNameView.addSubview(alarmNameTextField)
        alarmNameView.addSubview(deleteButton)
        alarmNameView.addSubview(warningImageView2)
        alarmNameView.addSubview(warningAlarmNameLabel)
        
        contentView.addSubview(alarmDateView)
        alarmDateView.addSubview(alarmDateLabel)
        alarmDateView.addSubview(alarmDateTextField)
        alarmDateView.addSubview(dateButton)
        
        contentView.addSubview(alarmTimeView)
        alarmTimeView.addSubview(alarmTimeLabel)
        alarmTimeView.addSubview(dateLabel)
        alarmTimeView.addSubview(timeButton)
        alarmTimeView.addSubview(pickerView)
        pickerView.addSubview(alarmPickerView)
        
        contentView.addSubview(setButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(944)
        }
        
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        setAlarmView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(82)
        }
        
        setAlarmLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(18)
        }
        
        alarmInfoLabel.snp.makeConstraints {
            $0.top.equalTo(setAlarmLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(17)
        }
        
        univView.snp.makeConstraints {
            $0.top.equalTo(setAlarmView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        univLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        univLabel.addImageAboveLabel(referenceView: setAlarmView, spacing: 20)
        
        univTextField.snp.makeConstraints {
            $0.top.equalTo(univLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        univTextField.errorfix()
        univTextField.addTFUnderline()
        univTextField.setLeftPadding(15)
        univTextField.isEnabled = false
        
        dropButton.snp.makeConstraints {
            $0.centerY.equalTo(univTextField)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(36)
        }
        
        warningImageView.snp.makeConstraints {
            $0.top.equalTo(univTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(28)
            $0.height.width.equalTo(12)
        }
        warningImageView.isHidden = true
        
        warningUnivLabel.snp.makeConstraints {
            $0.centerY.equalTo(warningImageView)
            $0.leading.equalTo(warningImageView.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningUnivLabel.isHidden = true
        
        alarmNameView.snp.makeConstraints {
            $0.top.equalTo(univView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        alarmNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        alarmNameLabel.addImageAboveLabel(referenceView: univView, spacing: 20)
        
        alarmNameTextField.snp.makeConstraints {
            $0.top.equalTo(alarmNameLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        alarmNameTextField.errorfix()
        alarmNameTextField.addTFUnderline()
        alarmNameTextField.setLeftPadding(15)
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(alarmNameTextField)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(36)
        }
        deleteButton.addTarget(self, action: #selector(textDelete_Tapped), for: .touchUpInside)
        
        warningImageView2.snp.makeConstraints {
            $0.top.equalTo(alarmNameTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(28)
            $0.height.width.equalTo(12)
        }
        warningImageView2.isHidden = true
        
        warningAlarmNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(warningImageView2)
            $0.leading.equalTo(warningImageView2.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningAlarmNameLabel.isHidden = true
        
        alarmDateView.snp.makeConstraints {
            $0.top.equalTo(alarmNameView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(99)
        }
        
        alarmDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        alarmDateLabel.addImageAboveLabel(referenceView: alarmNameView, spacing: 20)
        
        alarmDateTextField.snp.makeConstraints {
            $0.top.equalTo(alarmDateLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        alarmDateTextField.errorfix()
        alarmDateTextField.addTFUnderline()
        alarmDateTextField.setLeftPadding(15)
        alarmDateTextField.isEnabled = false
        
        dateButton.snp.makeConstraints {
            $0.centerY.equalTo(alarmDateTextField)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(36)
        }
        dateButton.addTarget(self, action: #selector(date_Tapped), for: .touchUpInside)
        
        alarmTimeView.snp.makeConstraints {
            $0.top.equalTo(alarmDateView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            alarmTimeViewHeightConstraint = $0.height.equalTo(88).constraint
        }
        
        alarmTimeLabel.snp.makeConstraints {
            $0.top.equalTo(alarmDateView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        alarmTimeLabel.addImageAboveLabel(referenceView: alarmDateView, spacing: 20)
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(alarmTimeLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(28)
            $0.height.equalTo(16)
        }
        
        timeButton.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(35)
            $0.width.equalTo(73)
        }
        timeButton.addTarget(self, action: #selector(time_Tapped), for: .touchUpInside)
        
        pickerView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(180)
        }
        pickerView.isHidden = true
        
        alarmPickerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(6)
        }
        alarmPickerView.delegate = self
        alarmPickerView.dataSource = self
        
        setButton.snp.makeConstraints {
            $0.top.equalTo(alarmTimeView.snp.bottom).offset(60)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    
    private func appendMinute() {
        for i in 0..<60 {
            if i < 10 {
                pickerMinute.append("0\(i)")
            } else {
                pickerMinute.append("\(i)")
            }
        }
    }
    
    private func displayCurrentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        dateFormatter.dateFormat = "yyyy년 MM월 dd일" // 원하는 형식
        
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        alarmDateTextField.text = formattedDate
        dateLabel.text = formattedDate
    }
    
    func dateSend(data: String) {
        alarmDateTextField.text = "\(data)"
        dateLabel.text = "\(data)"
        let replacedString = data.replacingOccurrences(of: " ", with: "")
        let reReplacedString = replacedString.replacingOccurrences(of: "년|월", with: "/", options: .regularExpression)
        dateValue = reReplacedString.replacingOccurrences(of: "일", with: "")
    }
    
    @objc func date_Tapped() {
        let dateView = DateView()
        dateView.delegate = self
        
        addSubview(dateView)
        dateView.alpha = 0
        dateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            dateView.alpha = 1
        }
    }
    
    @objc private func time_Tapped() {
        alarmTimeViewHeightConstraint?.update(offset: 268)
        
        UIView.animate(withDuration: 0.3) {
            self.pickerView.isHidden = false // 레이아웃 변경 애니메이션 적용
        }
    }
    
    @objc private func textDelete_Tapped() {
        alarmNameTextField.text = ""
    }
}

extension SetAlarmView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return pickerDay.count
        case 1:
            return pickerHour.count
        case 2:
            return pickerMinute.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
            case 0:
                return "\(pickerDay[row])"
            case 1:
                return "\(pickerHour[row])"
            case 2:
                return "\(pickerMinute[row])"
            default:
                return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel?
        if label == nil {
            label = UILabel()
            label?.textColor = .gray900
            label?.textAlignment = .center
        }
        switch component {
            case 0:
                label?.text = pickerDay[row]
                label?.font = UIFont(name:"Pretendard-Bold", size:20)
                return label!
            case 1:
                label?.text = pickerHour[row]
                label?.font = UIFont(name:"Pretendard-Medium", size:20)
                return label!
            case 2:
                label?.text = pickerMinute[row]
                label?.font = UIFont(name:"Pretendard-Medium", size:20)
                return label!
            default:
                return label!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            day = pickerDay[row]
        case 1:
            hour = pickerHour[row]
        case 2:
            minute = pickerMinute[row]
        default:
            timeButton.setTitle("오전 8:00", for: .normal)
            timeValue = "오전 8:00"
        }
        
        timeButton.setTitle("\(day) \(hour):\(minute)", for: .normal)
        if day == pickerDay[0] {
            timeValue = "\(hour):\(minute)"
        } else {
            let hourData = 12 + (Int(hour) ?? 0)
            let hourString = String(hourData)
            timeValue = "\(hourString):\(minute)"
        }
    }
}

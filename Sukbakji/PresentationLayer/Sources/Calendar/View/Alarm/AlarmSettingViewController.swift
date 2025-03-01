//
//  AlarmSettingViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 1/5/25.
//

import UIKit
import SnapKit
import Alamofire
import Then
import RxSwift
import RxCocoa
import DropDown

class AlarmSettingViewController: UIViewController, dateProtocol {
    
    private let memberId = UserDefaults.standard.integer(forKey: "memberID")
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let navigationbarView = NavigationBarView(title: "알람 설정")
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    private let setAlarmLabel = UILabel().then {
        $0.text = "알람을 설정해 보세요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let alarmInfoLabel = UILabel().then {
        $0.text = "나만의 일정을 만들고 알림을 받아 보세요"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray500
    }
    private let univLabel = UILabel().then {
        $0.text = "학교"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let univTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "학교를 선택해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    private let dropButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Down2"), for: .normal)
    }
    private let warningImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    private let warningUnivLabel = UILabel().then {
        $0.text = "학교는 필수 선택입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    private let alarmNameLabel = UILabel().then {
        $0.text = "알람 이름"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let alarmNameTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "알람 이름을 입력해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Delete"), for: .normal)
    }
    private let warningImageView2 = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    private let warningAlarmNameLabel = UILabel().then {
        $0.text = "알람 이름은 필수 입력입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    private let alarmDateLabel = UILabel().then {
        $0.text = "알람 날짜"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let alarmDateTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    private let dateButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_CalendarButton"), for: .normal)
    }
    private let alarmTimeLabel = UILabel().then {
        $0.text = "시간 설정"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let dateLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    private let timeButton = UIButton().then {
        $0.setTitle("오전 8:00", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(.orange700, for: .normal)
    }
    private let pickerView = UIView().then {
        $0.backgroundColor = .gray100
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.gray300.cgColor
    }
    private let alarmPickerView = UIPickerView().then {
        $0.backgroundColor = .clear
    }
    private let setButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitleColor(.gray500, for: .disabled)
        $0.setTitle("알람 설정하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.gray200, for: .normal)
        $0.setBackgroundColor(.gray200, for: .disabled)
    }
    
    private var warningImageViewHeightConstraint: Constraint?
    private var warningUnivLabelHeightConstraint: Constraint?
    private var warningImageView2HeightConstraint: Constraint?
    private var warningAlarmNameLabelHeightConstraint: Constraint?
    private var pickerViewHeightConstraint: Constraint?
    
    private let drop = DropDown()
    private let univName = ["서울대학교", "연세대학교", "고려대학교", "카이스트"]
    
    private let pickerHour = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    private var pickerMinute = [String]()
    private let pickerDay = ["오전", "오후"]
    
    private var day: String = "오전"
    private var hour: String = "8"
    private var minute: String = "00"
    
    private var timeValue: String = "8:00"
    private var dateValue: String = ""
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDrop()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 탭 바 숨기기
        self.tabBarController?.tabBar.isHidden = true
    }
}
    
extension AlarmSettingViewController {
    
    private func setDrop() {
        initUI()
        setDropdown()
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
            make.height.equalTo(944)
        }
        
        navigationbarView.delegate = self
        self.view.addSubview(navigationbarView)
        navigationbarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(95)
        }
        
        self.view.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationbarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.contentView.addSubview(setAlarmLabel)
        setAlarmLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(115)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(18)
        }
        
        self.contentView.addSubview(alarmInfoLabel)
        alarmInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(setAlarmLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(17)
        }
        
        self.contentView.addSubview(univLabel)
        univLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmInfoLabel.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        univLabel.addImageAboveLabel(referenceView: alarmInfoLabel, spacing: 36)
        
        self.contentView.addSubview(univTextField)
        univTextField.snp.makeConstraints { make in
            make.top.equalTo(univLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        univTextField.errorfix()
        univTextField.addTFUnderline()
        univTextField.setLeftPadding(15)
        univTextField.isEnabled = false
        
        self.contentView.addSubview(dropButton)
        dropButton.snp.makeConstraints { make in
            make.centerY.equalTo(univTextField)
            make.trailing.equalToSuperview().inset(24)
            make.height.width.equalTo(36)
        }
        dropButton.addTarget(self, action: #selector(drop_Tapped), for: .touchUpInside)
        
        self.contentView.addSubview(warningImageView)
        warningImageView.snp.makeConstraints { make in
            make.top.equalTo(univTextField.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(28)
            make.width.equalTo(12)
            self.warningImageViewHeightConstraint = make.height.equalTo(1).constraint
        }
        warningImageView.isHidden = true
        
        self.contentView.addSubview(warningUnivLabel)
        warningUnivLabel.snp.makeConstraints { make in
            make.centerY.equalTo(warningImageView)
            make.leading.equalTo(warningImageView.snp.trailing).offset(4)
            self.warningUnivLabelHeightConstraint = make.height.equalTo(1).constraint
        }
        warningUnivLabel.isHidden = true
        
        self.contentView.addSubview(alarmNameLabel)
        alarmNameLabel.snp.makeConstraints { make in
            make.top.equalTo(warningImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        alarmNameLabel.addImageAboveLabel(referenceView: warningImageView, spacing: 20)
        
        self.contentView.addSubview(alarmNameTextField)
        alarmNameTextField.snp.makeConstraints { make in
            make.top.equalTo(alarmNameLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        alarmNameTextField.errorfix()
        alarmNameTextField.addTFUnderline()
        alarmNameTextField.setLeftPadding(15)
        alarmNameTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        
        self.contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(alarmNameTextField)
            make.trailing.equalToSuperview().inset(24)
            make.height.width.equalTo(36)
        }
        deleteButton.addTarget(self, action: #selector(textDelete_Tapped), for: .touchUpInside)
        
        self.contentView.addSubview(warningImageView2)
        warningImageView2.snp.makeConstraints { make in
            make.top.equalTo(alarmNameTextField.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(28)
            make.width.equalTo(12)
            self.warningImageView2HeightConstraint = make.height.equalTo(1).constraint
        }
        warningImageView2.isHidden = true
        
        self.contentView.addSubview(warningAlarmNameLabel)
        warningAlarmNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(warningImageView2)
            make.leading.equalTo(warningImageView2.snp.trailing).offset(4)
            self.warningAlarmNameLabelHeightConstraint = make.height.equalTo(1).constraint
        }
        warningAlarmNameLabel.isHidden = true
        
        self.contentView.addSubview(alarmDateLabel)
        alarmDateLabel.snp.makeConstraints { make in
            make.top.equalTo(warningImageView2.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        alarmDateLabel.addImageAboveLabel(referenceView: warningImageView2, spacing: 20)
        
        self.contentView.addSubview(alarmDateTextField)
        alarmDateTextField.snp.makeConstraints { make in
            make.top.equalTo(alarmDateLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        alarmDateTextField.errorfix()
        alarmDateTextField.addTFUnderline()
        alarmDateTextField.setLeftPadding(15)
        alarmDateTextField.isEnabled = false
        
        self.contentView.addSubview(dateButton)
        dateButton.snp.makeConstraints { make in
            make.centerY.equalTo(alarmDateTextField)
            make.trailing.equalToSuperview().inset(24)
            make.height.width.equalTo(36)
        }
        dateButton.addTarget(self, action: #selector(date_Tapped), for: .touchUpInside)
        
        self.contentView.addSubview(alarmTimeLabel)
        alarmTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmDateTextField.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        alarmTimeLabel.addImageAboveLabel(referenceView: alarmDateTextField, spacing: 24)
        
        self.contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmTimeLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(16)
        }
        displayCurrentDate()
        
        self.contentView.addSubview(timeButton)
        timeButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(35)
            make.width.equalTo(73)
        }
        timeButton.addTarget(self, action: #selector(time_Tapped), for: .touchUpInside)
        
        self.contentView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            self.pickerViewHeightConstraint = make.height.equalTo(1).constraint
        }
        pickerView.isHidden = true
        
        appendMinute()
        alarmPickerView.delegate = self
        alarmPickerView.dataSource = self
        self.pickerView.addSubview(alarmPickerView)
        alarmPickerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(6)
        }
        
        self.contentView.addSubview(setButton)
        setButton.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        setButton.addTarget(self, action: #selector(set_Tapped), for: .touchUpInside)
    }
}

extension AlarmSettingViewController {
    
    func dateSend(data: String) {
        alarmDateTextField.text = "\(data)"
        dateLabel.text = "\(data)"
        let replacedString = data.replacingOccurrences(of: " ", with: "")
        let reReplacedString = replacedString.replacingOccurrences(of: "년|월", with: "-", options: .regularExpression)
        dateValue = reReplacedString.replacingOccurrences(of: "일", with: "")
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
    
    private func initUI() {
        DropDown.appearance().textColor = .gray900 // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = .orange700 // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = .gray50 // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = .orange50 // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(5)
        DropDown.appearance().setupMaskedCorners(CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner))
        drop.dismissMode = .automatic // 팝업을 닫을 모드 설정
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 12)
    }
    
    private func setDropdown() {
        // dataSource로 ItemList를 연결
        drop.dataSource = univName
        drop.cellHeight = 44
        // anchorView를 통해 UI와 연결
        drop.anchorView = self.univTextField
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        drop.bottomOffset = CGPoint(x: 0, y: 45.5 + univTextField.bounds.height)
        
        drop.shadowColor = .clear
        
        drop.cellConfiguration = { (index, item) in
            return "  \(item)" // 앞에 4칸 공백 추가
        }
        
        drop.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
            // separatorInset을 조정하여 separator 앞의 간격을 없앱니다.
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            
            guard index != (self.drop.dataSource.count) - 1 else { return }
            
            // 새로운 separator 추가
            let separator = UIView()
            separator.backgroundColor = .gray300
            separator.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(separator)
            
            // separator 높이(굵기) 설정
            let separatorHeight: CGFloat = 1.5 // 원하는 굵기 설정
            
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: separatorHeight)
            ])
        }
        
        // Item 선택 시 처리
        drop.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self?.univTextField.text = "\(item)"
            self?.updateButtonColor()
            self?.univTextField.backgroundColor = .gray50
            self?.univTextField.setPlaceholderColor(.gray500)
            self?.univTextField.updateUnderlineColor(to: .gray300)
            self?.deleteWarningUnivName()
        }
        
        // 취소 시 처리
        drop.cancelAction = { [weak self] in
            self?.univTextField.backgroundColor = .warning50
            self?.univTextField.setPlaceholderColor(.warning400)
            self?.univTextField.updateUnderlineColor(to: .warning400)
            self?.warningUnivName()
        }
    }
    
    private func warningUnivName() {
        warningImageView.isHidden = false
        warningImageViewHeightConstraint?.update(offset: 12)
        
        warningUnivLabel.isHidden = false
        warningUnivLabelHeightConstraint?.update(offset: 12)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func deleteWarningUnivName() {
        warningImageView.isHidden = true
        warningImageViewHeightConstraint?.update(offset: 1)
        
        warningUnivLabel.isHidden = true
        warningUnivLabelHeightConstraint?.update(offset: 1)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func warningAlarmName() {
        warningImageView2.isHidden = false
        warningImageView2HeightConstraint?.update(offset: 12)
        
        warningAlarmNameLabel.isHidden = false
        warningAlarmNameLabelHeightConstraint?.update(offset: 12)
        
        alarmNameTextField.backgroundColor = .warning50
        alarmNameTextField.setPlaceholderColor(.warning400)
        alarmNameTextField.updateUnderlineColor(to: .warning400)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func deleteWarningAlarmName() {
        warningImageView2.isHidden = true
        warningImageView2HeightConstraint?.update(offset: 1)
        
        warningAlarmNameLabel.isHidden = true
        warningAlarmNameLabelHeightConstraint?.update(offset: 1)
        
        alarmNameTextField.backgroundColor = .gray50
        alarmNameTextField.setPlaceholderColor(.gray500)
        alarmNameTextField.updateUnderlineColor(to: .gray300)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    @objc func textFieldEdited(_ textField: UITextField) {
        updateButtonColor()
        if alarmNameTextField.text?.isEmpty == true {
            warningAlarmName()
        } else {
            deleteWarningAlarmName()
        }
    }
    
    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 텍스트 필드 내용이 변경될 때 버튼 색깔 업데이트
        DispatchQueue.main.async {
            self.updateButtonColor()
        }
        return true
    }
    
    private func updateButtonColor() {
        if (univTextField.text?.isEmpty == false && alarmNameTextField.text?.isEmpty == false) {
            setButton.isEnabled = true
            setButton.setBackgroundColor(.orange700, for:.normal)
            setButton.setTitleColor(.white, for: .normal)
        } else {
            setButton.isEnabled = false
            setButton.setBackgroundColor(.gray200, for: .normal)
            setButton.setTitleColor(.gray500, for: .normal)
        }
    }
    
    @objc private func drop_Tapped() {
        drop.show()
    }
    
    @objc private func textDelete_Tapped() {
        alarmNameTextField.text = ""
    }
    
    @objc func date_Tapped() {
        let dateView = DateView()
        dateView.delegate = self
        
        self.view.addSubview(dateView)
        dateView.alpha = 0
        dateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            dateView.alpha = 1
        }
    }
    
    @objc private func time_Tapped() {
        pickerView.isHidden = false
        pickerViewHeightConstraint?.update(offset: 180)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    @objc private func set_Tapped() {
//        setAlarmAPI()
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .isAlarmComplete, object: nil)
    }
}
    
extension AlarmSettingViewController {
    
    private func setAlarmAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendarAlarm.path
        
        let params = [
            "memberId": memberId,
            "univName": univTextField.text!,
            "name": alarmNameTextField.text!,
            "date": dateValue,
            "time": timeValue,
            "onoff": 1
        ] as [String : Any]
        
        APIService.shared.postWithToken(of: APIResponse<AlarmPost>.self, url: url, parameters: params, accessToken: retrievedToken)
            .subscribe(onSuccess: { user in
                print("✅ 사용자 등록 성공:", user)
            }, onFailure: { error in
                print("❌ 오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

extension AlarmSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

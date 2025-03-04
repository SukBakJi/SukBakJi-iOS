//
//  FindView.swift
//  Sukbakji
//
//  Created by 오현민 on 2/28/25.
//

import UIKit
import SnapKit

class FindEmailView: UIView {
    private var phoneNumLabelTopConstraint: Constraint?
    
    private let nameDot = UIImageView().then {
        $0.image = UIImage(named: "SBJ_dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    
    var nameClearButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_clear"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_clear"), for: .highlighted)
        $0.isHidden = true
        $0.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    private let nameErrorView = UIView().then {
        $0.isHidden = true
    }
    
    private let nameErrorIcon = UIImageView().then {
        $0.image = UIImage(named: "SBJ_ErrorCircle")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let nameErrorLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    
    let nameTextField = UITextField().then {
        $0.placeholder = "이름을 입력해 주세요"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.clearButtonMode = .never
        
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .none
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.frame.size.width = 342
        $0.frame.size.height = 44
        $0.backgroundColor = .gray50
        $0.textColor = .gray500
        $0.setPlaceholderColor(.gray500)
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        $0.autocapitalizationType = .none
    }
    
    private let phoneNumDot = UIImageView().then {
        $0.image = UIImage(named: "SBJ_dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let phoneNumLabel = UILabel().then {
        $0.text = "전화번호"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    
    var phoneNumClearButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_clear"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_clear"), for: .highlighted)
        $0.isHidden = true
        $0.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    private let phoneNumErrorView = UIView().then {
        $0.isHidden = true
    }
    
    private let phoneNumErrorIcon = UIImageView().then {
        $0.image = UIImage(named: "SBJ_ErrorCircle")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let phoneNumErrorLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    
    let phoneNumTextField = UITextField().then {
        $0.placeholder = "전화번호를 입력해 주세요"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .none
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.frame.size.width = 342
        $0.frame.size.height = 44
        $0.backgroundColor = .gray50
        $0.textColor = .gray500
        $0.setPlaceholderColor(.gray500)
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        $0.autocapitalizationType = .none
        $0.keyboardType = .numberPad
    }
    
    private let findButton = UIButton().then {
        $0.setTitle("이메일 찾기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray200
        $0.setTitleColor(.gray500, for: .normal)
        $0.addTarget(self, action: #selector(findButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    // MARK: - Functional
    @objc private func findButtonTapped() {
        validateField()
    }
    
    @objc private func clearButtonTapped() {
        nameTextField.text = ""
    }
    
    // MARK: - Validation
    func isValidName(_ name: String) -> Bool {
        let nameRegEx = "^(?=.*[가-힣a-zA-Z])[가-힣a-zA-Z]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        
        // 한글 자음/모음만 입력된 경우를 방지
        let invalidKoreanRegEx = ".*[ㄱ-ㅎㅏ-ㅣ].*"
        let invalidKoreanTest = NSPredicate(format:"SELF MATCHES %@", invalidKoreanRegEx)
        
        return nameTest.evaluate(with: name) && !invalidKoreanTest.evaluate(with: name)
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        // 전화번호는 10~11자리 숫자로만 이루어져야 함 (예: 01012345678, 021234567)
        let phoneRegEx = "^[0-9]{10,11}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    func validateFieldForButtonUpdate() {
        let name = nameTextField.text ?? ""
        let phoneNum = phoneNumTextField.text ?? ""
        var isNameValid = false
        var isPhoneNumValid = false
        
        if isValidName(name) {
            isNameValid = true
            changeStateBack(nameTextField)
        }
        
        if isValidPhoneNumber(phoneNum) {
            isPhoneNumValid = true
            changeStateBack(phoneNumTextField)
        }
        
        if isNameValid && isPhoneNumValid {
            updateFindButton(enabled: true)
        } else {
            updateFindButton(enabled: false)
        }
    }
    
    private func validateField() {
        guard let name = nameTextField.text else { return }
        guard let phoneNum = phoneNumTextField.text else { return }
        
        var isNameValid = false
        var isphoneNumValid = false
        
        if name.isEmpty {
            changeStateError(nameTextField)
            nameErrorLabel.text = "이름을 입력해 주세요"
            isNameValid = false
        } else if !isValidName(name) {
            changeStateError(nameTextField)
            nameErrorLabel.text = "올바르지 않은 형식의 이메일 입니다"
            isNameValid = false
        } else { isNameValid = true }
        
        if phoneNum.isEmpty {
            changeStateError(phoneNumTextField)
            phoneNumErrorLabel.text = "전화번호를 입력해 주세요"
            isphoneNumValid = false
        } else if !isValidPhoneNumber(phoneNum) {
            changeStateError(phoneNumTextField)
            phoneNumErrorLabel.text = "전화번호가 형식에 맞지 않습니다"
            isphoneNumValid = false
        } else { isphoneNumValid = true }
        
        // 유효성 검사를 통과한 경우
        if isNameValid && isphoneNumValid {
            // MARK: - NetWork
            //            let input = SignupRequestDTO(
            //                provider: provider,
            //                email: email,
            //                password: password
            //            )
            //
            //            let authDataManager = AuthDataManager()
            //            authDataManager.signupDataManager(input) {
            //                [weak self] AuthResponse in
            //                guard let self = self else { return }
            //
            //                // 응답
            //                if let model = AuthResponse, model.code == "COMMON200" {
            //                    self.navigateToNextPage()
            //                    print("회원가입 성공 : ID(\(email))")
            //                    self.showMessage(message: model.message)
            //
            //                    getToken(email, password)
            //                }
            //                else if let model = AuthResponse, model.code == "MEMBER4002" {
            //                    changeStateError(emailTextField)
            //                    emailErrorLabel.text = "이미 가입된 이메일입니다"
            //                    self.showMessage(message: model.message)
            //                }
            //            }
        }
        else {
            updateFindButton(enabled: false)
        }
    }
    
    private func updateFindButton(enabled: Bool) {
        if enabled {
            findButton.backgroundColor = .orange700
            findButton.setTitleColor(.white, for: .normal)
        } else {
            findButton.backgroundColor = .gray200
            findButton.setTitleColor(.gray500, for: .normal)
        }
    }
    
    func changeStateError(_ tf: UITextField) {
        tf.backgroundColor = .warning50
        tf.textColor = .warning400
        tf.setPlaceholderColor(.warning400)
        tf.layer.addBorder([.bottom], color: .warning400, width: 0.5)
        
        if tf == nameTextField {
            nameClearButton.setImage(UIImage(named: "SBJ_clear-red"), for: .normal)
            
            nameErrorView.isHidden = false
            nameErrorLabel.textColor = .warning400
            nameErrorIcon.image = UIImage(named: "SBJ_ErrorCircle")
            updatePhoneNumLabelConstraint()
        } else if tf == phoneNumTextField {
            phoneNumClearButton.setImage(UIImage(named: "SBJ_clear-red"), for: .normal)
            
            phoneNumErrorView.isHidden = false
            phoneNumErrorLabel.textColor = .warning400
            phoneNumErrorIcon.image = UIImage(named: "SBJ_ErrorCircle")
        }
    }
    
    func changeStateBack(_ tf: UITextField) {
        tf.backgroundColor = .gray50
        tf.textColor = .gray500
        tf.setPlaceholderColor(.gray500)
        tf.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        
        if tf == nameTextField {
            nameClearButton.setImage(UIImage(named: "SBJ_clear"), for: .normal)
            
            nameErrorView.isHidden = true
            updatePhoneNumLabelConstraint()
            
        } else if tf == phoneNumTextField {
            phoneNumClearButton.setImage(UIImage(named: "SBJ_clear"), for: .normal)
            
            phoneNumErrorView.isHidden = true
        }
    }
    
    //MARK: - 컴포넌트 추가
    private func setView() {
        self.addSubviews([nameDot, nameLabel, nameTextField, nameErrorView])
        nameErrorView.addSubviews([nameErrorIcon, nameErrorLabel])
        
        self.addSubviews([phoneNumDot, phoneNumLabel, phoneNumTextField, phoneNumErrorView, findButton])
        phoneNumErrorView.addSubviews([phoneNumErrorIcon, phoneNumErrorLabel])
    }
    
    //MARK: - 레이아웃 설정
    private func updatePhoneNumLabelConstraint() {
        phoneNumLabelTopConstraint?.update(offset: nameErrorView.isHidden ? 20 : 36)
    }
    
    private func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().inset(24)
        }
        
        nameDot.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top)
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        nameErrorView.snp.makeConstraints { make in
            make.leading.equalTo(nameTextField)
            make.top.equalTo(nameTextField.snp.bottom).offset(4)
            make.height.equalTo(12)
        }
        
        nameErrorIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        nameErrorLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameErrorIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        phoneNumLabel.snp.makeConstraints { make in
            phoneNumLabelTopConstraint = make.top.equalTo(nameTextField.snp.bottom).offset(20).constraint
            make.leading.equalToSuperview().inset(24)
        }
        
        phoneNumDot.snp.makeConstraints { make in
            make.top.equalTo(phoneNumLabel.snp.top)
            make.leading.equalTo(phoneNumLabel.snp.trailing).offset(4)
        }
        
        phoneNumTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        phoneNumErrorView.snp.makeConstraints { make in
            make.leading.equalTo(phoneNumTextField)
            make.top.equalTo(phoneNumTextField.snp.bottom).offset(4)
            make.height.equalTo(12)
        }
        
        phoneNumErrorIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        phoneNumErrorLabel.snp.makeConstraints { make in
            make.leading.equalTo(phoneNumErrorIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        findButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(79)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
    }
}

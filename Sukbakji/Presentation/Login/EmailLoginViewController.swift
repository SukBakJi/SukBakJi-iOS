//
//  processLoginViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/16/24.
//

import Foundation
import SnapKit
import Then
import UIKit


class EmailLoginViewController: UIViewController {
    
    var isAutoLogin: Bool = false
    
    // MARK: - ErrorState
    private var passwordLabelTopConstraint: Constraint?
    private var autoLoginCheckBoxTopConstraint: Constraint?
    
    private let emailErrorIcon = UIImageView().then {
        $0.image = UIImage(named: "SBJ_ErrorCircle")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let passwordErrorIcon = UIImageView().then {
        $0.image = UIImage(named: "SBJ_ErrorCircle")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let emailErrorLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    private let passwordErrorLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    private let passwordErrorView = UIView().then {
        $0.isHidden = true
    }
    private let emailErrorView = UIView().then {
        $0.isHidden = true
    }
    
    // MARK: - ImageView
    private let emailDot = UIImageView().then {
        $0.image = UIImage(named: "SBJ_dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let passwordDot = UIImageView().then {
        $0.image = UIImage(named: "SBJ_dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Label
    private let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let signUpLabel = UILabel().then {
        $0.text = "아직 석박지 계정이 없다면?"
        $0.textAlignment = .center
        $0.textColor = .gray500
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.numberOfLines = 0
    }
    
    // MARK: - TextField
    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해 주세요"
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
    private let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해 주세요"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.isSecureTextEntry = true
        
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
    // MARK: - Button
    private let autoLoginCheckBox = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_state=off"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_state=on"), for: .selected)
        $0.setTitle("자동 로그인", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.setTitleColor(.gray600, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
        
        $0.backgroundColor = .gray200
        $0.setTitleColor(.gray500, for: .normal)
        $0.addTarget(self, action: #selector(LoginButtonTapped), for: .touchUpInside)
    }
    private let emailFindButton = UIButton().then {
        $0.setTitle("이메일 찾기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.titleLabel?.textAlignment = .center
        $0.setTitleColor(.gray600, for: .normal)
    }
    private let passwordFindButton = UIButton().then {
        $0.setTitle("비밀번호 재설정", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.titleLabel?.textAlignment = .center
        $0.setTitleColor(.gray600, for: .normal)
    }
    private let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.titleLabel?.textAlignment = .center
        $0.setTitleColor(.gray600, for: .normal)
        $0.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - TextField Button
    private var eyeButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_Password-hidden"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_Password-shown"), for: .selected)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(eyeButtonTapped(_:)), for: .touchUpInside)
    }
    private var passwordClearButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_clear"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(passwordClearButtonTapped(_:)), for: .touchUpInside)
    }
    private var emailClearButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_clear"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.isHidden = true
        $0.addTarget(self, action: #selector(emailClearButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: - View
    private let verticalSeparator = UIView().then {
        $0.backgroundColor = .gray500
    }
    private let passwordRightView = UIView().then {
        $0.isHidden = true
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpNavigationBar()
        setupViews()
        setupLayout()
        setTextFieldDelegate()
        validateFieldForButtonUpdate()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
    // MARK: - setTextField
    private func setTextFieldDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "이메일로 로그인"
    }
    
    // MARK: - Screen transition
    @objc private func LoginButtonTapped() {
        validateField()
    }
    
    @objc private func signUpButtonTapped() {
        let SignUpVC = SignUpViewController()
        self.navigationController?.pushViewController(SignUpVC, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func navigateToHomeScreen() {
        let tabBarVC = MainTabViewController()
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
    // MARK: - Functional
    @objc private func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        isAutoLogin = sender.isSelected
        UserDefaults.standard.set(isAutoLogin, forKey: "isAutoLogin")
    }


    @objc private func eyeButtonTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
    @objc private func passwordClearButtonTapped(_ sender: UIButton) {
        passwordTextField.text = ""
    }
    @objc private func emailClearButtonTapped(_ sender: UIButton) {
        emailTextField.text = ""
    }
    
    //MARK: - validate
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // 버튼 눌렀을 떄 검사
    private func validateField() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        var isEmailValid = false
        var isPasswordValid = false
        
        // 이메일 유효성 검사
        if email.isEmpty {
            changeStateError(emailTextField)
            emailErrorLabel.text = "이메일을 입력해 주세요"
        } else if !isValidEmail(email) {
            changeStateError(emailTextField)
            emailErrorLabel.text = "올바르지 않은 형식의 이메일입니다"
        } else {
            isEmailValid = true
        }
        
        // 비밀번호 유효성 검사
        if password.isEmpty {
            changeStateError(passwordTextField)
            passwordErrorLabel.text = "비밀번호를 입력해 주세요"
        } else if password.count < 6 {
            changeStateError(passwordTextField)
            passwordErrorLabel.text = "비밀번호는 6자리 이상 입력해야 합니다"
        } else {
            isPasswordValid = true
        }
        
        // 유효성 검사를 통과한 경우
        if isEmailValid && isPasswordValid {
            let authDataManager = AuthDataManager()
            
            let input = LoginRequestDTO(email: email, password: password)
            print("전송된 데이터: \(input)")
            print("이메일로 로그인 호출")
            
            authDataManager.loginDataManager(input) {
                [weak self] loginModel in
                guard let self = self else { return }
                
                // 응답
                if let model = loginModel, model.code == "COMMON200" {
                    self.navigateToHomeScreen()
                    self.showMessage(message: model.message ?? "로그인에 성공했습니다")
                }
                else if let model = loginModel, model.isSuccess == false {
                    changeStateError(emailTextField)
                    changeStateError(passwordTextField)
                    emailErrorView.isHidden = true
                    updatePasswordLabelConstraint()
                    passwordErrorLabel.text = "입력한 이메일 또는 비밀번호가 일치하지 않습니다"
                    
                    self.showMessage(message: model.message ?? "로그인에 실패했습니다")
                }
                else {
                    print("이메일로 로그인 실패")
                }
            }
        } else {
            // 유효성 검사 실패 시 로그인 버튼 비활성화
            updateLoginButton(enabled: false)
        }
    }
    
    private func showMessage(message: String) {
        print("메시지 : \(message)")
    }
    
    // 에러 상태
    private func changeStateError(_ tf: UITextField) {
        tf.backgroundColor = .warning50
        tf.textColor = .warning400
        tf.setPlaceholderColor(.warning400)
        tf.layer.addBorder([.bottom], color: .warning400, width: 0.5)
        
        if tf == emailTextField {
            emailClearButton.setImage(UIImage(named: "SBJ_clear-red"), for: .normal)
            
            emailErrorView.isHidden = false
            updatePasswordLabelConstraint()
            
        } else if tf == passwordTextField {
            passwordClearButton.setImage(UIImage(named: "SBJ_clear-red"), for: .normal)
            eyeButton.setImage(UIImage(named: "SBJ_Password-hidden-red"), for: .normal)
            eyeButton.setImage(UIImage(named: "SBJ_Password-shown-red"), for: .selected)
            
            passwordErrorView.isHidden = false
            updateAutoCheckBoxConstraint()
        }
    }
    // 상태 복구
    private func changeStateBack(_ tf: UITextField) {
        tf.backgroundColor = .gray50
        tf.textColor = .gray500
        tf.setPlaceholderColor(.gray500)
        tf.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        
        if tf == emailTextField {
            emailClearButton.setImage(UIImage(named: "SBJ_clear"), for: .normal)
            
            emailErrorView.isHidden = true
            updatePasswordLabelConstraint()
            
        } else if tf == passwordTextField {
            passwordClearButton.setImage(UIImage(named: "SBJ_clear"), for: .normal)
            eyeButton.setImage(UIImage(named: "SBJ_Password-hidden"), for: .normal)
            eyeButton.setImage(UIImage(named: "SBJ_Password-shown"), for: .selected)
            
            passwordErrorView.isHidden = true
            updateAutoCheckBoxConstraint()
        }
    }
    // 버튼 입력 가능 감지
    private func validateFieldForButtonUpdate() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        var isEmailValid = false
        var isPasswordValid = false
        
        if !email.isEmpty || isValidEmail(email) {
            isEmailValid = true
            changeStateBack(emailTextField)
        }
        
        if !password.isEmpty || password.count >= 6 {
            isPasswordValid = true
            changeStateBack(passwordTextField)
        }
        
        if isEmailValid && isPasswordValid {
            updateLoginButton(enabled: true)
        } else {
            updateLoginButton(enabled: false)
        }
    }
    
    private func updateLoginButton(enabled: Bool) {
        if enabled {
            loginButton.backgroundColor = .orange700
            loginButton.setTitleColor(.white, for: .normal)
        } else {
            loginButton.backgroundColor = .gray200
            loginButton.setTitleColor(.gray500, for: .normal)
        }
    }
    
    // MARK: - addView
    func setupViews() {
        view.addSubview(emailDot)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailClearButton)
        
        view.addSubview(passwordDot)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        
        view.addSubview(autoLoginCheckBox)
        view.addSubview(loginButton)
        
        view.addSubview(emailFindButton)
        view.addSubview(verticalSeparator)
        view.addSubview(passwordFindButton)
        view.addSubview(signUpLabel)
        view.addSubview(signUpButton)
        
        view.addSubview(passwordRightView)
        passwordRightView.addSubview(eyeButton)
        passwordRightView.addSubview(passwordClearButton)
        
        view.addSubview(emailErrorView)
        emailErrorView.addSubview(emailErrorIcon)
        emailErrorView.addSubview(emailErrorLabel)
        
        view.addSubview(passwordErrorView)
        passwordErrorView.addSubview(passwordErrorIcon)
        passwordErrorView.addSubview(passwordErrorLabel)
    }
    
    // MARK: - setLayout
    private func updatePasswordLabelConstraint() {
        passwordLabelTopConstraint?.update(offset: emailErrorView.isHidden ? 20 : 36)
    }
    private func updateAutoCheckBoxConstraint() {
        autoLoginCheckBoxTopConstraint?.update(offset: passwordErrorView.isHidden ? 16 : 32)
    }
    
    func setupLayout() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(24)
        }
        
        emailDot.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.top)
            make.leading.equalTo(emailLabel.snp.trailing).offset(4)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        passwordLabel.snp.makeConstraints { make in
            passwordLabelTopConstraint = make.top.equalTo(emailTextField.snp.bottom).offset(20).constraint
            make.leading.equalToSuperview().inset(24)
        }
        
        passwordDot.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.top)
            make.leading.equalTo(passwordLabel.snp.trailing).offset(4)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        autoLoginCheckBox.snp.makeConstraints { make in
            autoLoginCheckBoxTopConstraint = make.top.equalTo(passwordTextField.snp.bottom).offset(16).constraint
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(310)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(autoLoginCheckBox.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        emailFindButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.trailing.equalTo(verticalSeparator.snp.leading).offset(-8)
            make.height.equalTo(14)
        }
        
        verticalSeparator.snp.makeConstraints { make in
            make.centerX.equalTo(loginButton.snp.centerX)
            make.centerY.equalTo(emailFindButton)
            make.width.equalTo(0.5)
            make.height.equalTo(14)
        }
        
        passwordFindButton.snp.makeConstraints { make in
            make.leading.equalTo(verticalSeparator.snp.trailing).offset(8)
            make.centerY.equalTo(emailFindButton)
            make.height.equalTo(14)
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(emailFindButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(103)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(101)
            make.centerY.equalTo(signUpLabel)
        }
        
        emailClearButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField)
            make.trailing.equalTo(emailTextField.snp.trailing).inset(12)
            make.width.height.equalTo(12)
        }
        
        passwordRightView.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField)
            make.trailing.equalTo(passwordTextField.snp.trailing).inset(12)
            make.width.equalTo(32)
            make.height.equalTo(12)
        }
        
        passwordClearButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        eyeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(passwordClearButton.snp.leading).offset(-8)
            make.width.height.equalTo(12)
        }
        
        //Error
        emailErrorView.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
            make.height.equalTo(12)
        }
        
        emailErrorIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        emailErrorLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailErrorIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        passwordErrorView.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
            make.height.equalTo(12)
        }
        
        passwordErrorIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        passwordErrorLabel.snp.makeConstraints { make in
            make.leading.equalTo(passwordErrorIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }
}
// MARK: - extension
extension EmailLoginViewController: UITextFieldDelegate {
    // 입력 시 파란색
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.addBorder([.bottom], color: .blue400, width: 0.5)
        if textField == emailTextField {
            emailClearButton.isHidden = false
        }
        if textField == passwordTextField {
            passwordRightView.isHidden = false
        }
    }
    
    // 입력 끝날 시 회색
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        if textField == emailTextField {
            emailClearButton.isHidden = true
        }
        if textField == passwordTextField {
            passwordRightView.isHidden = true
        }
        return true
    }
    
    // 텍스트 필드의 내용이 변경될 때 호출
    func textFieldDidChangeSelection(_ textField: UITextField) {
        validateFieldForButtonUpdate()
    }
}



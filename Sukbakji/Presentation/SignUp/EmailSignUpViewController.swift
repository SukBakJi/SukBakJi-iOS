//
//  SignUpViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/18/24.
//

import UIKit
import SnapKit

class EmailSignUpViewController: UIViewController {
    private var emailWorkItem: DispatchWorkItem?
    
    // MARK: - ErrorState
    private var passwordLabelTopConstraint: Constraint?
    private var checkPasswordLabelTopConstraint: Constraint?
    private var nextButtonTopConstraint: Constraint?
    
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
    private let checkPasswordErrorIcon = UIImageView().then {
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
    private let checkPasswordErrorLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    private let emailErrorView = UIView().then {
        $0.isHidden = true
    }
    private let passwordErrorView = UIView().then {
        $0.isHidden = true
    }
    private let checkPasswordErrorView = UIView().then {
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
    private let checkPasswordDot = UIImageView().then {
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
    private let checkPasswordLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
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
        $0.placeholder = "비밀번호를 6자리 이상 입력해 주세요"
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
    private let checkPasswordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 한 번 더 입력해 주세요"
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
    private let nextButton = UIButton().then {
        $0.setTitle("다음으로", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray200
        $0.setTitleColor(.gray500, for: .normal)
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - TextField Button
    private var emailClearButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_clear"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.isHidden = true
        $0.addTarget(self, action: #selector(emailClearButtonTapped(_:)), for: .touchUpInside)
    }
    private var passwordEyeButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_Password-hidden"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_Password-shown"), for: .selected)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(eyeButtonTapped(_:)), for: .touchUpInside)
    }
    private var passwordClearButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_clear"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(clearButtonTapped(_:)), for: .touchUpInside)
    }
    private var checkPasswordEyeButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_Password-hidden"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_Password-shown"), for: .selected)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(eyeSecondButtonTapped(_:)), for: .touchUpInside)
    }
    private var checkPasswordClearButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_clear"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(clearSecondButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: - View
    private let passwordRightView = UIView().then {
        $0.isHidden = true
    }
    private let checkPasswordRightView = UIView().then {
        $0.isHidden = true
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setTextFieldDelegate()
        setUpNavigationBar()
        setupViews()
        setupLayout()
        validateFieldForButtonUpdate()
    }
    
    // MARK: - setTextField
    private func setTextFieldDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        checkPasswordTextField.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "회원가입"
    }
    
    // MARK: - Screen transition
    @objc private func nextButtonTapped() {
        validateField()
    }
    
    private func navigateToNextPage() {
        let AcademicVerificationVC = AcademicVerificationViewController()
        self.navigationController?.pushViewController(AcademicVerificationVC, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    // MARK: - Functional
    @objc private func eyeButtonTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
    @objc private func clearButtonTapped(_ sender: UIButton) {
        passwordTextField.text = ""
    }
    @objc private func eyeSecondButtonTapped(_ sender: UIButton) {
        checkPasswordTextField.isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
    @objc private func clearSecondButtonTapped(_ sender: UIButton) {
        checkPasswordTextField.text = ""
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
    
    private func validateField() {
        let provider = "BASIC"
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let checkPassword = checkPasswordTextField.text ?? ""
        var isEmailValid = false
        var isPasswordValid = false
        var ischeckPasswordValid = false
        
        if email.isEmpty {
            changeStateError(emailTextField)
            emailErrorLabel.text = "이메일을 입력해 주세요"
            isEmailValid = false
        } else if !isValidEmail(email) {
            changeStateError(emailTextField)
            emailErrorLabel.text = "올바르지 않은 형식의 이메일 입니다"
            isEmailValid = false
        } else { isEmailValid = true }
        
        if password.isEmpty {
            changeStateError(passwordTextField)
            passwordErrorLabel.text = "비밀번호를 입력해 주세요"
            isPasswordValid = false
        } else if password.count < 6 {
            changeStateError(passwordTextField)
            passwordErrorLabel.text = "비밀번호는 6자리 이상 입력해야 합니다"
            isPasswordValid = false
        } else { isPasswordValid = true }
        
        if checkPassword.isEmpty {
            changeStateError(checkPasswordTextField)
            checkPasswordErrorLabel.text = "비밀번호를 한 번 더 입력해 주세요"
            ischeckPasswordValid = false
        } else if !checkPassword.isEmpty && password != checkPassword {
            changeStateError(checkPasswordTextField)
            checkPasswordErrorLabel.text = "입력한 비밀번호와 일치하지 않습니다"
            ischeckPasswordValid = false
        } else { ischeckPasswordValid = true }
        
        // 유효성 검사를 통과한 경우
        if isEmailValid && isPasswordValid && ischeckPasswordValid {
            // MARK: - NetWork (이메일로 로그인)
            let input = SignupRequestDTO(
                provider: provider,
                email: email,
                password: password
            )
            
            let authDataManager = AuthDataManager()
            authDataManager.signupDataManager(input) {
                [weak self] AuthResponse in
                guard let self = self else { return }
                
                // 응답
                if let model = AuthResponse, model.code == "COMMON200" {
                    self.navigateToNextPage()
                    print("회원가입 성공 : ID(\(email))")
                    self.showMessage(message: model.message)
                    
                    getToken(email, password)
                }
                else if let model = AuthResponse, model.code == "MEMBER4002" {
                    changeStateError(emailTextField)
                    emailErrorLabel.text = "이미 가입된 이메일입니다"
                    self.showMessage(message: model.message)
                }
            }
        }
        else {
            updateNextButton(enabled: false)
        }
    }
    private func getToken(_ email: String, _ password: String) {
        // MARK: - NetWork
        let authDataManager = AuthDataManager()
        
        let input = LoginRequestDTO(email: email, password: password)
        print("전송된 데이터: \(input)")
        print("이메일로 로그인 호출")
        
        authDataManager.loginDataManager(input) {
            [weak self] data in
            guard let self = self else { return }
            
            
            // 응답
            if let data = data, data.code == "COMMON200" {
                print("토큰 \(data.result?.accessToken ?? "발급실패")")
            }
        }
    }
    func checkEmail(_ email: String) {
            // 이전에 실행 중이던 작업이 있다면 취소합니다.
            emailWorkItem?.cancel()
            
            // 새로운 작업 생성
            let workItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                
                // MARK: - NetWork
                let authDataManager = AuthDataManager()
                authDataManager.EmailDataManager(email) { [weak self] SignUpModel in
                    guard let self = self else { return }
                    
                    // 서버로부터의 응답 처리
                    if let model = SignUpModel {
                        if model.result == "사용 가능한 이메일입니다." {
                            print("사용 가능한 이메일입니다.")
                            self.changeStateCorrect()
                        } else {
                            // 이미 사용 중인 이메일인 경우 상태를 오류로 변경
                            self.changeStateError(self.emailTextField)
                            self.emailErrorLabel.text = "이미 가입된 이메일입니다"
                        }
                    }
                }
            }
            
            // 새로운 작업을 큐에 추가, 0.5초 후 실행
            emailWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
        }
    
    private func showMessage(message: String) {
        print("메시지 : \(message)")
    }
    
    private func changeStateError(_ tf: UITextField) {
        tf.backgroundColor = .warning50
        tf.textColor = .warning400
        tf.setPlaceholderColor(.warning400)
        tf.layer.addBorder([.bottom], color: .warning400, width: 0.5)
        
        if tf == emailTextField {
            emailClearButton.setImage(UIImage(named: "SBJ_clear-red"), for: .normal)
            
            emailErrorView.isHidden = false
            emailErrorLabel.textColor = .warning400
            emailErrorIcon.image = UIImage(named: "SBJ_ErrorCircle")
            updatePasswordLabelConstraint()
            
        } else if tf == passwordTextField {
            passwordClearButton.setImage(UIImage(named: "SBJ_clear-red"), for: .normal)
            passwordEyeButton.setImage(UIImage(named: "SBJ_Password-hidden-red"), for: .normal)
            passwordEyeButton.setImage(UIImage(named: "SBJ_Password-shown-red"), for: .selected)
            
            passwordErrorView.isHidden = false
            updateAutoCheckBoxConstraint()
            
        } else if tf == checkPasswordTextField {
            checkPasswordClearButton.setImage(UIImage(named: "SBJ_clear-red"), for: .normal)
            checkPasswordEyeButton.setImage(UIImage(named: "SBJ_Password-hidden-red"), for: .normal)
            checkPasswordEyeButton.setImage(UIImage(named: "SBJ_Password-shown-red"), for: .selected)
            
            checkPasswordErrorView.isHidden = false
            updateNextButtonTopConstraint()
        }
    }
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
            passwordEyeButton.setImage(UIImage(named: "SBJ_Password-hidden"), for: .normal)
            passwordEyeButton.setImage(UIImage(named: "SBJ_Password-shown"), for: .selected)
            
            passwordErrorView.isHidden = true
            updateAutoCheckBoxConstraint()
            
        } else if tf == checkPasswordTextField {
            checkPasswordClearButton.setImage(UIImage(named: "SBJ_clear"), for: .normal)
            checkPasswordEyeButton.setImage(UIImage(named: "SBJ_Password-hidden"), for: .normal)
            checkPasswordEyeButton.setImage(UIImage(named: "SBJ_Password-shown"), for: .selected)
            
            checkPasswordErrorView.isHidden = true
            updateNextButtonTopConstraint()
        }
    }
    private func changeStateCorrect() {
        emailTextField.layer.addBorder([.bottom], color: .blue400, width: 0.5)
        emailErrorView.isHidden = false
        emailErrorLabel.textColor = .blue400
        emailErrorLabel.text = "해당 이메일은 사용 가능한 이메일입니다"
        emailErrorIcon.image = UIImage(named: "SBJ_CorrectCircle")
        updatePasswordLabelConstraint()
    }
    
    private func validateFieldForButtonUpdate() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let checkPassword = checkPasswordTextField.text ?? ""
        var isEmailValid = false
        var isPasswordValid = false
        var ischeckPasswordValid = false
        
        if isValidEmail(email) {
            checkEmail(email)
        }
        if !email.isEmpty && isValidEmail(email) {
            isEmailValid = true
            changeStateBack(emailTextField)
        }
        
        if !password.isEmpty && password.count >= 6 {
            isPasswordValid = true
            changeStateBack(passwordTextField)
        }
        
        if !checkPassword.isEmpty && checkPassword == password {
            ischeckPasswordValid = true
            changeStateBack(checkPasswordTextField)
        }
        
        if isEmailValid && isPasswordValid && ischeckPasswordValid {
            updateNextButton(enabled: true)
        } else {
            updateNextButton(enabled: false)
        }
    }
    
    private func updateNextButton(enabled: Bool) {
        if enabled {
            nextButton.backgroundColor = .orange700
            nextButton.setTitleColor(.white, for: .normal)
        } else {
            nextButton.backgroundColor = .gray200
            nextButton.setTitleColor(.gray500, for: .normal)
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
        
        view.addSubview(checkPasswordDot)
        view.addSubview(checkPasswordLabel)
        view.addSubview(checkPasswordTextField)
        
        view.addSubview(nextButton)
        
        view.addSubview(passwordRightView)
        passwordRightView.addSubview(passwordEyeButton)
        passwordRightView.addSubview(passwordClearButton)
        
        view.addSubview(checkPasswordRightView)
        checkPasswordRightView.addSubview(checkPasswordEyeButton)
        checkPasswordRightView.addSubview(checkPasswordClearButton)
        
        //Error
        view.addSubview(emailErrorView)
        emailErrorView.addSubview(emailErrorIcon)
        emailErrorView.addSubview(emailErrorLabel)
        
        view.addSubview(passwordErrorView)
        passwordErrorView.addSubview(passwordErrorIcon)
        passwordErrorView.addSubview(passwordErrorLabel)
        
        view.addSubview(checkPasswordErrorView)
        checkPasswordErrorView.addSubview(checkPasswordErrorIcon)
        checkPasswordErrorView.addSubview(checkPasswordErrorLabel)
    }
    
    // MARK: - setLayout
    private func updatePasswordLabelConstraint() {
        passwordLabelTopConstraint?.update(offset: emailErrorView.isHidden ? 20 : 36)
    }
    private func updateAutoCheckBoxConstraint() {
        checkPasswordLabelTopConstraint?.update(offset: passwordErrorView.isHidden ? 20 : 36)
    }
    private func updateNextButtonTopConstraint() {
        nextButtonTopConstraint?.update(offset: checkPasswordErrorView.isHidden ? 54 : 70)
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
        
        checkPasswordLabel.snp.makeConstraints { make in
            checkPasswordLabelTopConstraint = make.top.equalTo(passwordTextField.snp.bottom).offset(20).constraint
            make.leading.equalToSuperview().inset(24)
        }
        
        checkPasswordDot.snp.makeConstraints { make in
            make.top.equalTo(checkPasswordLabel.snp.top)
            make.leading.equalTo(checkPasswordLabel.snp.trailing).offset(4)
        }
        
        checkPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(checkPasswordLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        nextButton.snp.makeConstraints { make in
            nextButtonTopConstraint = make.top.equalTo(checkPasswordTextField.snp.bottom).offset(54).constraint
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
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
        
        passwordEyeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(passwordClearButton.snp.leading).offset(-8)
            make.width.height.equalTo(12)
        }
        
        checkPasswordRightView.snp.makeConstraints { make in
            make.centerY.equalTo(checkPasswordTextField)
            make.trailing.equalTo(checkPasswordTextField.snp.trailing).inset(12)
            make.width.equalTo(32)
            make.height.equalTo(12)
        }
        
        checkPasswordClearButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        checkPasswordEyeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(checkPasswordClearButton.snp.leading).offset(-8)
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
        
        checkPasswordErrorView.snp.makeConstraints { make in
            make.leading.equalTo(checkPasswordTextField)
            make.top.equalTo(checkPasswordTextField.snp.bottom).offset(4)
            make.height.equalTo(12)
        }
        
        checkPasswordErrorIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        checkPasswordErrorLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkPasswordErrorIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - extension
extension EmailSignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.addBorder([.bottom], color: .blue400, width: 0.5)
        if textField == emailTextField {
            emailClearButton.isHidden = false
        }
        if textField == passwordTextField {
            passwordRightView.isHidden = false
        }
        if textField == checkPasswordTextField {
            checkPasswordRightView.isHidden = false
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        if textField == emailTextField {
            emailClearButton.isHidden = true
        }
        if textField == passwordTextField {
            passwordRightView.isHidden = true
        }
        if textField == checkPasswordTextField {
            checkPasswordRightView.isHidden = true
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
           validateFieldForButtonUpdate()
           if textField == emailTextField {
               // 이메일 형식이 유효하지 않거나 이미 존재하는 이메일인 경우 상태를 오류로 변경
               let email = emailTextField.text ?? ""
               if !isValidEmail(email) {
                   changeStateError(emailTextField)
                   emailErrorLabel.text = "올바르지 않은 형식의 이메일 입니다"
               } else {
                   checkEmail(email)
               }
           }
       }
}

//
//  SignUpViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/18/24.
//

import UIKit

class EmailSignUpViewController: UIViewController {
    
    // MARK: - ImageView
    private let emailDot = UIImageView().then {
        $0.image = UIImage(named: "dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let passwordDot = UIImageView().then {
        $0.image = UIImage(named: "dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let checkPasswordDot = UIImageView().then {
        $0.image = UIImage(named: "dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let emailWarningIcon = UIImageView().then {
        $0.image = UIImage(named: "warningCircle")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let passwordWarningIcon = UIImageView().then {
        $0.image = UIImage(named: "warningCircle")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let correctIcon = UIImageView().then {
        $0.image = UIImage(named: "correctCircle")
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
    private let emailWarningLabel = UILabel().then {
        $0.text = "올바르지 않은 형식의 이메일입니다"
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let passwordWarningLabel = UILabel().then {
        $0.text = "비밀번호는 6자리 이상 입력해야 합니다"
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    private let checkPasswordLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let checkPasswordWarningLabel = UILabel().then {
        $0.text = "입력한 비밀번호와 일치하지 않습니다"
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    
    // MARK: - TextField
    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해 주세요"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.clearButtonMode = .whileEditing
        
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
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
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
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
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
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
    }
    
    // MARK: - Button
    private var eyeButton = UIButton().then {
        $0.setImage(UIImage(named: "Password-hidden"), for: .normal)
        $0.setImage(UIImage(named: "Password-shown"), for: .selected)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(eyeButtonTapped(_:)), for: .touchUpInside)
    }
    private var clearButton = UIButton().then {
        $0.setImage(UIImage(named: "clear"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(clearButtonTapped(_:)), for: .touchUpInside)
    }
    private var eyeSecondButton = UIButton().then {
        $0.setImage(UIImage(named: "Password-hidden"), for: .normal)
        $0.setImage(UIImage(named: "Password-shown"), for: .selected)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(eyeSecondButtonTapped(_:)), for: .touchUpInside)
    }
    private var clearSecondButton = UIButton().then {
        $0.setImage(UIImage(named: "clear"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(clearSecondButtonTapped(_:)), for: .touchUpInside)
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음으로", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray200
        $0.setTitleColor(.gray500, for: .normal)
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - View
    private let passwordRightView = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    private let checkPasswordRightView = UIView().then {
        $0.backgroundColor = .clear
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
        
    }
    
    // MARK: - setTextField
    private func setTextFieldDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        checkPasswordTextField.delegate = self
        
        if let clearButton = emailTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(named: "clear"), for: .normal)
            clearButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        }
    }
    
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "회원가입"
    }
    
    // MARK: - Screen transition
    @objc private func nextButtonTapped() {
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
    
    // MARK: - addView
    func setupViews() {
        view.addSubview(emailDot)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        
        view.addSubview(passwordDot)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        
        view.addSubview(checkPasswordDot)
        view.addSubview(checkPasswordLabel)
        view.addSubview(checkPasswordTextField)
        
        view.addSubview(nextButton)
        
        view.addSubview(passwordRightView)
        passwordRightView.addSubview(eyeButton)
        passwordRightView.addSubview(clearButton)
        
        view.addSubview(checkPasswordRightView)
        checkPasswordRightView.addSubview(eyeSecondButton)
        checkPasswordRightView.addSubview(clearSecondButton)
    }
    
    // MARK: - setLayout
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
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
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
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
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
            make.top.equalTo(checkPasswordTextField.snp.bottom).offset(54)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        passwordRightView.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField)
            make.trailing.equalTo(passwordTextField.snp.trailing).inset(12)
            make.width.equalTo(32)
            make.height.equalTo(12)
        }
        
        clearButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        eyeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(clearButton.snp.leading).offset(-8)
            make.width.height.equalTo(12)
        }
        
        checkPasswordRightView.snp.makeConstraints { make in
            make.centerY.equalTo(checkPasswordTextField)
            make.trailing.equalTo(checkPasswordTextField.snp.trailing).inset(12)
            make.width.equalTo(32)
            make.height.equalTo(12)
        }
        
        clearSecondButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        eyeSecondButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(clearSecondButton.snp.leading).offset(-8)
            make.width.height.equalTo(12)
        }
    }
}

// MARK: - extension
extension EmailSignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.addBorder([.bottom], color: .blue400, width: 0.5)
        if textField == passwordTextField {
            passwordRightView.isHidden = false
        }
        if textField == checkPasswordTextField {
            checkPasswordRightView.isHidden = false
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        if textField == passwordTextField {
            passwordRightView.isHidden = true
        }
        if textField == checkPasswordTextField {
            checkPasswordRightView.isHidden = true
        }
        return true
    }
    
}

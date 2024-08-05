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

    // MARK: - Label
    private let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let emailWarningLabel = UILabel().then {
        $0.text = "이메일을 입력해 주세요"
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
        $0.text = "비밀번호를 입력해 주세요"
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
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
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        
    }
    // MARK: - Button
    private let autoLoginCheckBox = UIButton().then {
        $0.setImage(UIImage(named: "state=off"), for: .normal)
        $0.setImage(UIImage(named: "state=on"), for: .selected)
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
    
    // MARK: - View
    private let verticalSeparator = UIView().then {
        $0.backgroundColor = .gray500
    }
    private let passwordRightView = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpNavigationBar()
        setupViews()
        setupLayout()
        setTextFieldDelegate()
    }
    
    // MARK: - setTextField
    private func setTextFieldDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        if let clearButton = emailTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(named: "clear"), for: .normal)
            clearButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        }
    }
    
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "이메일로 로그인"
    }
    
    // MARK: - Screen transition
    @objc private func signUpButtonTapped() {
        // 회원가입 뷰 띄우기
        let SignUpVC = SignUpViewController()
        self.navigationController?.pushViewController(SignUpVC, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    // MARK: - Functional
    @objc private func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    @objc private func eyeButtonTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
    @objc private func clearButtonTapped(_ sender: UIButton) {
        passwordTextField.text = ""
    }

    // MARK: - addView
    func setupViews() {
        view.addSubview(emailDot)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        
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
        passwordRightView.addSubview(clearButton)
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
        
        autoLoginCheckBox.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
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
        
    }
}
// MARK: - extension
extension EmailLoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.addBorder([.bottom], color: .blue400, width: 0.5)
        if textField == passwordTextField {
                    passwordRightView.isHidden = false
                }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        if textField == passwordTextField {
                   passwordRightView.isHidden = true
               }
        return true
    }
    
}



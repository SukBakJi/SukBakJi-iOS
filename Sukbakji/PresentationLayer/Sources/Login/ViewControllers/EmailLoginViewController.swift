//
//  EmailLoginViewControllers.swift
//  Sukbakji
//
//  Created by 오현민 on 7/16/24.
//

import UIKit


class EmailLoginViewController: UIViewController {
    // MARK: - Properties
    var isAutoLogin: Bool = false

    // MARK: - View
    private lazy var emailView = EmailView().then {
        $0.autoLoginButton.addTarget(self, action: #selector(didTapAutoLogin), for: .touchUpInside)
        $0.loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        $0.findEmailButton.addTarget(self, action: #selector(didTapFindEmail), for: .touchUpInside)
        $0.resetPWButton.addTarget(self, action: #selector(didTapResetPW), for: .touchUpInside)
        $0.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        
        // 입력값 변경 시 버튼 활성화 상태 업데이트
        $0.textFieldChanged = { [weak self] in
            self?.updateLoginButtonState()
        }
    }
   
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = emailView
        self.title = "이메일로 로그인"
        
        updateLoginButtonState()
        validation()
    }
    
    //MARK: - Functional
    private func validation() {
        emailView.emailTF.validation(
            textField: emailView.emailTF,
            regex: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$",
            errorMessage: "올바르지 않은 형식의 이메일 입니다",
            emptyErrorMessage: "이메일을 입력해 주세요"
        )
        
        emailView.passwordTF.validation(
            textField: emailView.passwordTF,
            regex: "^.{6,}$",
            errorMessage: "비밀번호는 6자 이상이어야 합니다",
            emptyErrorMessage: "비밀번호를 입력해 주세요"
        )
    }
    
    private func updateLoginButtonState() {
        let isEmailValid = emailView.emailTF.validationHandler?(emailView.emailTF.textField.text) ?? false
        let isPasswordValid = emailView.passwordTF.validationHandler?(emailView.passwordTF.textField.text) ?? false
        
        let isEnabled = isEmailValid && isPasswordValid
        emailView.loginButton.isEnabled = isEnabled
        emailView.loginButton.setButtonState(isEnabled: isEnabled)
    }
    
    private func pushToNextVC(_ nextVC: UIViewController) {
        let nextVC = nextVC
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil).then {
            $0.tintColor = .black
        }
    }
    
    //MARK: Event
    @objc
    private func didTapAutoLogin(_ sender: UIButton) {
        sender.isSelected.toggle()
        isAutoLogin = sender.isSelected
        UserDefaults.standard.set(isAutoLogin, forKey: "isAutoLogin")
    }
    
    @objc
    private func didTapLogin() {
        callPostLogin()
    }
    
    @objc
    private func didTapFindEmail() {
        pushToNextVC(FindEmailViewController())
    }
    
    @objc
    private func didTapResetPW() {
        
    }
    
    @objc
    private func didTapSignUp() {
        pushToNextVC(SignupViewController())
    }
    
    //MARK: - Network
    private func callPostLogin() {
        let email = emailView.emailTF.textField.text ?? ""
        let password = emailView.passwordTF.textField.text ?? ""
        let request = LoginRequestDTO(email: email, password: password)

        let authDataManager = AuthDataManager()
        
        authDataManager.loginDataManager(request) {
            [weak self] loginModel in
            guard let self = self else { return }
            
            if let model = loginModel, model.code == "COMMON200" {
                pushToNextVC(MainTabViewController())
            }
            else if let model = loginModel, model.isSuccess == false {
                emailView.emailTF.textField.setErrorState()
                emailView.passwordTF.setErrorState(true)
                emailView.passwordTF.setErrorMessage("입력한 이메일 또는 비밀번호가 일치하지 않습니다")
                emailView.loginButton.isEnabled = false
            }
        }
    }
}



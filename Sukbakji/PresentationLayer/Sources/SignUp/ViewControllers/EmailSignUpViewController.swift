//
//  SignUpViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/18/24.
//

import UIKit
import SnapKit

class EmailSignUpViewController: UIViewController {
    private var emailDupCheck: Bool = false
    
    // MARK: - View
    private lazy var emailSignupView = EmailSignupView().then {
        $0.nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        $0.textFieldChanged = { [weak self] in
            self?.updateLoginButtonState()
        }
    }
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = emailSignupView
        self.title = "회원가입"
        
        updateLoginButtonState()
        validation()
        
        emailSignupView.emailTF.textField.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Notification
    private func setNotification() {
        NotificationCenter.default.addObserver(
               self,
               selector: #selector(handleTextFieldClear(_:)),
               name: .textFieldDidClear,
               object: nil
           )
    }
    
    @objc
    private func handleTextFieldClear(_ notification: Notification) {
        updateLoginButtonState()
    }
    
    //MARK: - Functional
    private func validation() {
        emailSignupView.emailTF.validation(
            textField: emailSignupView.emailTF,
            regex: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$",
            errorMessage: "올바르지 않은 형식의 이메일 입니다",
            emptyErrorMessage: "이메일을 입력해 주세요"
        )
        
        emailSignupView.passwordTF.validation(
            textField: emailSignupView.passwordTF,
            regex: "^.{6,}$",
            errorMessage: "비밀번호는 6자 이상이어야 합니다",
            emptyErrorMessage: "비밀번호를 입력해 주세요"
        )
        
        emailSignupView.passwordCheckTF.checkPassword(
            textField: emailSignupView.passwordCheckTF,
            passwordField: emailSignupView.passwordTF,
            errorMessage: "입력한 비밀번호와 일치하지 않습니다",
            emptyErrorMessage: "비밀번호를 입력해 주세요"
        )
    }
    
    private func updateLoginButtonState() {
        let isEnabled = [
            emailDupCheck,
            emailSignupView.emailTF.validationHandler?(emailSignupView.emailTF.textField.text) ?? false,
            emailSignupView.passwordTF.validationHandler?(emailSignupView.passwordTF.textField.text) ?? false,
            emailSignupView.passwordCheckTF.validationHandler?(emailSignupView.passwordCheckTF.textField.text) ?? false
        ].allSatisfy { $0 }
        
        emailSignupView.nextButton.setButtonState(isEnabled: isEnabled)
    }
    
    private func pushToNextVC(_ nextVC: UIViewController) {
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil).then {
            $0.tintColor = .black
        }
    }
    
    //MARK: Event
    @objc
    private func didTapNext() {
        callPostSignup()
    }
    
    //MARK: - Network
    private func callPostSignup() {
        let email = emailSignupView.emailTF.textField.text ?? ""
        let password = emailSignupView.passwordTF.textField.text ?? ""
        let request = SignupRequestDTO(provider: "BASIC",
                                       email: email,
                                       password: password)
        
        let authDataManager = AuthDataManager()
        
        authDataManager.signupDataManager(request) {
            [weak self] SignupModel in
            guard let self = self else { return }
            
            if let model = SignupModel, model.code == "COMMON200" {
                callPostLogin(email, password) // 토큰 발급용
            } else {
                emailSignupView.nextButton.setButtonState(isEnabled: false)
                emailSignupView.nextButton.isEnabled = false
            }
        }
    }
    
    private func callPostCheckDuplicate(_ email: String) {
        let authDataManager = AuthDataManager()
        authDataManager.EmailDataManager(email) {
            [weak self] SignUpModel in
            guard let self = self else { return }
            
            if let model = SignUpModel {
                if model.result == "사용 가능한 이메일입니다." {
                    // 사용 가능한 이메일입니다(파란밑줄)
                    emailSignupView.emailTF.setCorrectState()
                    emailSignupView.emailTF.setErrorMessage("사용 가능한 이메일입니다")
                    emailDupCheck = true
                } else {
                    emailSignupView.emailTF.setErrorState(true)
                    emailSignupView.emailTF.setErrorMessage("이미 가입된 이메일입니다")
                    emailDupCheck = false
                }
            }
            updateLoginButtonState()
        }
    }
    
    private func callPostLogin(_ email: String, _ pw: String) {
        let authDataManager = AuthDataManager()
        
        let input = LoginRequestDTO(email: email, password: pw)
        
        authDataManager.loginDataManager(input) {
            [weak self] data in
            guard let self = self else { return }
            
            if let data = data, data.code == "COMMON200" {
                print("토큰 발급 성공")
                pushToNextVC(AcademicVerificationViewController())
            }
        }
    }
}

//MARK: - UITextFieldDelegate (
//이메일 중복 체크
extension EmailSignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == emailSignupView.emailTF.textField,
              let emailText = textField.text,
              emailSignupView.emailTF.validationHandler?(emailText) ?? false else { return }
        
        callPostCheckDuplicate(emailText)
    }
}

//
//  FindPwViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 3/14/25.
//

import UIKit

class FindPwViewController: UIViewController {
    private var verifiedEmail: String?  // 인증된 전화번호 저장
    private var isSuccessSent: Bool = false

    // MARK: - View
    private lazy var findPwView = FindPwView().then {
        $0.nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        $0.sendCode.addTarget(self, action: #selector(didTapSendCode), for: .touchUpInside)
        $0.verifyCode.addTarget(self, action: #selector(didTapVerifyCode), for: .touchUpInside)
        
        // 입력값 변경 시 버튼 활성화 상태 업데이트
        $0.textFieldChanged = { [weak self] in
            self?.updateNextButtonState()
        }
    }
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = findPwView
        self.title = "비밀번호 재설정"
        
        updateNextButtonState()
        validation()
    }
 
    //MARK: - Functional
    private func validation() {
        findPwView.emailTF.validation(
            textField: findPwView.emailTF,
            regex: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$",
            errorMessage: "올바르지 않은 형식의 이메일 입니다",
            emptyErrorMessage: "이메일을 입력해 주세요"
        )
        findPwView.verifyCodeTF.validation(
            textField: findPwView.verifyCodeTF,
            regex: "^.{4,8}$",
            errorMessage: "인증번호가 일치하지 않습니다"
        )
    }
    
    private func updateNextButtonState() {
        let isEmailValid = findPwView.emailTF.validationHandler?(findPwView.emailTF.textField.text) ?? false
        let isCodeValid = findPwView.verifyCodeTF.validationHandler?(findPwView.verifyCodeTF.textField.text) ?? false
        findPwView.sendCode.setButtonState(isEnabled: isEmailValid)

        // 인증요청 성공 시 인증하기 버튼 활성화
        let isEnable = isCodeValid && isSuccessSent
        findPwView.verifyCode.setButtonState(isEnabled: isEnable)
    }
    
    private func pushToNextVC(_ nextVC: UIViewController) {
        let nextVC = nextVC
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil).then {
            $0.tintColor = .black
        }
    }
    
    private func setUnableState(isSuccess: Bool) {
        if isSuccess {
            findPwView.emailTF.textField.setUnableState()
            findPwView.verifyCodeTF.textField.setUnableState()
            findPwView.sendCode.setButtonState(isEnabled: false)
            findPwView.verifyCode.setButtonState(isEnabled: false)
            findPwView.sendCode.isUserInteractionEnabled = false
            findPwView.verifyCode.isUserInteractionEnabled = false
            findPwView.nextButton.setButtonState(isEnabled: true)
            findPwView.nextButton.isEnabled = true
            ToastView.show(image: UIImage(named: "SBJ_complete") ?? UIImage(), message: "인증번호 인증을 완료했어요", in: self.view)
        } else {
            findPwView.verifyCodeTF.setValidationMode(.errorWithMessage)
            findPwView.verifyCodeTF.setErrorState(true)
            findPwView.verifyCodeTF.setErrorMessage("인증번호가 일치하지 않습니다")
        }
    }
    
    //MARK: Event
    @objc
    private func didTapNext() {
        guard let email = verifiedEmail else { return }
        
        let nextVC = ResetPwViewController()
        nextVC.email = email
        pushToNextVC(nextVC)
    }
    
    @objc
    private func didTapSendCode() {
        let isEmailValid = findPwView.emailTF.validationHandler?(findPwView.emailTF.textField.text) ?? false
        if !isEmailValid {
            ToastView.show(image: UIImage(named: "SBJ_warning") ?? UIImage(), message: "이메일을 입력해 주세요", in: self.view)
        } else {
            callPostEmailCode()
        }
    }
    
    @objc
    private func didTapVerifyCode() {
        let isVerifyCodeValid = findPwView.verifyCodeTF.validationHandler?(findPwView.verifyCodeTF.textField.text) ?? false
        if !isVerifyCodeValid {
            ToastView.show(image: UIImage(named: "SBJ_warning") ?? UIImage(), message: "인증번호를 입력해 주세요", in: self.view)
        } else {
            callPostEmailCodeCheck()
        }
    }
    
    //MARK: - Network
    // 비밀번호 찾기 이메일 코드
    private func callPostEmailCode() {
        let email = findPwView.emailTF.textField.text ?? ""
        
        let authDataManager = AuthDataManager()
        print(email)
        authDataManager.EmailSentCodeDataManager(email) {
            [weak self] data in
            guard let self = self else { return }
            
            if let model = data, model.code == "COMMON200" {
                self.verifiedEmail = email // 인증된 전화번호 저장
                self.isSuccessSent = true
                ToastView.show(image: UIImage(named: "SBJ_complete") ?? UIImage(), message: "인증번호를 발송했어요", in: self.view)
            }
        }
    }
    
    // 이메일 코드 인증
    private func callPostEmailCodeCheck() {
        guard let email = verifiedEmail else { return }
        let code = findPwView.verifyCodeTF.textField.text ?? ""
        let request = PostUserEmailCodeRequestDTO(email: email, code: code)
        
        let authDataManager = AuthDataManager()
        authDataManager.EmailCodeCheckDataManager(request) {
            [weak self] data in
            guard let self = self else { return }
            
            if let model = data, model.result == "이메일 인증에 성공하였습니다." {
                setUnableState(isSuccess: true)
            } else {
                setUnableState(isSuccess: false)
            }
        }
    }
}

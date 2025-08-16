//
//  ResetPwViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 3/14/25.
//

import UIKit

class ResetPwViewController: UIViewController {
    var email: String = ""
    
    // MARK: - View
    private lazy var resetPwView = ResetPwView().then {
        $0.nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        
        // 입력값 변경 시 버튼 활성화 상태 업데이트
        $0.textFieldChanged = { [weak self] in
            self?.updateNextButtonState()
        }
    }
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = resetPwView
        self.title = "비밀번호 재설정"
        
        updateNextButtonState()
        validation()
    }
    
    //MARK: - Functional
    private func validation() {
        resetPwView.passwordTF.validation(
            textField: resetPwView.passwordTF,
            regex: "^.{6,}$",
            errorMessage: "비밀번호는 6자 이상이어야 합니다",
            emptyErrorMessage: "비밀번호를 입력해 주세요"
        )
        resetPwView.passwordCheckTF.checkPassword(
            textField: resetPwView.passwordCheckTF,
            passwordField: resetPwView.passwordTF,
            errorMessage: "입력한 비밀번호와 일치하지 않습니다",
            emptyErrorMessage: "비밀번호를 입력해 주세요"
        )
    }
    
    private func updateNextButtonState() {
        let isEnabled = [
            resetPwView.passwordTF.validationHandler?(resetPwView.passwordTF.textField.text) ?? false,
            resetPwView.passwordCheckTF.validationHandler?(resetPwView.passwordCheckTF.textField.text) ?? false
        ].allSatisfy { $0 }
        
        resetPwView.nextButton.setButtonState(isEnabled: isEnabled)
    }
    
    //MARK: Event
    @objc
    private func didTapNext() {
        // 비밀번호 재설정하기
        callPostResetPassword()
    }
    
    //MARK: - Network
    private func callPostResetPassword() {
        let confirmPassword = resetPwView.passwordCheckTF.textField.text ?? ""
        let request = PostResetPasswordRequestDTO(
            email: email,
            password: confirmPassword
        )
        print(request)
        let authDataManager = AuthDataManager()
        authDataManager.ResetPasswordDataManager(request){
            [weak self] data in
            guard let self = self else { return }
            print(request)
            if let model = data, model.result == "비밀번호를 재설정하였습니다." {
                navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

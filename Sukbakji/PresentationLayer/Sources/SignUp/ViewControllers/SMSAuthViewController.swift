//
//  SMSAuthViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 3/7/25.
//

import UIKit

class SMSAuthViewController: UIViewController {
    
    private lazy var smsAuthView = SMSAuthView().then {
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
        self.view = smsAuthView
        self.title = "휴대폰 인증"
        
        updateNextButtonState()
        validation()
    }
    
    //MARK: - Functional
    private func validation() {
        smsAuthView.phoneNumTF.validation(
            textField: smsAuthView.phoneNumTF,
            regex: "^01[0-9]\\d{3,4}\\d{4}$"
        )
        smsAuthView.verifyCodeTF.validation(
            textField: smsAuthView.verifyCodeTF,
            regex: "^[0-9]{0,6}$"
        )
    }
    
    private func updateNextButtonState() {
        let isPhoneNumValid = smsAuthView.phoneNumTF.validationHandler?(smsAuthView.phoneNumTF.textField.text) ?? false
        let isVerifyCodeValid = smsAuthView.verifyCodeTF.validationHandler?(smsAuthView.verifyCodeTF.textField.text) ?? false
        
        smsAuthView.sendCode.isEnabled = isPhoneNumValid
        smsAuthView.sendCode.setButtonState(isEnabled: isPhoneNumValid)

        // 번호 발송이 성공했을때만도 이내이블 조건에 추가해야함
        smsAuthView.verifyCode.isEnabled = isVerifyCodeValid
        
        
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
    private func didTapNext() {
        pushToNextVC(EmailSignUpViewController())
    }
    
    @objc
    private func didTapSendCode() {
        print("엥")
    }
    
    @objc
    private func didTapVerifyCode() {
        
    }
    
    //MARK: - Network
    // 인증번호 요청
    private func callPostRequestSMS() {
        let phoneNum = smsAuthView.phoneNumTF.textField.text ?? ""
        let request = SmsCodeRequestDTO(phoneNumber: phoneNum)
        
        let smsDataManager = SmsDataManager()
        
        smsDataManager.smsCodeDataManager(request) {
            [weak self] loginModel in
            guard let self = self else { return }
            
            if let model = loginModel, model.code == "COMMON200" {
                print("인증번호 요청 성공")
            }
        }
    }
}

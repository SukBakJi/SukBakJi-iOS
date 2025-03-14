//
//  SMSAuthViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 3/7/25.
//

import UIKit

class SMSAuthViewController: UIViewController {
    private var verifiedPhoneNumber: String?  // 인증된 전화번호 저장
    private var isSuccessSent: Bool = false

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
            regex: "^[0-9]{0,6}$",
            errorMessage: "인증번호가 일치하지 않습니다"
        )
    }
    
    private func updateNextButtonState() {
        let isPhoneNumValid = smsAuthView.phoneNumTF.validationHandler?(smsAuthView.phoneNumTF.textField.text) ?? false
        let isCodeValid = smsAuthView.verifyCodeTF.validationHandler?(smsAuthView.verifyCodeTF.textField.text) ?? false
        smsAuthView.sendCode.setButtonState(isEnabled: isPhoneNumValid)

        // 인증요청 성공 시 인증하기 버튼 활성화
        let isEnable = isCodeValid && isSuccessSent
        smsAuthView.verifyCode.setButtonState(isEnabled: isCodeValid)
    }
    
    private func pushToNextVC(_ nextVC: UIViewController) {
        let nextVC = nextVC
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil).then {
            $0.tintColor = .black
        }
    }
    
    private func setUnableState(isSuccess: Bool, message: String = "") {
        if isSuccess {
            smsAuthView.phoneNumTF.textField.setUnableState()
            smsAuthView.verifyCodeTF.textField.setUnableState()
            smsAuthView.sendCode.setButtonState(isEnabled: false)
            smsAuthView.verifyCode.setButtonState(isEnabled: false)
            smsAuthView.sendCode.isUserInteractionEnabled = false
            smsAuthView.verifyCode.isUserInteractionEnabled = false
            smsAuthView.nextButton.setButtonState(isEnabled: true)
            smsAuthView.nextButton.isEnabled = true
        } else {
            smsAuthView.verifyCodeTF.setValidationMode(.errorWithMessage)
            smsAuthView.verifyCodeTF.setErrorState(true)
            smsAuthView.verifyCodeTF.setErrorMessage(message)
        }
    }
    
    //MARK: Event
    @objc
    private func didTapNext() {
        guard let phoneNumber = verifiedPhoneNumber else {
            print("오류: 인증된 전화번호가 없음")
            return
        }
        
        let nextVC = EmailSignUpViewController()
        nextVC.phoneNum = smsAuthView.phoneNumTF.textField.text ?? ""
        pushToNextVC(nextVC)
    }
    
    @objc
    private func didTapSendCode() {
        let isPhoneNumValid = smsAuthView.phoneNumTF.validationHandler?(smsAuthView.phoneNumTF.textField.text) ?? false
        if !isPhoneNumValid {
            ToastView.show(image: UIImage(named: "SBJ_warning") ?? UIImage(), message: "전화번호를 입력해 주세요", in: self.view)
        } else {
            callPostRequestSMS()
        }
    }
    
    @objc
    private func didTapVerifyCode() {
        let isVerifyCodeValid = smsAuthView.verifyCodeTF.validationHandler?(smsAuthView.verifyCodeTF.textField.text) ?? false
        if !isVerifyCodeValid {
            ToastView.show(image: UIImage(named: "SBJ_warning") ?? UIImage(), message: "인증번호를 입력해 주세요", in: self.view)
        } else {
            callPostVerifyCode()
        }
    }
    
    //MARK: - Network
    // 인증번호 요청
    private func callPostRequestSMS() {
        let phoneNum = smsAuthView.phoneNumTF.textField.text ?? ""
        let request = SmsCodeRequestDTO(phoneNumber: phoneNum)
        
        let smsDataManager = SmsDataManager()
        smsDataManager.smsCodeDataManager(request) {
            [weak self] data in
            guard let self = self else { return }
            if let model = data, model.code == "COMMON200" {
                self.verifiedPhoneNumber = phoneNum // 인증된 전화번호 저장
                self.isSuccessSent = true

            }
        }
    }
    
    private func callPostVerifyCode() {
        guard let phoneNum = verifiedPhoneNumber else { return }
        let code = smsAuthView.verifyCodeTF.textField.text ?? ""
        let request = VerifyCodeRequestDTO(phoneNumber: phoneNum, verificationCode: code)
        let smsDataManager = SmsDataManager()
        
        smsDataManager.smsVerifyDataManager(request) {
            [weak self] data in
            guard let self = self else { return }
            if let model = data, model.code == "COMMON200" {
                setUnableState(isSuccess: true)
            } else if let model = data, model.code == "AUTH4005" {
                setUnableState(isSuccess: false, message: "이미 등록된 휴대폰 번호입니다")
            } else {
                setUnableState(isSuccess: false, message: "인증번호가 일치하지 않습니다")
            }
        }
    }
}

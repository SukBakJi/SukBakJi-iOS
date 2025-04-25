//
//  FindViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 2/28/25.
//

import UIKit

class FindEmailViewController: UIViewController {
    // MARK: - View
    private lazy var findEmailView = FindEmailView().then {
        $0.nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        
        // 입력값 변경 시 버튼 활성화 상태 업데이트
        $0.textFieldChanged = { [weak self] in
            self?.updateNextButtonState()
        }
    }
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = findEmailView
        self.title = "이메일 찾기"
        
        updateNextButtonState()
        validation()
    }
    
    //MARK: - Functional
    private func validation() {
        findEmailView.nameTF.validation(
            textField: findEmailView.nameTF,
            regex: "^(?=.*[가-힣a-zA-Z])[가-힣a-zA-Z]+$",
            errorMessage: "이름이 형식에 맞지 않습니다",
            emptyErrorMessage: "이름을 입력해 주세요"
        )
        findEmailView.phoneNumTF.validation(
            textField: findEmailView.phoneNumTF,
            regex: "^01[0-9]\\d{3,4}\\d{4}$",
            errorMessage: "전화번호가 형식에 맞지 않습니다",
            emptyErrorMessage: "전화번호를 입력해 주세요"
        )
    }
    
    private func updateNextButtonState() {
        let isNameValid = findEmailView.nameTF.validationHandler?(findEmailView.nameTF.textField.text) ?? false
        let isPhoneNumValid = findEmailView.phoneNumTF.validationHandler?(findEmailView.phoneNumTF.textField.text) ?? false
        
        findEmailView.nextButton.setButtonState(isEnabled: isNameValid && isPhoneNumValid)
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
        callPostMemberEmail()
    }
    
    //MARK: - Network
    // 이름과 전화번호로 이메일 찾기
    private func callPostMemberEmail() {
        let name = findEmailView.nameTF.textField.text ?? ""
        let phoneNum = findEmailView.phoneNumTF.textField.text ?? ""
        let request = PostUserEmailRequestDTO(name: name, phoneNumber: phoneNum)
        
        let authDataManager = AuthDataManager()
        
        authDataManager.MemberEmailDataManager(request) {
            [weak self] data in
            guard let self = self else { return }
            
            if let model = data, model.result == "AUTH4003" {
                let popup = SingleButtonPopup(
                    title: "입력한 정보가 일치하지 않습니다",
                    confirmText: "다시 입력할게요"
                )
                popup.show()
            } else if let model = data {
                guard let email = model.result else { return }
                let popup = DoubleButtonPopup(
                    title: "가입하신 이메일을 확인해 주세요",
                    desc: "\(name) 님이 가입하신 이메일은\n \(email)입니다.",
                    range: email,
                    confirmText: "로그인 하기",
                    cancleText: "비밀번호 찾기",
                    confirmAction: { [weak self] in
                        self?.pushToNextVC(EmailLoginViewController())
                    },
                    cancleAction: { [weak self] in
                        self?.pushToNextVC(FindPwViewController())
                    })
                
                popup.show()
                
            }
        }
    }
}

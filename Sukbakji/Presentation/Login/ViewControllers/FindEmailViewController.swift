//
//  FindViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 2/28/25.
//

import UIKit

class FindEmailViewController: UIViewController {
    
    private lazy var findView = FindEmailView()
    
    override func loadView() {
        self.view = findView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "이메일 찾기"
        setTextFieldDelegate()
    }
    
    private func setTextFieldDelegate() {
        findView.nameTextField.delegate = self
        findView.phoneNumTextField.delegate = self
    }
}

extension FindEmailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.addBorder([.bottom], color: .blue400, width: 0.5)
        if textField == findView.nameTextField {
            findView.nameClearButton.isHidden = false
        }
        if textField == findView.phoneNumTextField {
            findView.phoneNumClearButton.isHidden = false
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        if textField == findView.nameTextField {
            findView.nameClearButton.isHidden = true
        }
        if textField == findView.phoneNumTextField {
            findView.phoneNumClearButton.isHidden = true
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        findView.validateFieldForButtonUpdate()
        
        if textField == findView.nameTextField {
            let name = findView.nameTextField.text ?? ""
            if !findView.isValidName(name) {
                findView.changeStateError(findView.nameTextField)
                findView.nameErrorLabel.text = "올바르지 않은 형식의 이름입니다"
            } else {
                findView.changeStateBack(findView.nameTextField)
            }
        }
        
        if textField == findView.phoneNumTextField {
            let phoneNum = findView.phoneNumTextField.text ?? ""
            if phoneNum.count < 6 {
                findView.changeStateError(findView.phoneNumTextField)
                findView.phoneNumErrorLabel.text = "전화번호가 형식에 맞지 않습니다"
            } else {
                findView.changeStateBack(findView.phoneNumTextField)
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 전화번호 입력 필드일 경우 하이픈 제거 처리
        if textField == findView.phoneNumTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            // 숫자만 입력 가능하도록 설정 (하이픈 입력 방지)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}

//
//  SMSAuthView.swift
//  Sukbakji
//
//  Created by 오현민 on 3/7/25.
//

import UIKit

class SMSAuthView: UIView {
    //MARK: - Properties
    var textFieldChanged: (() -> Void)? // 입력값 변경 이벤트 전달용 클로저
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setView()
        setConstraints()
        addTargets()
        setDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functional
    @objc
    private func textFieldDidChange() {
        textFieldChanged?() // 입력값이 변경될 때 VC에 이벤트 전달
    }
    
    private func addTargets() {
        phoneNumTF.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        verifyCodeTF.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setDelegates() {
        phoneNumTF.textField.delegate = self
        verifyCodeTF.textField.delegate = self
    }
    
    private func makeStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = .fill
        return stack
    }
    
    //MARK: - Components
    private lazy var TFView = makeStack(axis: .vertical, spacing: 20)
    
    public lazy var phoneNumTF = CommonTextFieldView().then {
        $0.setTitle("전화번호")
        $0.setPlaceholder("전화번호를 입력해 주세요")
        $0.setValidationMode(.silentValidation)
        $0.textField.keyboardType = .numberPad
    }
    
    public lazy var sendCode = OrangeButton(title: "번호 발송", height: 44).then {
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    
    public lazy var verifyCodeTF = CommonTextFieldView().then {
        $0.setTitle("인증번호")
        $0.setPlaceholder("인증번호 6자리를 입력해 주세요")
        $0.setValidationMode(.silentValidation)
        $0.textField.keyboardType = .numberPad
    }
    
    public lazy var verifyCode = OrangeButton(title: "인증하기", height: 44).then {
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    
    public lazy var nextButton = OrangeButton(title: "다음으로", isEnabled: false).then {
        $0.isEnabled = false
    }
    
    //MARK: - SetUI
    private func setView() {
        addSubviews([TFView, nextButton, sendCode, verifyCode])
        TFView.addArrangedSubViews([phoneNumTF, verifyCodeTF])
    }
    
    private func setConstraints() {
        TFView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.left.equalToSuperview().inset(24)
            $0.trailing.equalTo(sendCode.snp.leading).offset(-8)
        }
        
        sendCode.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(phoneNumTF.textField.snp.top)
            $0.width.equalTo(68)
        }
        
        verifyCode.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(verifyCodeTF.textField.snp.top)
            $0.width.equalTo(68)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(100)
        }
    }
}

extension SMSAuthView: UITextFieldDelegate {
    // 특정 문자 입력 방지 (숫자만 허용 & 하이픈(-) 입력 방지)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        // 숫자 입력만 허용
        guard allowedCharacters.isSuperset(of: characterSet) else {
            return false
        }
        
        // 현재 텍스트
        guard let currentText = textField.text as NSString? else {
            return true
        }
        
        // 변경 후 예상되는 텍스트
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        // 최대 글자수 제한
        if textField == phoneNumTF.textField {
            return newText.count <= 11
        } else if textField == verifyCodeTF.textField {
            return newText.count <= 6
        }
        
        return true
    }
}

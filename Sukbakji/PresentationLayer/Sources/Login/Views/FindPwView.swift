//
//  FindPwView.swift
//  Sukbakji
//
//  Created by 오현민 on 3/14/25.
//

import UIKit

class FindPwView: UIView {
    //MARK: - Properties
    var textFieldChanged: (() -> Void)? // 입력값 변경 이벤트 전달용 클로저

    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setView()
        setConstraints()
        addTargets()
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
        emailTF.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        verifyCodeTF.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
    
    public lazy var emailTF = CommonTextFieldView().then {
        $0.setTitle("이메일")
        $0.setPlaceholder("이메일을 입력해 주세요")
        $0.setValidationMode(.errorWithMessage)
        $0.textField.keyboardType = .emailAddress
    }
    
    public lazy var sendCode = OrangeButton(title: "번호 발송", height: 44).then {
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    
    public lazy var verifyCodeTF = CommonTextFieldView().then {
        $0.setTitle("인증번호")
        $0.setPlaceholder("인증번호 8자리를 입력해 주세요")
        $0.setValidationMode(.silentValidation)
    }
    
    public lazy var verifyCode = OrangeButton(title: "인증하기", height: 44).then {
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    
    public lazy var nextButton = OrangeButton(title: "비밀번호 재설정하기", isEnabled: false).then {
        $0.isEnabled = false
    }
    
    //MARK: - SetUI
    private func setView() {
        addSubviews([TFView, nextButton, sendCode, verifyCode])
        TFView.addArrangedSubViews([emailTF, verifyCodeTF])
    }
    
    private func setConstraints() {
        TFView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.left.equalToSuperview().inset(24)
            $0.trailing.equalTo(sendCode.snp.leading).offset(-8)
        }
        
        sendCode.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(emailTF.textField.snp.top)
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


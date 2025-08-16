//
//  ResetPwView.swift
//  Sukbakji
//
//  Created by 오현민 on 3/14/25.
//

import UIKit

class ResetPwView: UIView {
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
        passwordTF.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordCheckTF.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func makeStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
            let stack = UIStackView()
            stack.axis = axis
            stack.spacing = spacing
            stack.distribution = .fill
            return stack
        }
    
    public func checkPassword(textField: CommonTextFieldView, passwordField: CommonTextFieldView, errorMessage: String = "", emptyErrorMessage: String = "") {
        textField.validationHandler = { text in
            guard let text = text, !text.isEmpty else {
                textField.setErrorMessage(emptyErrorMessage)
                return false
            }

            let isValid = passwordField.textField.text == text
            if !isValid { textField.setErrorMessage(errorMessage) }
            return isValid
        }
    }
    
    //MARK: - Components
    private lazy var TFView = makeStack(axis: .vertical, spacing: 20)
    public var passwordTF = CommonTextFieldView().then {
        $0.setTitle("새로운 비밀번호")
        $0.setPlaceholder("새로운 비밀번호를 입력해 주세요")
    }
    public var passwordCheckTF = CommonTextFieldView().then {
        $0.setTitle("새로운 비밀번호 확인")
        $0.setPlaceholder("새로운 비밀번호를 입력해 주세요")
    }
    
    public var nextButton = OrangeButton(title: "비밀번호 재설정하기", isEnabled: false)
    
    //MARK: - SetUI
    private func setView() {
        addSubviews([TFView, nextButton])
        TFView.addArrangedSubViews([passwordTF, passwordCheckTF])
    }
    
    private func setConstraints() {
        TFView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(100)
        }
    }
}

//
//  EmailSignupView.swift
//  Sukbakji
//
//  Created by 오현민 on 3/13/25.
//

import UIKit

class EmailSignupView: UIView {
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
    
    //MARK: - Components
    private lazy var TFView = makeStack(axis: .vertical, spacing: 20)

    public var emailTF = CommonTextFieldView().then {
        $0.setTitle("이메일")
        $0.setPlaceholder("올바른 형식의 이메일을 입력해 주세요")
        $0.textField.keyboardType = .emailAddress
    }
    
    public var passwordTF = CommonTextFieldView().then {
        $0.setTitle("비밀번호")
        $0.setPlaceholder("비밀번호를 6자리 이상 입력해 주세요")
        $0.setPasswordTF()
    }
    
    public var passwordCheckTF = CommonTextFieldView().then {
        $0.setTitle("비밀번호 확인")
        $0.setPlaceholder("비밀번호를 한 번 더 입력해 주세요")
        $0.setPasswordTF()
    }
    
    public var nextButton = OrangeButton(title: "다음으로")
    
    //MARK: - SetUI
    private func setView() {
        TFView.addArrangedSubViews([emailTF, passwordTF, passwordCheckTF])
        addSubviews([TFView, nextButton])
    }
    
    private func setConstraints() {
        TFView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(TFView.snp.bottom).offset(54)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}

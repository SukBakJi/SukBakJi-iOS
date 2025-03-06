//
//  EmailView.swift
//  Sukbakji
//
//  Created by 오현민 on 3/5/25.
//

import UIKit

class EmailView: UIView {

    //MARK: - Properties
 
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setView()
        setConstraints()
        loginButton.setButtonState(isEnabled: true,
                                   enabledColor: .orange700,
                                   disabledColor: .gray200,
                                   enabledTitleColor: .white,
                                   disabledTitleColor: .gray500)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Functional
    private func makeStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
            let stack = UIStackView()
            stack.axis = axis
            stack.spacing = spacing
            stack.distribution = .fill
            return stack
        }
    
    @objc func autoLoginButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    
    //MARK: - Components
    private lazy var TFView = makeStack(axis: .vertical, spacing: 8)
    
    private lazy var emailTF = CommonTextFieldView().then {
        $0.setTitle("이메일")
        $0.setPlaceholder("이메일을 입력해 주세요")
        $0.validation(textField: $0,
                   regex: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$",
                   errorMessage: "올바르지 않은 형식의 이메일 입니다",
                   emptyErrorMessage: "이메일을 입력해 주세요")
    }
    
    private lazy var passwordTF = CommonTextFieldView().then {
        $0.setTitle("비밀번호")
        $0.setPlaceholder("비밀번호를 입력해 주세요")
        $0.setPasswordTF()
        $0.validation(textField: $0,
                   regex: "^.{6,}$",
                   errorMessage: "비밀번호를 입력해 주세요",
                   emptyErrorMessage: "비밀번호를 입력해 주세요")
       
    }
    
    private lazy var autoLoginView = makeStack(axis: .horizontal, spacing: 8)
    private lazy var autoLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_state=off"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_state=on"), for: .selected)
        $0.addTarget(self, action: #selector(autoLoginButtonTapped), for: .touchUpInside)
    }
    private lazy var autoLoginLabel = UILabel().then {
        $0.text = "자동 로그인"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textAlignment = .left
        $0.textColor = .gray600
    }
    
    private lazy var loginButton = OrangeButton(title: "로그인")

    private lazy var authView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 0
    }
    private lazy var verticalLine = UIView().then {
        $0.backgroundColor = .gray500
        $0.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 0.5, height: 14))
        }
    }
    public var findEmailButton = smallTextButton(title: "이메일 찾기")
    public var resetPWButton = smallTextButton(title: "비밀번호 재설정")
    
    private lazy var signUpView = makeStack(axis: .horizontal, spacing: 0)
    private lazy var signUpLabel = UILabel().then {
        $0.text = "아직 석박지 계정이 없다면?"
        $0.textAlignment = .center
        $0.textColor = .gray500
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
    }
    public var signUpButton = smallTextButton(title: "회원가입")

    //MARK: - SetUI
    private func setView() {
        addSubviews([TFView, autoLoginView, loginButton, authView, signUpView])
        
        TFView.addArrangedSubViews([emailTF, passwordTF])
        autoLoginView.addArrangedSubViews([autoLoginButton, autoLoginLabel])
        authView.addArrangedSubViews([findEmailButton, verticalLine, resetPWButton])
        signUpView.addArrangedSubViews([signUpLabel, signUpButton])
    }
    
    private func setConstraints() {
        TFView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        autoLoginView.snp.makeConstraints {
            $0.top.equalTo(TFView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(autoLoginView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        authView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginButton.snp.bottom).offset(20)
            $0.height.equalTo(30)
        }
        
        signUpView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(authView.snp.bottom).offset(16)
        }
    }
}

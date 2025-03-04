//
//  LoginView.swift
//  Sukbakji
//
//  Created by 오현민 on 3/4/25.
//

import UIKit

class LoginView: UIView {

    private lazy var symbolImageView = UIImageView().then {
        $0.image = UIImage(named: "SBJ_symbol")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var titleLabel = UILabel().then {
        let fullText = "로그인 한 번으로\n대학원 생활 시작하기"
        let attributedString = NSMutableAttributedString(string: fullText)
        let rangeText = (fullText as NSString).range(of: "로그인")
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.orange700,
                                      range: rangeText)
        // 자간 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSMakeRange(0,attributedString.length))
        
        $0.attributedText = attributedString
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Bold", size: 26)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var signUpLabel = UILabel().then {
        $0.text = "아직 석박지 계정이 없다면?"
        $0.textAlignment = .center
        $0.textColor = .gray500
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var signUpStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public var kakaoButton = SocialAuthButton(type: .kakao, title: "카카오로 로그인")
    public var appleButton = SocialAuthButton(type: .apple, title: "Apple로 로그인")
    public var emailButton = SocialAuthButton(type: .email, title: "이메일로 로그인")
    
    public var signUpButton = smallTextButton(title: "회원가입")
    public var findAccountButton = smallTextButton(title: "계정찾기")
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 뷰 설정
    private func setView() {
        buttonStackView.addArrangedSubViews([kakaoButton, appleButton, emailButton])
        signUpStackView.addArrangedSubViews([signUpLabel, signUpButton])
        self.addSubviews([symbolImageView, titleLabel, buttonStackView, signUpStackView, findAccountButton])
    }
    
    //MARK: - 레이아웃 설정
    private func setConstraints() {
        symbolImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(safeAreaLayoutGuide).offset(40)
            $0.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(symbolImageView.snp.bottom).offset(12)
            $0.height.equalTo(80)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(titleLabel.snp.bottom).offset(215)
        }
        
        kakaoButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        appleButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        emailButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        findAccountButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(buttonStackView.snp.bottom).offset(32)
        }
        
        signUpStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(211)
            $0.top.equalTo(findAccountButton.snp.bottom).offset(16)
        }
    }
}

//
//  SignupView.swift
//  Sukbakji
//
//  Created by 오현민 on 3/13/25.
//

import UIKit

class SignupView: UIView {
    //MARK: - Properties
    
    //MARK: - Components
    private lazy var symbolImageView = UIImageView().then {
        $0.image = UIImage(named: "SBJ_symbol")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleLabel = UILabel().then {
        let fullText = "로그인 한 번으로\n대학원 생활 시작하기"
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let rangeText = (fullText as NSString).range(of: "로그인")
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.orange700,
                                      range: rangeText)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSMakeRange(0, attributedString.length))
        
        $0.attributedText = attributedString
        $0.textAlignment = .center
        $0.font = .title1()
        $0.numberOfLines = 0
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 8
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public var kakaoButton = SocialAuthButton(type: .kakao, title: "카카오톡으로 회원가입")
    public var appleButton = SocialAuthButton(type: .apple, title: "Apple로 회원가입")
    public var emailButton = SocialAuthButton(type: .email, title: "이메일로 회원가입")
    public var findAccountButton = smallTextButton(title: "이메일 찾기")
    
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
    
    //MARK: - SetUI
    private func setView() {
        buttonStackView.addArrangedSubViews([kakaoButton, appleButton, emailButton])
        self.addSubviews([symbolImageView, titleLabel, buttonStackView, findAccountButton])
    }
    
    private func setConstraints() {
        symbolImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(120)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(symbolImageView.snp.bottom).offset(12)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(titleLabel.snp.bottom).offset(135)
        }
        
        findAccountButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(buttonStackView.snp.bottom).offset(24)
        }
    }
}

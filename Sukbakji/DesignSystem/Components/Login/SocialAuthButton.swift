//
//  SocialAuthButton.swift
//  Sukbakji
//
//  Created by 오현민 on 3/4/25.
//

import UIKit

class SocialAuthButton: UIButton {
    enum ButtonType {
        case kakao
        case apple
        case email
    }
    
    init(type: ButtonType, title: String) {
        super.init(frame: .zero)
        configure(type: type, title: title)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(type: ButtonType, title: String) {
        self.snp.makeConstraints {
            $0.height.equalTo(54)
        }
        
        var loginTitleContainer = AttributeContainer()
        loginTitleContainer.font = .body1()
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(title, attributes: loginTitleContainer)
        config.titleAlignment = .center
        config.cornerStyle = .medium
        
        let leftImageView: UIImageView
        
        switch type {
        case .kakao:
            leftImageView = UIImageView(image: UIImage(named: "SBJ_Kakao"))
            config.baseBackgroundColor = .kakao
            config.baseForegroundColor = .gray900
            self.layer.borderColor = UIColor.kakaoBorder.cgColor
            
        case .apple:
            leftImageView = UIImageView(image: UIImage(named: "SBJ_Apple"))
            config.baseBackgroundColor = .black
            config.baseForegroundColor = .white
            self.layer.borderColor = UIColor.black.cgColor
        case .email:
            leftImageView = UIImageView(image: UIImage(named: "SBJ_Mail"))
            config.baseBackgroundColor = .white
            config.baseForegroundColor = .gray900
            self.layer.borderColor = UIColor.gray300.cgColor
        }
        
        self.addSubview(leftImageView)
        leftImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(16)
        }
        self.configuration = config
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.25
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

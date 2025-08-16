//
//  CompleteView.swift
//  Sukbakji
//
//  Created by 오현민 on 3/13/25.
//

import UIKit

class CompleteView: UIView {
    //MARK: - Properties
    
    //MARK: - Components
    private lazy var RocketImage = UIImageView().then {
        $0.image = UIImage(named: "SBJ_Rocket")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleLabel = UILabel().then {
        let fullText = "석박지의 새로운 회원이\n되신 걸 환영합니다!"
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let rangeText = (fullText as NSString).range(of: "석박지")
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
    
    public lazy var nextButton = OrangeButton(title: "석박지 시작하기")
    
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
        addSubviews([RocketImage, titleLabel, nextButton])
    }
    
    private func setConstraints() {
        RocketImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(180)
            $0.height.width.equalTo(170)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(RocketImage.snp.bottom).offset(48)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}

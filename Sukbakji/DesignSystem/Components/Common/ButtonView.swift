//
//  ButtonView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/29/25.
//

import UIKit
import Then
import SnapKit

class ButtonView: UIView {
    
    var enrollButton = UIButton().then {
        $0.tintColor = .clear
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.setTitle("게시물 등록하기", for: .normal)
        $0.setTitleColor(.gray500, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.gray200, for: .normal)
    }
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        backgroundColor = .white
        
        addSubview(enrollButton)
        enrollButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        
        shadow()
    }
    
    func shadow() {
        self.layer.shadowColor = UIColor.shadow.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
    }
}


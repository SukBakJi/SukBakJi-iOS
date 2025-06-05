//
//  CommentEditView.swift
//  Sukbakji
//
//  Created by jaegu park on 6/4/25.
//

import UIKit
import Then
import SnapKit

class CommentEditView: UIView {
    
    var editLabel = UILabel().then {
        $0.text = "댓글 수정 중"
        $0.textColor = .orange700
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    let inputTextView = UITextView().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
        $0.configurePlaceholder("", insets: UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16))
    }
    var editButton = UIButton().then {
        $0.tintColor = .clear
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(.orange600, for: .normal)
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
        
        addSubview(editLabel)
        editLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(17)
        }
        
        addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.top.equalTo(editLabel.snp.bottom).offset(44)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
            $0.width.equalTo(70)
        }
        
        addSubview(inputTextView)
        inputTextView.snp.makeConstraints {
            $0.top.equalTo(editLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(editButton.snp.leading).inset(-6)
            $0.height.equalTo(77)
        }
        inputTextView.addTFUnderline()
        inputTextView.errorfix()
        
        shadow()
    }
    
    func shadow() {
        self.layer.shadowColor = UIColor.shadow.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
    }
}


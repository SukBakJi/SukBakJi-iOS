//
//  MessageInputView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/3/25.
//

import UIKit
import Then
import SnapKit

final class MessageInputView: UIView {
    
    var inputTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "상대방과 대화를 나눠 보세요!"
        $0.setPlaceholderColor(UIColor(hexCode: "9F9F9F"))
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .black
    }
    var sendButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.setBackgroundColor(.gray500, for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_Send"), for: .normal)
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
        
        addSubview(sendButton)
        sendButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(44)
        }
        
        addSubview(inputTextField)
        inputTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(sendButton.snp.leading).inset(6)
            $0.height.equalTo(44)
        }
        inputTextField.addTFUnderline()
        inputTextField.setLeftPadding(15)
        inputTextField.errorfix()
        
        shadow()
    }
    
    func shadow() {
        self.layer.shadowColor = UIColor.shadow.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
    }
}

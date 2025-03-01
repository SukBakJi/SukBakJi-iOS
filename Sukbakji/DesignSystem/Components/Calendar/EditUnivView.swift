//
//  EditUnivView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/22/25.
//

import UIKit
import SnapKit
import Then

class EditUnivView: UIView {

    let univLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 22)
        $0.textColor = .gray900
    }
    let recruitDateLabel = UILabel().then {
        $0.text = "모집시기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.textColor = .gray900
    }
    let recruitFirstButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
    }
    let recruitFirstLabel = UILabel().then {
        $0.text = "2025년 전기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let recruitSecondButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
    }
    let recruitSecondLabel = UILabel().then {
        $0.text = "2025년 후기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let recruitTypeLabel = UILabel().then {
        $0.text = "모집전형"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.textColor = .gray900
    }
    let recruitTypeTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let dropButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Down2"), for: .normal)
    }
    let editButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitleColor(.gray500, for: .disabled)
        $0.setTitle("저장하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.gray200, for: .normal)
        $0.setBackgroundColor(.gray200, for: .disabled)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(univLabel)
        addSubview(recruitDateLabel)
        addSubview(recruitFirstButton)
        addSubview(recruitFirstLabel)
        addSubview(recruitSecondButton)
        addSubview(recruitSecondLabel)
        addSubview(recruitTypeLabel)
        addSubview(recruitTypeTextField)
        addSubview(dropButton)
        addSubview(editButton)
    }
    
    private func setupConstraints() {
        univLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(28)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        recruitDateLabel.snp.makeConstraints {
            $0.top.equalTo(univLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(28)
            $0.height.equalTo(24)
        }
        recruitDateLabel.addImageAboveLabel(referenceView: univLabel, spacing: 32)
        
        recruitFirstButton.snp.makeConstraints {
            $0.top.equalTo(recruitDateLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(22)
            $0.height.width.equalTo(24)
        }
        
        recruitFirstLabel.snp.makeConstraints {
            $0.centerY.equalTo(recruitFirstButton)
            $0.leading.equalTo(recruitFirstButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        recruitSecondButton.snp.makeConstraints {
            $0.centerY.equalTo(recruitFirstButton)
            $0.leading.equalTo(recruitFirstLabel.snp.trailing).offset(18)
            $0.height.width.equalTo(24)
        }
        
        recruitSecondLabel.snp.makeConstraints {
            $0.centerY.equalTo(recruitFirstButton)
            $0.leading.equalTo(recruitSecondButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        recruitTypeLabel.snp.makeConstraints {
            $0.top.equalTo(recruitFirstButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(28)
            $0.height.equalTo(24)
        }
        recruitTypeLabel.addImageAboveLabel(referenceView: recruitFirstButton, spacing: 30)
        
        recruitTypeTextField.snp.makeConstraints {
            $0.top.equalTo(recruitTypeLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        recruitTypeTextField.errorfix()
        recruitTypeTextField.addTFUnderline()
        recruitTypeTextField.setLeftPadding(15)
        recruitTypeTextField.isEnabled = false
        
        dropButton.snp.makeConstraints {
            $0.centerY.equalTo(recruitTypeTextField)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(36)
        }
        
        editButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(112)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        editButton.isEnabled = false
    }
}

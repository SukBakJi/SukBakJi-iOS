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
    let recruitDateView = UIView().then {
        $0.backgroundColor = .clear
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
    let recruitTypeView = UIView().then {
        $0.backgroundColor = .clear
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
        
        addSubview(recruitDateView)
        recruitDateView.addSubview(recruitDateLabel)
        recruitDateView.addSubview(recruitFirstButton)
        recruitDateView.addSubview(recruitFirstLabel)
        recruitDateView.addSubview(recruitSecondButton)
        recruitDateView.addSubview(recruitSecondLabel)
        
        addSubview(recruitTypeView)
        recruitTypeView.addSubview(recruitTypeLabel)
        recruitTypeView.addSubview(recruitTypeTextField)
        recruitTypeView.addSubview(dropButton)
        
        addSubview(editButton)
    }
    
    private func setupConstraints() {
        univLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(58)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        recruitDateView.snp.makeConstraints {
            $0.top.equalTo(univLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(88)
        }
        
        recruitDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(28)
            $0.height.equalTo(24)
        }
        recruitDateLabel.addImageAboveLabel(referenceView: univLabel, spacing: 24)
        
        recruitFirstButton.snp.makeConstraints {
            $0.top.equalTo(recruitDateLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(22)
            $0.height.width.equalTo(24)
        }
        recruitFirstButton.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
        
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
        recruitSecondButton.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
        
        recruitSecondLabel.snp.makeConstraints {
            $0.centerY.equalTo(recruitFirstButton)
            $0.leading.equalTo(recruitSecondButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        recruitTypeView.snp.makeConstraints {
            $0.top.equalTo(recruitDateView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        recruitTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(28)
            $0.height.equalTo(24)
        }
        recruitTypeLabel.addImageAboveLabel(referenceView: recruitDateView, spacing: 20)
        
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
            $0.top.equalTo(recruitTypeView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        editButton.isEnabled = false
    }
    
    @objc func firstButtonTapped() {
        recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
        recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
                
        recruitFirstButton.isEnabled = false
        recruitSecondButton.isEnabled = true
    }
    
    @objc func secondButtonTapped() {
        recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
                
        recruitFirstButton.isEnabled = true
        recruitSecondButton.isEnabled = false
    }
}

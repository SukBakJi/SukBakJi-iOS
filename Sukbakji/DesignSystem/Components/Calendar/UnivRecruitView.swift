//
//  UnivRecruitView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/22/25.
//

import UIKit
import SnapKit
import Then

class UnivRecruitView: UIView {
    
    let titleView = UIView()
    let backButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Back"), for: .normal)
    }
    let titleLabel = UILabel().then {
        $0.text = "대학교 선택"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.textColor = .gray900
    }
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let dateSelectView = UIView().then {
        $0.backgroundColor = .clear
    }
    let dateSelectLabel = UILabel().then {
        $0.text = "성신여자대학교 일정을 선택해 주세요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let recruitSelectLabel = UILabel().then {
        $0.text = "해당 학교의 모집 전형을 선택해 주세요"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray500
    }
    let stepImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Progress2")
    }
    let recruitView = UIView().then {
        $0.backgroundColor = UIColor.gray50
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    let recruitImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_RecruitType")
    }
    let recruitTitleLabel = UILabel().then {
        $0.text = "2025년 전기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    var recruitLabel = UILabel().then {
        $0.text = "  모집전형을 선택해 주세요"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.textColor = .gray500
    }
    let recruitDateView = UIView().then {
        $0.backgroundColor = .clear
    }
    let recruitDateLabel = UILabel().then {
        $0.text = "모집시기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let recruitFirstButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
        $0.isEnabled = false
    }
    let recruitFirstLabel = UILabel().then {
        $0.text = "2025년 전기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let recruitSecondButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
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
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let recruitTypeTextField = UITextField().then {
        $0.backgroundColor = .gray100
        $0.placeholder = "모집전형을 선택해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .black
    }
    let dropButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Down2"), for: .normal)
    }
    let warningImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningTypeLabel = UILabel().then {
        $0.text = "모집전형은 필수 입력입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    let nextButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitleColor(.gray500, for: .disabled)
        $0.setTitle("다음으로", for: .normal)
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
        
        addSubview(titleView)
        titleView.addSubview(backButton)
        titleView.addSubview(titleLabel)
        addSubview(backgroundLabel)
        
        addSubview(dateSelectView)
        dateSelectView.addSubview(dateSelectLabel)
        dateSelectView.addSubview(recruitSelectLabel)
        dateSelectView.addSubview(stepImageView)
        
        addSubview(recruitView)
        recruitView.addSubview(recruitImageView)
        recruitView.addSubview(recruitTitleLabel)
        recruitView.addSubview(recruitLabel)
        
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
        recruitTypeView.addSubview(warningImageView)
        recruitTypeView.addSubview(warningTypeLabel)
        
        addSubview(nextButton)
    }
    
    private func setupConstraints() {
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        dateSelectView.snp.makeConstraints {
            $0.top.equalTo(backgroundLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(130)
        }
        
        dateSelectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        recruitSelectLabel.snp.makeConstraints {
            $0.top.equalTo(dateSelectLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(17)
        }
        
        stepImageView.snp.makeConstraints {
            $0.top.equalTo(recruitSelectLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(20)
        }
        
        recruitView.snp.makeConstraints {
            $0.top.equalTo(stepImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
        
        recruitImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.height.width.equalTo(20)
        }
        
        recruitTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(recruitImageView.snp.trailing).offset(8)
            $0.height.equalTo(19)
        }
        
        recruitLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(recruitTitleLabel.snp.trailing)
            $0.height.equalTo(19)
        }
        
        recruitDateView.snp.makeConstraints {
            $0.top.equalTo(recruitView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(85)
        }
        
        recruitDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        recruitDateLabel.addImageAboveLabel(referenceView: recruitView, spacing: 20)
        
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
        
        recruitDateView.snp.makeConstraints {
            $0.top.equalTo(recruitDateView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(115)
        }
        
        recruitTypeLabel.snp.makeConstraints {
            $0.top.equalTo(recruitFirstButton.snp.bottom).offset(29.5)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        recruitTypeLabel.addImageAboveLabel(referenceView: recruitDateView, spacing: 29.5)
        
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
        
        warningImageView.snp.makeConstraints {
            $0.top.equalTo(recruitTypeTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(28)
            $0.height.width.equalTo(12)
        }
        warningImageView.isHidden = true
        
        warningTypeLabel.snp.makeConstraints {
            $0.centerY.equalTo(warningImageView)
            $0.leading.equalTo(warningImageView.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningTypeLabel.isHidden = true
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        nextButton.isEnabled = false
    }
    
    @objc func firstButtonTapped() {
        recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
        recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        
        recruitFirstButton.isEnabled = false
        recruitSecondButton.isEnabled = true
        recruitTitleLabel.text = "2025년 전기"
    }
    
    @objc func secondButtonTapped() {
        recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
        
        recruitFirstButton.isEnabled = true
        recruitSecondButton.isEnabled = false
        recruitTitleLabel.text = "2025년 후기"
    }
}

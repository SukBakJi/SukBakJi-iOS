//
//  LabInquiryView.swift
//  Sukbakji
//
//  Created by jaegu park on 7/4/25.
//

import UIKit
import SnapKit
import Then

class LabInquiryView: UIView {
    
    var navigationbarView = NavigationBarView(title: "수정 문의")
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let titleView = UIView().then {
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then {
        $0.text = "연구실 정보에 대한 수정 내용을\n입력해 주세요"
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let categoryView = UIView().then {
        $0.backgroundColor = .white
    }
    let categoryLabel = UILabel().then {
        $0.text = "카테고리 선택"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let categoryFirstButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
        $0.isEnabled = false
    }
    let categoryFirstLabel = UILabel().then {
        $0.text = "교수 정보"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let categorySecondButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
    }
    let categorySecondLabel = UILabel().then {
        $0.text = "연구실 정보"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let categoryThirdButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
    }
    let categoryThirdLabel = UILabel().then {
        $0.text = "연구주제"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    let contentLabel = UILabel().then {
        $0.text = "내용"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let contentTextView = UITextView().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
        $0.configurePlaceholder("내용을 입력해주세요", insets: UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16))
    }
    let inquiryButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitleColor(.gray500, for: .disabled)
        $0.setTitle("제출하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.gray200, for: .normal)
        $0.setBackgroundColor(.gray200, for: .disabled)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        addSubview(navigationbarView)
        addSubview(backgroundLabel)
        
        addSubview(titleView)
        titleView.addSubview(titleLabel)
        
        addSubview(categoryView)
        categoryView.addSubview(categoryLabel)
        categoryView.addSubview(categoryFirstButton)
        categoryView.addSubview(categoryFirstLabel)
        categoryView.addSubview(categorySecondButton)
        categoryView.addSubview(categorySecondLabel)
        categoryView.addSubview(categoryThirdButton)
        categoryView.addSubview(categoryThirdLabel)
        
        addSubview(contentView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(contentTextView)
        
        addSubview(inquiryButton)
    }
    
    private func setConstraints() {
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(backgroundLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(88)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(52)
        }
        let fullText = titleLabel.text ?? ""
        let changeText = "연구실 정보에 대한 수정 내용"
        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        titleLabel.attributedText = attributedString
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(73)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        categoryLabel.addImageAboveLabel(referenceView: titleView, spacing: 20)
        
        categoryFirstButton.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(22)
            $0.height.width.equalTo(24)
        }
        
        categoryFirstLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryFirstButton)
            $0.leading.equalTo(categoryFirstButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        categorySecondButton.snp.makeConstraints {
            $0.centerY.equalTo(categoryFirstButton)
            $0.leading.equalTo(categoryFirstLabel.snp.trailing).offset(18)
            $0.height.width.equalTo(24)
        }
        
        categorySecondLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryFirstButton)
            $0.leading.equalTo(categorySecondButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        categoryThirdButton.snp.makeConstraints {
            $0.centerY.equalTo(categoryFirstButton)
            $0.leading.equalTo(categorySecondLabel.snp.trailing).offset(18)
            $0.height.width.equalTo(24)
        }
        
        categoryThirdLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryFirstButton)
            $0.leading.equalTo(categoryThirdButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(175)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        contentLabel.addImageAboveLabel(referenceView: categoryView, spacing: 20)
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(120)
        }
        contentTextView.errorfix()
        contentTextView.addTFUnderline()
        
        inquiryButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
}

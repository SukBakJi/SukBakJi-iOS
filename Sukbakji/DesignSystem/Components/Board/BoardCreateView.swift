//
//  BoardCreateView.swift
//  Sukbakji
//
//  Created by jaegu park on 6/3/25.
//

import UIKit
import Then
import SnapKit

class BoardCreateView: UIView {
    
    let titleLabel = UILabel().then {
        $0.text = "게시판 만들기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 22)
        $0.textColor = .gray900
    }
    let nameView = UIView().then {
        $0.backgroundColor = .white
    }
    let nameLabel = UILabel().then {
        $0.text = "게시판 이름"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let nameTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "게시판 이름을 입력해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Delete"), for: .normal)
    }
    let warningNameImage = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningNameLabel = UILabel().then {
        $0.text = "게시판 이름은 필수 입력입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    let noticeView = UIView().then {
        $0.backgroundColor = .white
    }
    let noticeLabel = UILabel().then {
        $0.text = "게시판 공지"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let noticeTextView = UITextView().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
        $0.configurePlaceholder("게시판 공지와 규칙 등을 자유롭게 적어주세요 (50자 이내)", insets: UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16))
    }
    let warningNoticeImage = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningNoticeLabel = UILabel().then {
        $0.text = "게시판 공지는 필수 입력입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    let makeBoardButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitleColor(.gray500, for: .disabled)
        $0.setTitle("알람 설정하기", for: .normal)
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
        
        addSubview(titleLabel)
        
        addSubview(nameView)
        nameView.addSubview(nameLabel)
        nameView.addSubview(nameTextField)
        nameView.addSubview(deleteButton)
        nameView.addSubview(warningNameImage)
        nameView.addSubview(warningNameLabel)
        
        addSubview(noticeView)
        noticeView.addSubview(noticeLabel)
        noticeView.addSubview(noticeTextView)
        noticeView.addSubview(warningNoticeImage)
        noticeView.addSubview(warningNoticeLabel)
        
        addSubview(makeBoardButton)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(58)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        nameView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(28)
            $0.height.equalTo(24)
        }
        nameLabel.addImageAboveLabel(referenceView: titleLabel, spacing: 32)
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        nameTextField.errorfix()
        nameTextField.addTFUnderline()
        nameTextField.setLeftPadding(16)
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(nameTextField)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(36)
        }
        
        warningNameImage.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(28)
            $0.height.width.equalTo(12)
        }
        warningNameImage.isHidden = true
        
        warningNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(warningNameImage)
            $0.leading.equalTo(warningNameImage.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningNameLabel.isHidden = true
        
        noticeView.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        noticeLabel.addImageAboveLabel(referenceView: nameView, spacing: 20)
        
        noticeTextView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(120)
        }
        noticeTextView.errorfix()
        noticeTextView.addTFUnderline()
        
        warningNoticeImage.snp.makeConstraints {
            $0.top.equalTo(noticeTextView.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(28)
            $0.height.width.equalTo(12)
        }
        warningNoticeImage.isHidden = true
        
        warningNoticeLabel.snp.makeConstraints {
            $0.centerY.equalTo(warningNoticeImage)
            $0.leading.equalTo(warningNoticeImage.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningNoticeLabel.isHidden = true
        
        makeBoardButton.snp.makeConstraints {
            $0.top.equalTo(noticeView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
}

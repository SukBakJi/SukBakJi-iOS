//
//  EdifInfoView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/20/25.
//

import UIKit
import SnapKit
import Then

class EdifInfoView: UIView {
    
    let idView = UIView().then {
        $0.backgroundColor = .white
    }
    let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let idTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray300
        $0.isEnabled = false
    }
    let logingImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Email")
    }
    let logingLabel = UILabel().then {
        $0.text = "이메일 로그인으로 사용 중이에요"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .gray900
    }
    let nameView = UIView().then {
        $0.backgroundColor = .white
    }
    let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let nameTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray300
        $0.isEnabled = false
    }
    let belongView = UIView().then {
        $0.backgroundColor = .white
    }
    let belongLabel = UILabel().then {
        $0.text = "현재 소속"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let belongTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let dropButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Down2"), for: .normal)
    }
    let certificateView = UIView().then {
        $0.backgroundColor = .gray50
    }
    let certificateLabel = UILabel().then {
        $0.text = "현재 학사 재학으로 학력인증이\n완료된 상태입니다"
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray600
    }
    let certificateButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("새로 인증하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(.orange700, for: .normal)
    }
    let researchView = UIView().then {
        $0.backgroundColor = .white
    }
    let researchLabel = UILabel().then {
        $0.text = "연구 주제"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    var researchTopicCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 14
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ResearchTopicCollectionViewCell.self, forCellWithReuseIdentifier: ResearchTopicCollectionViewCell.identifier)
        cv.allowsSelection = false
        cv.backgroundColor = .clear
        
        return cv
    }()
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray300
    }
    let plusButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_plusButton"), for: .normal)
    }
    let editButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("수정하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.orange700, for: .normal)
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
        
        addSubview(idView)
        idView.addSubview(idLabel)
        idView.addSubview(idTextField)
        idView.addSubview(logingImageView)
        idView.addSubview(logingLabel)
        
        addSubview(nameView)
        nameView.addSubview(nameLabel)
        nameView.addSubview(nameTextField)
        
        addSubview(belongView)
        belongView.addSubview(belongLabel)
        belongView.addSubview(belongTextField)
        belongView.addSubview(dropButton)
        
        addSubview(certificateView)
        certificateView.addSubview(certificateLabel)
        certificateView.addSubview(certificateButton)
        
        addSubview(researchView)
        researchView.addSubview(researchLabel)
        researchView.addSubview(plusButton)
        researchView.addSubview(researchTopicCollectionView)
        researchView.addSubview(backgroundLabel)
        
        addSubview(editButton)
    }
    
    private func setupConstraints() {
        idView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(46)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(119)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        idTextField.addTFUnderline()
        idTextField.setLeftPadding(15)
        
        logingImageView.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(24)
            $0.height.width.equalTo(16)
        }
        
        logingLabel.snp.makeConstraints {
            $0.centerY.equalTo(logingImageView)
            $0.leading.equalTo(logingImageView.snp.trailing).offset(6)
            $0.height.equalTo(12)
        }
        
        nameView.snp.makeConstraints {
            $0.top.equalTo(idView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(99)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        nameTextField.addTFUnderline()
        nameTextField.setLeftPadding(15)
        
        belongView.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(117)
        }
        
        belongLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        belongLabel.addImageAboveLabel(referenceView: nameView, spacing: 20)
        
        belongTextField.snp.makeConstraints {
            $0.top.equalTo(belongLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        belongTextField.addTFUnderline()
        belongTextField.setLeftPadding(15)
        belongTextField.isEnabled = false
        
        dropButton.snp.makeConstraints {
            $0.top.equalTo(belongLabel.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(44)
        }
        
        certificateView.snp.makeConstraints {
            $0.top.equalTo(belongView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(84)
        }
        
        certificateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        certificateButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(48)
            $0.width.equalTo(120)
        }
        
        researchView.snp.makeConstraints {
            $0.top.equalTo(certificateView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(157)
        }
        
        researchLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        researchLabel.addImageAboveLabel(referenceView: certificateView, spacing: 20)
        
        plusButton.snp.makeConstraints {
            $0.top.equalTo(researchLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(22)
            $0.height.width.equalTo(44)
        }
        
        researchTopicCollectionView.snp.makeConstraints {
            $0.top.equalTo(researchLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(plusButton.snp.leading).inset(8)
            $0.height.equalTo(29)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.top.equalTo(researchTopicCollectionView.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(1.2)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(researchView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
}

//
//  MyPageView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/20/25.
//

import UIKit
import SnapKit
import Then

class MyPageView: UIView {
    
    let navigationbarView = NavigationBarView(title: "마이페이지")
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let myInfoView = UIView().then {
        $0.backgroundColor = .white
    }
    let myInfoLabel = UILabel().then {
        $0.text = "내 정보"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let myInfoImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Myinfo")
    }
    let myInfoEditButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_More"), for: .normal)
        $0.setTitle("수정하기 ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setTitleColor(.gray500, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    let nameLabel = UILabel().then {
        $0.text = "석박지"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let degreeLabel = UILabel().then {
        $0.text = "학위 정보 없음"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.textColor = .gray900
    }
    let certificateView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = false
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    let certificateImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Pick")
    }
    let certificateLabel = UILabel().then {
        $0.text = "현재 학적 인증이 완료된 상태입니다"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let warningImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningLabel = UILabel().then {
        $0.text = "학적 인증 후에 앱 기능 사용이 가능합니다."
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .orange700
    }
    let inquiryButton = UIButton().then {
        $0.setTitle("문의하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.gray500, for: .normal)
    }
    let logOutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.gray500, for: .normal)
    }
    let resignButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.gray500, for: .normal)
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
        
        addSubview(myInfoView)
        myInfoView.addSubview(myInfoLabel)
        myInfoView.addSubview(myInfoImageView)
        myInfoView.addSubview(myInfoEditButton)
        myInfoView.addSubview(nameLabel)
        myInfoView.addSubview(degreeLabel)
        myInfoView.addSubview(certificateView)
        certificateView.addSubview(certificateImageView)
        certificateView.addSubview(certificateLabel)
        myInfoView.addSubview(warningImageView)
        myInfoView.addSubview(warningLabel)
        
        addSubview(resignButton)
        addSubview(logOutButton)
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
        
        myInfoView.snp.makeConstraints {
            $0.top.equalTo(backgroundLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        myInfoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        myInfoImageView.snp.makeConstraints {
            $0.centerY.equalTo(myInfoLabel)
            $0.leading.equalTo(myInfoLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(20)
        }
        
        myInfoEditButton.snp.makeConstraints {
            $0.centerY.equalTo(myInfoLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(21)
            $0.width.equalTo(64)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(myInfoLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        degreeLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
            $0.height.equalTo(19)
        }
        
        certificateView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(54)
        }
        
        certificateImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(20)
        }
        
        certificateLabel.snp.makeConstraints {
            $0.centerY.equalTo(certificateImageView)
            $0.leading.equalTo(certificateImageView.snp.trailing).offset(8)
            $0.height.equalTo(19)
        }
        
        warningImageView.snp.makeConstraints {
            $0.top.equalTo(certificateView.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(28)
            $0.width.height.equalTo(12)
        }
        warningImageView.isHidden = true
        
        warningLabel.snp.makeConstraints {
            $0.centerY.equalTo(warningImageView)
            $0.leading.equalTo(warningImageView.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningLabel.isHidden = true
        
        resignButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(80)
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(48)
            $0.width.equalTo(72)
        }
        
        logOutButton.snp.makeConstraints {
            $0.bottom.equalTo(resignButton.snp.top)
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(48)
            $0.width.equalTo(72)
        }
        
        inquiryButton.snp.makeConstraints {
            $0.bottom.equalTo(logOutButton.snp.top)
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(48)
            $0.width.equalTo(72)
        }
    }
}

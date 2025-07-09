//
//  LabInfoView.swift
//  Sukbakji
//
//  Created by jaegu park on 7/1/25.
//

import UIKit
import SnapKit
import Then

class LabInfoView: UIView {
    
    let layerView = UIView().then {
        $0.backgroundColor = .gray300
    }
    let infoView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    let professorImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_LabImage")
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    let scrapButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Bookmark"), for: .normal)
    }
    let nameLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let professorLabel = UILabel().then {
        $0.text = "교수"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.textColor = .gray900
    }
    lazy var professor = UIStackView().then {
        $0.addArrangedSubview(nameLabel)
        $0.addArrangedSubview(professorLabel)
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fill
    }
    let univLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .orange700
    }
    let departmentLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    lazy var univ = UIStackView().then {
        $0.addArrangedSubview(univLabel)
        $0.addArrangedSubview(departmentLabel)
        $0.axis = .horizontal
        $0.spacing = 6
        $0.distribution = .fill
    }
    let professorView = UIView().then {
        $0.backgroundColor = .clear
    }
    let professorInfoLabel = UILabel().then {
        $0.text = "교수 정보"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let professorInfoImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Myinfo")
    }
    let professorInfoView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    let educationLabel = UILabel().then {
        $0.text = "최종학력"
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .gray600
    }
    let educationLabel2 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .gray600
    }
    let emailLabel2 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let copyButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Copy"), for: .normal)
    }
    let labInfoView = UIView().then {
        $0.backgroundColor = .clear
    }
    let labInfoLabel = UILabel().then {
        $0.text = "연구실 정보"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let labInfoImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Info")
    }
    let labPageView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    let labLinkImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Link")
    }
    let pageLabel = UILabel().then {
        $0.text = "홈페이지"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let pageLabel2 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.isUserInteractionEnabled = true
        $0.textColor = .orange700
    }
    let topicView = UIView().then {
        $0.backgroundColor = .clear
    }
    let topicLabel = UILabel().then {
        $0.text = "연구 주제"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let topicImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Research")
    }
    let labTopicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(LabTopicCollectionViewCell.self, forCellWithReuseIdentifier: LabTopicCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        cv.allowsSelection = false
        
        return cv
    }()
    
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
        
        addSubview(layerView)
        
        addSubview(infoView)
        infoView.addSubview(scrapButton)
        infoView.addSubview(professor)
        infoView.addSubview(univ)
        
        addSubview(professorImageView)
        
        addSubview(professorView)
        professorView.addSubview(professorInfoLabel)
        professorView.addSubview(professorInfoImageView)
        professorView.addSubview(professorInfoView)
        
        professorInfoView.addSubview(educationLabel)
        professorInfoView.addSubview(educationLabel2)
        professorInfoView.addSubview(emailLabel)
        professorInfoView.addSubview(emailLabel2)
        professorInfoView.addSubview(copyButton)
        
        addSubview(labInfoView)
        labInfoView.addSubview(labInfoLabel)
        labInfoView.addSubview(labInfoImageView)
        labInfoView.addSubview(labPageView)
        
        labPageView.addSubview(labLinkImageView)
        labPageView.addSubview(pageLabel)
        labPageView.addSubview(pageLabel2)
        
        addSubview(topicView)
        topicView.addSubview(topicLabel)
        topicView.addSubview(topicImageView)
        topicView.addSubview(labTopicCollectionView)
    }
    
    private func setConstraints() {
        layerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(140)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(124)
        }
        
        professorImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(80)
            $0.height.width.equalTo(100)
        }
        
        scrapButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.width.equalTo(20)
        }
        
        professor.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(55)
            $0.height.equalTo(19)
        }
        
        univ.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(professor.snp.bottom).offset(8)
            $0.height.equalTo(17)
        }
        
        professorView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(146)
        }
        
        professorInfoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        professorInfoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28.5)
            $0.leading.equalTo(professorInfoLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(20)
        }
        
        professorInfoView.snp.makeConstraints {
            $0.top.equalTo(professorInfoLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(85)
        }
        
        educationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18.5)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(14)
        }
        
        educationLabel2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalTo(educationLabel.snp.trailing).offset(20)
            $0.height.equalTo(17)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(educationLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(14)
        }
        
        emailLabel2.snp.makeConstraints {
            $0.centerY.equalTo(emailLabel)
            $0.leading.equalTo(emailLabel.snp.trailing).offset(20)
            $0.height.equalTo(17)
        }
        
        copyButton.snp.makeConstraints {
            $0.centerY.equalTo(emailLabel)
            $0.leading.equalTo(emailLabel2.snp.trailing).offset(8)
            $0.height.width.equalTo(16)
        }
        
        labInfoView.snp.makeConstraints {
            $0.top.equalTo(professorView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(115)
        }
        
        labInfoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        labInfoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28.5)
            $0.leading.equalTo(labInfoLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(20)
        }
        
        labPageView.snp.makeConstraints {
            $0.top.equalTo(labInfoLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(54)
        }
        
        labLinkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(20)
        }
        
        pageLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(labLinkImageView.snp.trailing).offset(8)
            $0.height.equalTo(19)
        }
        
        pageLabel2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(pageLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(19)
        }
        
        topicView.snp.makeConstraints {
            $0.top.equalTo(labInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(102)
        }
        
        topicLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        topicImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28.5)
            $0.leading.equalTo(topicLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(20)
        }
        
        labTopicCollectionView.snp.makeConstraints {
            $0.top.equalTo(topicLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(53)
        }
    }
}

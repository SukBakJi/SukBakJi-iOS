//
//  FavoriteLabCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/1/24.
//

import UIKit
import Then
import SnapKit

class FavoriteLabCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: FavoriteLabCollectionViewCell.self)

    private let labView = UIView().then {
        $0.backgroundColor = .white
    }
    private let univLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let labLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    private let professorImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_ProfileImage")
    }
    private let professorNameLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    private let professorLabel = UILabel().then {
        $0.text = "교수"
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let professorLabLabel = UILabel().then {
        $0.text = "교수"
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let labView2 = UIView().then {
        $0.backgroundColor = .orange50
        $0.layer.cornerRadius = 4
    }
    private let labLabel2 = UILabel().then {
        $0.textColor = .orange600
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let labView3 = UIView().then {
        $0.backgroundColor = .orange50
        $0.layer.cornerRadius = 4
    }
    private let labLabel3 = UILabel().then {
        $0.textColor = .orange600
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray100.cgColor
        contentView.clipsToBounds = false
        contentView.backgroundColor = .gray50
        
        layer.cornerRadius = 15
        layer.masksToBounds = false
        
        self.contentView.addSubview(labView)
        labView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
           make.height.equalTo(70)
        }
        
        self.labView.addSubview(univLabel)
        univLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
           make.height.equalTo(14)
        }
        
        self.labView.addSubview(labLabel)
        labLabel.snp.makeConstraints { make in
            make.top.equalTo(univLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(16)
           make.height.equalTo(18)
        }
        
        self.contentView.addSubview(professorImageView)
        professorImageView.snp.makeConstraints { make in
            make.top.equalTo(labView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(40)
        }
        
        self.contentView.addSubview(professorNameLabel)
        professorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(labView.snp.bottom).offset(14.5)
            make.leading.equalTo(professorImageView.snp.trailing).offset(12)
            make.height.equalTo(17)
        }
        
        self.contentView.addSubview(professorLabel)
        professorLabel.snp.makeConstraints { make in
            make.top.equalTo(labView.snp.bottom).offset(16)
            make.leading.equalTo(professorNameLabel.snp.trailing).offset(4)
            make.height.equalTo(14)
        }
        
        self.contentView.addSubview(professorLabLabel)
        professorLabLabel.snp.makeConstraints { make in
            make.top.equalTo(professorNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(professorImageView.snp.trailing).offset(12)
            make.height.equalTo(14)
        }
        
        self.contentView.addSubview(labView2)
        labView2.snp.makeConstraints { make in
            make.top.equalTo(professorImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        
        self.labView2.addSubview(labLabel2)
        labLabel2.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(7)
            make.height.equalTo(26)
        }
        
        self.contentView.addSubview(labView3)
        labView3.snp.makeConstraints { make in
            make.top.equalTo(professorImageView.snp.bottom).offset(12)
            make.leading.equalTo(labView2.snp.trailing).offset(6)
            make.height.equalTo(20)
        }
        
        self.labView3.addSubview(labLabel3)
        labLabel3.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(7)
            make.height.equalTo(26)
        }
    }
    
    func prepare(favoriteLab: FavoriteLab) {
        univLabel.text = favoriteLab.universityName
        labLabel.text = favoriteLab.labName
        professorNameLabel.text = favoriteLab.professorName
        professorLabLabel.text = favoriteLab.departmentName
        labLabel2.text = "#\(favoriteLab.researchTopics[0])"
        if favoriteLab.researchTopics.count == 1 {
            labView3.isHidden = true
        } else {
            labLabel3.text = "#\(favoriteLab.researchTopics[1])"
        }
    }
}

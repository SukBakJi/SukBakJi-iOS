//
//  LabReviewCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 6/13/25.
//

import UIKit
import Then
import SnapKit

class LabReviewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: LabReviewCollectionViewCell.self)
    
    private let univLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let labLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    private let contentLabel = UILabel().then {
        $0.textColor = .gray900
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let labelView = UIView().then {
        $0.backgroundColor = .orange50
        $0.layer.cornerRadius = 4
    }
    private let labelLabel = UILabel().then {
        $0.textColor = .orange600
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let labelView2 = UIView().then {
        $0.backgroundColor = .orange50
        $0.layer.cornerRadius = 4
    }
    private let labelLabel2 = UILabel().then {
        $0.textColor = .orange600
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let labelView3 = UIView().then {
        $0.backgroundColor = .orange50
        $0.layer.cornerRadius = 4
    }
    private let labelLabel3 = UILabel().then {
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
        contentView.backgroundColor = .white
        
        layer.cornerRadius = 15
        layer.masksToBounds = false
        
        contentView.addSubview(univLabel)
        univLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(14)
        }
        
        contentView.addSubview(labLabel)
        labLabel.snp.makeConstraints {
            $0.top.equalTo(univLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(14)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(labLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(44)
        }
        
        contentView.addSubview(labelView)
        labelView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(20)
        }
        
        labelView.addSubview(labelLabel)
        labelLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }
        
        contentView.addSubview(labelView2)
        labelView2.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalTo(labelView.snp.trailing).offset(6)
            $0.height.equalTo(20)
        }
        
        labelView2.addSubview(labelLabel2)
        labelLabel2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }
        
        contentView.addSubview(labelView3)
        labelView3.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalTo(labelView2.snp.trailing).offset(6)
            $0.height.equalTo(20)
        }
        
        labelView3.addSubview(labelLabel3)
        labelLabel3.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }
    }
    
    func prepare(review: LabReview) {
        univLabel.text = String(review.universityName)
        labLabel.text = String(review.departmentName)
        contentLabel.text = String(review.content)
        labelLabel.text = "지도력이 " + String(review.leadershipStyle)
        labelLabel2.text = "인건비가 " + String(review.salaryLevel)
        labelLabel3.text = "자율성이 " + String(review.autonomy)
    }
}

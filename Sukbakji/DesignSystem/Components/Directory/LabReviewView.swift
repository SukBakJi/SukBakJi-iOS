//
//  LabReviewView.swift
//  Sukbakji
//
//  Created by jaegu park on 7/2/25.
//

import UIKit
import SnapKit
import Then

class LabReviewView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
    let titleView = UIView().then {
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then {
        $0.text = "연구실의 후기를 확인해 보세요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let subTitleLabel = UILabel().then {
        $0.text = "키워드 3개로 보는 간단 Check"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray500
    }
    let graphView = UIView().then {
        $0.backgroundColor = .clear
    }
    let graphLabel = UILabel().then {
        $0.text = "간단 Check"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let graphImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Statistic")
    }
    let statisticLabel = UILabel().then {
        $0.text = "자율성이 가장 높게 나타났어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let statisticLabel2 = UILabel().then {
        $0.text = "키워드를 통해 간단하게 볼 수 있어요"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray500
    }
    let statisticImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Graph")
    }
    let reviewView = UIView().then {
        $0.backgroundColor = .clear
    }
    let reviewLabel = UILabel().then {
        $0.text = "연구실 한줄평"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let reviewImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Review")
    }
    let labReviewTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(LabReviewTableViewCell.self, forCellReuseIdentifier: LabReviewTableViewCell.identifier)
        $0.allowsSelection = false
    }
    let moreButton = UIButton().then {
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.setImage(UIImage(named: "Sukbakji_Down2"), for: .normal)
        $0.setTitle("연구실 정보 더보기 ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 11)
        $0.setTitleColor(.gray900, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
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
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(subTitleLabel)
        
        contentView.addSubview(graphView)
        graphView.addSubview(graphLabel)
        graphView.addSubview(graphImageView)
        graphView.addSubview(statisticLabel)
        graphView.addSubview(statisticLabel2)
        graphView.addSubview(statisticImageView)
        
        contentView.addSubview(reviewView)
        reviewView.addSubview(reviewLabel)
        reviewView.addSubview(reviewImageView)
        reviewView.addSubview(labReviewTableView)
        
        contentView.addSubview(moreButton)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(moreButton.snp.bottom).offset(120)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(82)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(17)
        }
        
        graphView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(344)
        }
        
        graphLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        graphImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28.5)
            $0.leading.equalTo(graphLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(20)
        }
        
        statisticLabel.snp.makeConstraints {
            $0.top.equalTo(graphLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        let fullText = statisticLabel.text ?? ""
        let changeText = "자율성"
        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        statisticLabel.attributedText = attributedString
        
        statisticLabel2.snp.makeConstraints {
            $0.top.equalTo(statisticLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(17)
        }
        
        statisticImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(statisticLabel2.snp.bottom).offset(28)
            $0.height.equalTo(177)
            $0.width.equalTo(274)
        }
        
        reviewView.snp.makeConstraints {
            $0.top.equalTo(graphView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        reviewImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28.5)
            $0.leading.equalTo(reviewLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(20)
        }
        
        labReviewTableView.snp.makeConstraints {
            $0.top.equalTo(reviewLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalTo(reviewView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(33)
            $0.width.equalTo(136)
        }
    }
}

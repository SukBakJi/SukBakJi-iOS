//
//  LabReviewView.swift
//  Sukbakji
//
//  Created by jaegu park on 6/14/25.
//

import Foundation
import UIKit
import SnapKit
import Then

class LabReviewView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
    var navigationbarView = NavigationBarView(title: "연구실 후기")
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let titleView = UIView().then {
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then {
        $0.text = "지도교수명을 검색해 주세요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let subTitleLabel = UILabel().then {
        $0.text = "연구실에 대한 정보를 한 눈에 보세요"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray900
    }
    let folderImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Folder")
        $0.alpha = 0.5
    }
    let labSearchTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "지도교수명을 입력해 주세요"
        $0.setPlaceholderColor(.gray300)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
        $0.layer.cornerRadius = 12
    }
    let tapOverlayButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitle("", for: .normal)
    }
    let searchImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_SearchImage")
    }
    let reviewView = UIView().then {
        $0.backgroundColor = .clear
    }
    let reviewLabel = UILabel().then {
        $0.text = "최신 연구실 후기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
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
        $0.setTitle("연구실 후기 더보기 ", for: .normal)
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
        
        addSubview(navigationbarView)
        addSubview(backgroundLabel)
        
        contentView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(subTitleLabel)
        titleView.addSubview(folderImageView)
        titleView.addSubview(labSearchTextField)
        titleView.addSubview(tapOverlayButton)
        titleView.addSubview(searchImageView)
        
        contentView.addSubview(reviewView)
        reviewView.addSubview(reviewLabel)
        reviewView.addSubview(labReviewTableView)
        
        contentView.addSubview(moreButton)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(moreButton.snp.bottom).offset(120)
        }
        
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
            $0.top.equalToSuperview().offset(95)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(130)
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
        
        folderImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(31)
            $0.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(87)
            $0.width.equalTo(107)
        }
        
        labSearchTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        labSearchTextField.setLeftPadding(52)
        labSearchTextField.errorfix()
        labSearchTextField.isUserInteractionEnabled = false
        
        tapOverlayButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(82)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        tapOverlayButton.addTarget(self, action: #selector(textFieldTapped), for: .touchUpInside)
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(labSearchTextField)
            $0.leading.equalToSuperview().offset(40)
            $0.height.width.equalTo(24)
        }
        
        reviewView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        labReviewTableView.snp.makeConstraints {
            $0.top.equalTo(reviewLabel.snp.bottom).offset(4)
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
    
    @objc private func textFieldTapped() {
        let nextVC = BoardSearchViewController(title: "게시판", menu: "")
        nextVC.modalPresentationStyle = .fullScreen
        parentVC?.present(nextVC, animated: true, completion: nil)
    }
}

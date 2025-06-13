//
//  DirectoryView.swift
//  Sukbakji
//
//  Created by jaegu park on 6/10/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class DirectoryView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
    let titleView = UIView().then {
        $0.backgroundColor = .white
    }
    let titleLabel = UILabel().then {
        $0.text = "연구실 디렉토리"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 22)
        $0.textColor = .gray900
    }
    let notificationButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Notification"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    let mypageButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Mypage"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let boardSearchTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "학과와 연구 주제로 검색해 보세요"
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
    let favLabView = UIView().then {
        $0.backgroundColor = .clear
    }
    let favLabLabel = UILabel().then {
        $0.text = "즐겨찾는 연구실"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let favLabImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_MentorProgress")
    }
    let favLabButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_More"), for: .normal)
        $0.setTitle("더보기 ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setTitleColor(.gray500, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    let noFavLab = UILabel().then {
        $0.text = "아직 즐겨찾는 연구실이 없어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .gray500
    }
    let noFavLabLabel = UILabel().then {
        $0.text = "연구실을 탐색하고 즐겨찾기를 등록해 보세요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 11)
        $0.textColor = .gray500
    }
    let favLabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FavoriteLabCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteLabCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        cv.allowsSelection = false
        
        return cv
    }()
    let topicView = UIView().then {
        $0.backgroundColor = .clear
    }
    let topicLabel = UILabel().then {
        $0.text = "관심 주제 모아보기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let topicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        cv.allowsSelection = false
        
        return cv
    }()
    let topicImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Background")
    }
    let reviewView = UIView().then {
        $0.backgroundColor = .clear
    }
    let reviewLabel = UILabel().then {
        $0.text = "연구실 후기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let reviewImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_MentorProgress")
    }
    let reviewButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_More"), for: .normal)
        $0.setTitle("더보기 ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setTitleColor(.gray500, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    let labReviewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(LabReviewCollectionViewCell.self, forCellWithReuseIdentifier: LabReviewCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        cv.allowsSelection = false
        cv.showsHorizontalScrollIndicator = false
        
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
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(mypageButton)
        titleView.addSubview(notificationButton)
        titleView.addSubview(backgroundLabel)
        
        contentView.addSubview(boardSearchTextField)
        contentView.addSubview(tapOverlayButton)
        contentView.addSubview(searchImageView)
        
        contentView.addSubview(favLabView)
        favLabView.addSubview(favLabLabel)
        favLabView.addSubview(favLabImageView)
        favLabView.addSubview(favLabButton)
        favLabView.addSubview(noFavLab)
        favLabView.addSubview(noFavLabLabel)
        favLabView.addSubview(favLabCollectionView)
        
        contentView.addSubview(topicView)
        topicView.addSubview(topicLabel)
        topicView.addSubview(topicCollectionView)
        topicView.addSubview(topicImageView)
        
        contentView.addSubview(reviewView)
        reviewView.addSubview(reviewLabel)
        reviewView.addSubview(reviewImageView)
        reviewView.addSubview(reviewButton)
        reviewView.addSubview(labReviewCollectionView)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(reviewView.snp.bottom).offset(110)
        }
        
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(26)
        }
        
        mypageButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(titleLabel)
            $0.height.width.equalTo(48)
        }
        
        notificationButton.snp.makeConstraints {
            $0.trailing.equalTo(mypageButton.snp.leading)
            $0.centerY.equalTo(titleLabel)
            $0.height.width.equalTo(48)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        boardSearchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(115)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        boardSearchTextField.setLeftPadding(52)
        boardSearchTextField.errorfix()
        boardSearchTextField.isUserInteractionEnabled = false
        
        tapOverlayButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(133)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        tapOverlayButton.addTarget(self, action: #selector(textFieldTapped), for: .touchUpInside)
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(boardSearchTextField)
            $0.leading.equalToSuperview().offset(40)
            $0.height.width.equalTo(24)
        }
        
        favLabView.snp.makeConstraints {
            $0.top.equalTo(boardSearchTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        favLabLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        favLabImageView.snp.makeConstraints {
            $0.centerY.equalTo(favLabLabel)
            $0.leading.equalTo(favLabLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(21)
        }
        
        favLabButton.snp.makeConstraints {
            $0.centerY.equalTo(favLabLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(26)
            $0.width.equalTo(64)
        }
        
        noFavLab.snp.makeConstraints {
            $0.top.equalTo(favLabLabel.snp.bottom).offset(52)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(17)
        }
        
        noFavLabLabel.snp.makeConstraints {
            $0.top.equalTo(noFavLab.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(13)
        }
        
        favLabCollectionView.snp.makeConstraints {
            $0.top.equalTo(favLabLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(196)
        }
        
        topicView.snp.makeConstraints {
            $0.top.equalTo(favLabView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(198)
        }
        
        topicLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        topicCollectionView.snp.makeConstraints {
            $0.top.equalTo(topicLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(53)
        }
        
        topicImageView.snp.makeConstraints {
            $0.top.equalTo(topicCollectionView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(100)
        }
        
        reviewView.snp.makeConstraints {
            $0.top.equalTo(topicView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(218)
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        reviewImageView.snp.makeConstraints {
            $0.centerY.equalTo(reviewLabel)
            $0.leading.equalTo(reviewLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(21)
        }
        
        reviewButton.snp.makeConstraints {
            $0.centerY.equalTo(reviewLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(26)
            $0.width.equalTo(64)
        }
        
        labReviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(reviewLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(169)
        }
    }
    
    @objc private func textFieldTapped() {
        let nextVC = BoardSearchViewController(title: "게시판", menu: "")
        nextVC.modalPresentationStyle = .fullScreen
        parentVC?.present(nextVC, animated: true, completion: nil)
    }
}

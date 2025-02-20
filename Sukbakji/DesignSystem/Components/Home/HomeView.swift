//
//  HomeView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/19/25.
//

import UIKit
import SnapKit
import Then

class HomeView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
    let titleView = UIView().then {
        $0.backgroundColor = .white
    }
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Homelogo")
    }
    let notificationButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Notification"), for: .normal)
    }
    let mypageButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Mypage"), for: .normal)
    }
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let helloView = UIView().then {
        $0.backgroundColor = .white
    }
    let nameLabel = UILabel().then {
        $0.text = "님, 반가워요!"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .orange800
    }
    let titleLabel = UILabel().then {
        $0.text = "석박지와 함께\n오늘의 일정을 확인해 보세요!🏃"
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let upComingView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    let layerImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Layer")
    }
    let upComingLabel = UILabel().then {
        $0.text = "다가오는 일정"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray600
    }
    let noUpComingLabel = UILabel().then {
        $0.text = "대학교를 설정하고\n일정을 확인해 보세요!"
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let upComingDate = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .orange700
    }
    let upComingTitle = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let adView = UIView().then {
        $0.backgroundColor = .white
    }
    let adLabel = UILabel().then {
        $0.text = "석박지가 Pick!했어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let adImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Pick")
    }
    let adLabel2 = UILabel().then {
        $0.text = "AD"
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .gray500
    }
    let adCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 26
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(AdvertiseCollectionViewCell.self, forCellWithReuseIdentifier: AdvertiseCollectionViewCell.identifier)
        cv.allowsSelection = false
        cv.backgroundColor = .clear
        cv.layer.cornerRadius = 15
        cv.layer.masksToBounds = false
        
        return cv
    }()
    let favBoardView = UIView().then {
        $0.backgroundColor = .gray50
    }
    let favBoardLabel = UILabel().then {
        $0.text = "즐겨찾는 게시판"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let favBoardImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Favorite")
    }
    let favBoardButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_More"), for: .normal)
        $0.setTitle("더보기 ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setTitleColor(.gray500, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    let noFavBoard = UILabel().then {
        $0.text = "아직 즐겨찾는 게시판이 없어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .gray500
    }
    let noFavBoardLabel = UILabel().then {
        $0.text = "게시판을 탐색하고 즐겨찾기를 등록해 보세요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 11)
        $0.textColor = .gray500
    }
    let favBoardContainerView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1.2
        $0.layer.borderColor = UIColor.gray100.cgColor
        $0.layer.masksToBounds = true
    }
    let favBoardTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(FavoriteBoardTableViewCell.self, forCellReuseIdentifier: FavoriteBoardTableViewCell.identifier)
        $0.allowsSelection = false
    }
    let hotPostView = UIView().then {
        $0.backgroundColor = .clear
    }
    let hotPostLabel = UILabel().then {
        $0.text = "실시간 인기글"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let hotPostImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Fire")
    }
    let hotPostTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(HotPostTableViewCell.self, forCellReuseIdentifier: HotPostTableViewCell.identifier)
        $0.allowsSelection = false
    }
    let layerView = UIView().then {
        $0.backgroundColor = UIColor.orange500
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
        $0.image = UIImage(named: "Sukbakji_Lab")
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
    let favLabProgressView = UIProgressView().then {
        $0.progressTintColor = UIColor.orange400
        $0.trackTintColor = .gray100
        $0.progress = 0.0
    }
    let personalInfoButton = UIButton().then {
        $0.setTitle("개인정보처리방침", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.setTitleColor(.gray500, for: .normal)
    }
    let topButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_FABtop"), for: .normal)
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
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        addSubview(titleView)
        titleView.addSubview(logoImageView)
        titleView.addSubview(mypageButton)
        titleView.addSubview(notificationButton)
        titleView.addSubview(backgroundLabel)
        
        contentView.addSubview(helloView)
        helloView.addSubview(nameLabel)
        helloView.addSubview(titleLabel)
        
        contentView.addSubview(upComingView)
        upComingView.addSubview(layerImageView)
        upComingView.addSubview(upComingLabel)
        upComingView.addSubview(upComingDate)
        upComingView.addSubview(upComingTitle)
        upComingView.addSubview(noUpComingLabel)
        
        contentView.addSubview(adView)
        adView.addSubview(adLabel)
        adView.addSubview(adImageView)
        adView.addSubview(adLabel2)
        adView.addSubview(adCollectionView)
        
        contentView.addSubview(favBoardView)
        favBoardView.addSubview(favBoardLabel)
        favBoardView.addSubview(favBoardImageView)
        favBoardView.addSubview(favBoardButton)
        favBoardView.addSubview(noFavBoard)
        favBoardView.addSubview(noFavBoardLabel)
        favBoardView.addSubview(favBoardContainerView)
        favBoardView.addSubview(favBoardTableView)
        
        contentView.addSubview(hotPostView)
        hotPostView.addSubview(hotPostLabel)
        hotPostView.addSubview(hotPostImageView)
        hotPostView.addSubview(hotPostTableView)
        
        contentView.addSubview(layerView)
        
        contentView.addSubview(favLabView)
        favLabView.addSubview(favLabLabel)
        favLabView.addSubview(favLabImageView)
        favLabView.addSubview(noFavLab)
        favLabView.addSubview(noFavLabLabel)
        favLabView.addSubview(favLabCollectionView)
        favLabView.addSubview(favLabProgressView)
        
        contentView.addSubview(personalInfoButton)
        addSubview(topButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(1570)
        }
        
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        logoImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(32)
            $0.width.equalTo(74)
        }
        
        mypageButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(logoImageView)
            $0.height.width.equalTo(48)
        }
        
        notificationButton.snp.makeConstraints {
            $0.trailing.equalTo(mypageButton.snp.leading)
            $0.centerY.equalTo(logoImageView)
            $0.height.width.equalTo(48)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        helloView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(103)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(17)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(52)
            $0.width.equalTo(230)
        }
        
        upComingView.snp.makeConstraints {
            $0.top.equalTo(helloView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(93)
        }
        
        layerImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(8)
        }
        
        upComingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(layerImageView.snp.trailing).offset(14)
        }
        
        upComingDate.snp.makeConstraints {
            $0.top.equalTo(upComingLabel.snp.bottom).offset(5)
            $0.leading.equalTo(layerImageView.snp.trailing).offset(14)
        }
        
        upComingTitle.snp.makeConstraints {
            $0.top.equalTo(upComingDate.snp.bottom).offset(5)
            $0.leading.equalTo(layerImageView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        noUpComingLabel.snp.makeConstraints {
            $0.top.equalTo(upComingLabel.snp.bottom).offset(5)
            $0.leading.equalTo(layerImageView.snp.trailing).offset(14)
            $0.height.equalTo(52)
        }
        
        adView.snp.makeConstraints {
            $0.top.equalTo(upComingView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(181)
        }
        
        adLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        adImageView.snp.makeConstraints {
            $0.centerY.equalTo(adLabel)
            $0.leading.equalTo(adLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(20)
        }
        
        adLabel2.snp.makeConstraints {
            $0.centerY.equalTo(adLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        adCollectionView.snp.makeConstraints {
            $0.top.equalTo(adLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(124)
        }
        
        favBoardView.snp.makeConstraints {
            $0.top.equalTo(adView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(209)
        }
        
        favBoardLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        favBoardImageView.snp.makeConstraints {
            $0.centerY.equalTo(favBoardLabel)
            $0.leading.equalTo(favBoardLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(21)
        }
        
        favBoardButton.snp.makeConstraints {
            $0.centerY.equalTo(favBoardLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(26)
            $0.width.equalTo(64)
        }
        
        noFavBoard.snp.makeConstraints {
            $0.top.equalTo(favBoardLabel.snp.bottom).offset(52)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(17)
        }
        
        noFavBoardLabel.snp.makeConstraints {
            $0.top.equalTo(noFavBoard.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(13)
        }
        
        favBoardContainerView.snp.makeConstraints {
            $0.top.equalTo(favBoardLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(36)
        }
        
        favBoardTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        favBoardTableView.isScrollEnabled = false
        
        hotPostView.snp.makeConstraints {
            $0.top.equalTo(favBoardView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(383)
        }
        
        hotPostLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
        }
        
        hotPostImageView.snp.makeConstraints {
            $0.centerY.equalTo(hotPostLabel)
            $0.leading.equalTo(hotPostLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(21)
        }
        
        hotPostTableView.snp.makeConstraints {
            $0.top.equalTo(hotPostLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
        hotPostTableView.isScrollEnabled = false
        
        layerView.snp.makeConstraints {
            $0.top.equalTo(hotPostView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        favLabView.snp.makeConstraints {
            $0.top.equalTo(layerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(275)
        }
        
        favLabLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
        }
        
        favLabImageView.snp.makeConstraints {
            $0.centerY.equalTo(favLabLabel)
            $0.leading.equalTo(favLabLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(21)
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
        
        favLabProgressView.snp.makeConstraints {
            $0.top.equalTo(favLabCollectionView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(35)
        }
        
        personalInfoButton.snp.makeConstraints {
            $0.top.equalTo(favLabView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(35)
        }
        
        topButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(112)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(60)
        }
    }
}

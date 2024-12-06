//
//  HomeViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/15/24.
//

import UIKit
import SnapKit
import Alamofire
import Then
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: UIViewController {
    
    let favoriteBoardViewModel = FavoriteBoardViewModel()
    let hotPostViewModel = HotPostViewModel()
    let favoriteLabViewModel = FavoriteLabViewModel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Homelogo")
    }
    private let notificationButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Notification"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    private let mypageButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Mypage"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray200
    }
    private let nameLabel = UILabel().then {
        $0.text = "님, 반가워요!"
        $0.font = UIFont(name: "Pretendard-Bold", size: 14)
        $0.textColor = UIColor(named: "Coquelicot")
    }
    private let titleLabel = UILabel().then {
        $0.text = "석박지"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.textColor = UIColor(named: "Coquelicot")
    }
    private let titleLabel2 = UILabel().then {
        $0.text = "와 함께"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.textColor = .black
    }
    private let titleLabel3 = UILabel().then {
        $0.text = "오늘의 일정을 확인해 보세요!🏃"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.textColor = .black
    }
    private let upComingView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = false
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 2
        $0.layer.shadowOffset = .init(width: 0, height: 0.2)
    }
    private let layerImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Layer")
    }
    private let upComingLabel = UILabel().then {
        $0.text = "다가오는 일정"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray600
    }
    private let upComingDate = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = UIColor(named: "Coquelicot")
    }
    private let upComingTitle = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let adLabel = UILabel().then {
        $0.text = "석박지"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.textColor = UIColor(named: "Coquelicot")
    }
    private let adLabel2 = UILabel().then {
        $0.text = "가 Pick!했어요"
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.textColor = .black
    }
    private let adImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Pick")
    }
    private let adLabel3 = UILabel().then {
        $0.text = "AD"
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .gray600
    }
    private var advertiseCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 26
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(AdvertiseCollectionViewCell.self, forCellWithReuseIdentifier: AdvertiseCollectionViewCell.identifier)
        cv.allowsSelection = false
        cv.backgroundColor = .clear
        cv.layer.cornerRadius = 15
        cv.layer.masksToBounds = false// any value you want
        cv.layer.shadowOpacity = 0.2// any value you want
        cv.layer.shadowRadius = 2 // any value you want
        cv.layer.shadowOffset = .init(width: 0, height: 0.2)
        
        return cv
    }()
    private let favoriteBoardView = UIView().then {
        $0.backgroundColor = .gray50
    }
    private let favoriteBoardLabel = UILabel().then {
        $0.text = "즐겨찾는 게시판"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let favoriteBoardImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Favorite")
    }
    private let favoriteBoardButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_More"), for: .normal)
        $0.setTitle("더보기 ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setTitleColor(.gray400, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    private let noFavoriteBoard = UILabel().then {
        $0.text = "아직 즐겨찾는 게시판이 없어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .gray400
    }
    private let noFavoriteBoardLabel = UILabel().then {
        $0.text = "게시판을 탐색하고 즐겨찾기를 등록해 보세요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 11)
        $0.textColor = .gray400
    }
    private var favoriteBoardTableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.separatorStyle = .singleLine
        $0.backgroundColor = .clear
        $0.register(FavoriteBoardTableViewCell.self, forCellReuseIdentifier: FavoriteBoardTableViewCell.identifier)
        $0.layer.masksToBounds = true// any value you want
        $0.layer.shadowOpacity = 0.2// any value you want
        $0.layer.shadowRadius = 2 // any value you want
        $0.layer.shadowOffset = .init(width: 0, height: 0.5)
        $0.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 0, right: 24)
    }
    private let hotPostView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let hotPostLabel = UILabel().then {
        $0.text = "실시간 인기글"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let hotPostImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Fire")
    }
    private var hotPostTableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(HotPostTableViewCell.self, forCellReuseIdentifier: HotPostTableViewCell.identifier)
        $0.layer.masksToBounds = true// any value you want
        $0.layer.shadowOpacity = 0.2// any value you want
        $0.layer.shadowRadius = 2 // any value you want
        $0.layer.shadowOffset = .init(width: 0, height: 0.2)
        $0.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 0, right: 24)
    }
    private let layerView = UIView().then {
        $0.backgroundColor = UIColor(named: "Coquelicot")
    }
    private let favoriteLabView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let favoriteLabLabel = UILabel().then {
        $0.text = "즐겨찾는 연구실"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let favoriteLabImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Lab")
    }
    private let noFavoriteLab = UILabel().then {
        $0.text = "아직 즐겨찾는 연구실이 없어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .gray400
    }
    private let noFavoriteLabLabel = UILabel().then {
        $0.text = "연구실을 탐색하고 즐겨찾기를 등록해 보세요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 11)
        $0.textColor = .gray400
    }
    private var favoriteLabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FavoriteLabCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteLabCollectionViewCell.identifier)
        cv.allowsSelection = false
        cv.backgroundColor = .clear
        cv.layer.masksToBounds = false// any value you want
        cv.layer.shadowOpacity = 0.2// any value you want
        cv.layer.shadowRadius = 2 // any value you want
        cv.layer.shadowOffset = .init(width: 0, height: 0.2)
        
        return cv
    }()
    private var favoriteLabProgressView = UIProgressView().then {
        $0.progressTintColor = UIColor(named: "Coquelicot")
        $0.trackTintColor = .gray200
        $0.progress = 0.0
        $0.clipsToBounds = true
    }
    private let personalInfoButton = UIButton().then {
        $0.setTitle("개인정보처리방침", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.setTitleColor(.gray400, for: .normal)
    }
    private let topButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_FABtop"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    
    private let disposeBag = DisposeBag()
    
    var scheduleArr: [UpComingResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
//        getMemberID()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
//        getUserName()
//        getViewSchedule()
        setFavoriteBoardAPI()
//        setHotPostAPI()
//        setFavoriteLabAPI()
    }
}
    
extension HomeViewController {
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(1570)
        }
        
        self.contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(32)
            make.width.equalTo(70)
        }
        
        self.contentView.addSubview(mypageButton)
        mypageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalTo(logoImageView)
            make.height.width.equalTo(48)
        }
        mypageButton.addTarget(self, action: #selector(info_Tapped), for: .touchUpInside)
        
        self.contentView.addSubview(notificationButton)
        notificationButton.snp.makeConstraints { make in
            make.trailing.equalTo(mypageButton.snp.leading)
            make.centerY.equalTo(logoImageView)
            make.height.width.equalTo(48)
        }
        
        self.contentView.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(mypageButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(17)
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(26)
        }
        
        self.contentView.addSubview(titleLabel2)
        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.height.equalTo(26)
        }
        
        self.contentView.addSubview(titleLabel3)
        titleLabel3.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(26)
        }
        
        self.contentView.addSubview(upComingView)
        upComingView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel3.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(93)
        }
        
        self.upComingView.addSubview(layerImageView)
        layerImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(6)
        }
        
        self.upComingView.addSubview(upComingLabel)
        upComingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(layerImageView.snp.trailing).offset(14)
        }
        
        self.upComingView.addSubview(upComingDate)
        upComingDate.snp.makeConstraints { make in
            make.top.equalTo(upComingLabel.snp.bottom).offset(5)
            make.leading.equalTo(layerImageView.snp.trailing).offset(14)
        }
        
        self.upComingView.addSubview(upComingTitle)
        upComingTitle.snp.makeConstraints { make in
            make.top.equalTo(upComingDate.snp.bottom).offset(5)
            make.leading.equalTo(layerImageView.snp.trailing).offset(14)
            make.trailing.equalToSuperview().inset(20)
        }
        
        self.contentView.addSubview(adLabel)
        adLabel.snp.makeConstraints { make in
            make.top.equalTo(upComingView.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(26)
        }
        
        self.contentView.addSubview(adLabel2)
        adLabel2.snp.makeConstraints { make in
            make.top.equalTo(upComingView.snp.bottom).offset(28)
            make.leading.equalTo(adLabel.snp.trailing)
            make.height.equalTo(26)
        }
        
        self.contentView.addSubview(adImageView)
        adImageView.snp.makeConstraints { make in
            make.top.equalTo(upComingView.snp.bottom).offset(31)
            make.leading.equalTo(adLabel2.snp.trailing).offset(4)
            make.height.width.equalTo(20)
        }
        
        self.contentView.addSubview(adLabel3)
        adLabel3.snp.makeConstraints { make in
            make.top.equalTo(upComingView.snp.bottom).offset(34)
            make.trailing.equalToSuperview().inset(24)
        }
        
        advertiseCollectionView.tag = 1
        self.contentView.addSubview(advertiseCollectionView)
        advertiseCollectionView.snp.makeConstraints { make in
            make.top.equalTo(adLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(124)
        }
        
        self.contentView.addSubview(favoriteBoardView)
        favoriteBoardView.snp.makeConstraints { make in
            make.top.equalTo(advertiseCollectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(209)
        }
        
        self.favoriteBoardView.addSubview(favoriteBoardLabel)
        favoriteBoardLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(24)
        }
        
        self.favoriteBoardView.addSubview(favoriteBoardImageView)
        favoriteBoardImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalTo(favoriteBoardLabel.snp.trailing).offset(4)
            make.height.width.equalTo(21)
        }
        
        self.favoriteBoardView.addSubview(favoriteBoardButton)
        favoriteBoardButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(26)
            make.width.equalTo(64)
        }
        
        self.favoriteBoardView.addSubview(noFavoriteBoard)
        noFavoriteBoard.snp.makeConstraints { make in
            make.top.equalTo(favoriteBoardLabel.snp.bottom).offset(52)
            make.centerX.equalToSuperview()
            make.height.equalTo(17)
        }
        
        self.favoriteBoardView.addSubview(noFavoriteBoardLabel)
        noFavoriteBoardLabel.snp.makeConstraints { make in
            make.top.equalTo(noFavoriteBoard.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(13)
        }
        
        self.favoriteBoardView.addSubview(favoriteBoardTableView)
        favoriteBoardTableView.snp.makeConstraints { make in
            make.top.equalTo(favoriteBoardLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        favoriteBoardTableView.isScrollEnabled = false
        
        self.contentView.addSubview(hotPostView)
        hotPostView.snp.makeConstraints { make in
            make.top.equalTo(favoriteBoardView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(383)
        }
        
        self.hotPostView.addSubview(hotPostLabel)
        hotPostLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(24)
        }
        
        self.hotPostView.addSubview(hotPostImageView)
        hotPostImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalTo(hotPostLabel.snp.trailing).offset(4)
            make.height.width.equalTo(21)
        }
        
        self.hotPostView.addSubview(hotPostTableView)
        hotPostTableView.snp.makeConstraints { make in
            make.top.equalTo(hotPostLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        hotPostTableView.isScrollEnabled = false
        
        self.contentView.addSubview(layerView)
        layerView.snp.makeConstraints { make in
            make.top.equalTo(hotPostView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(64)
        }
        
        self.contentView.addSubview(favoriteLabView)
        favoriteLabView.snp.makeConstraints { make in
            make.top.equalTo(layerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(275)
        }
        
        self.favoriteLabView.addSubview(favoriteLabLabel)
        favoriteLabLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(24)
        }
        
        self.favoriteLabView.addSubview(favoriteLabImageView)
        favoriteLabImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalTo(favoriteLabLabel.snp.trailing).offset(4)
            make.height.width.equalTo(21)
        }
        
        self.favoriteLabView.addSubview(noFavoriteLab)
        noFavoriteLab.snp.makeConstraints { make in
            make.top.equalTo(favoriteLabLabel.snp.bottom).offset(52)
            make.centerX.equalToSuperview()
            make.height.equalTo(17)
        }
        
        self.favoriteLabView.addSubview(noFavoriteLabLabel)
        noFavoriteLabLabel.snp.makeConstraints { make in
            make.top.equalTo(noFavoriteLab.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(13)
        }
        
        favoriteLabCollectionView.tag = 2
        self.favoriteLabView.addSubview(favoriteLabCollectionView)
        favoriteLabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(favoriteLabLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(196)
        }
        
        self.favoriteLabView.addSubview(favoriteLabProgressView)
        favoriteLabProgressView.snp.makeConstraints { make in
            make.top.equalTo(favoriteLabCollectionView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        self.contentView.addSubview(personalInfoButton)
        personalInfoButton.snp.makeConstraints { make in
            make.top.equalTo(favoriteLabView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }
        
        self.view.addSubview(topButton)
        topButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(112)
            make.trailing.equalToSuperview().inset(24)
            make.height.width.equalTo(60)
        }
        topButton.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
    }
    
    @objc func scrollToTop() {
        scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
    }
    
    @objc private func info_Tapped() {
        let mypageViewController = MypageViewController()
        self.navigationController?.pushViewController(mypageViewController, animated: true)
    }
}

extension HomeViewController {
    
    private func getUserName() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.mypage.path
        
        APIService().getWithAccessToken(of: APIResponse<MyProfile>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                self.nameLabel.text = response.result.name
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    private func getViewSchedule() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendar.path
        
        APIService().getWithAccessToken(of: APIResponse<UpComing>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                self.scheduleArr = response.result.scheduleList
                if self.scheduleArr.count >= 1{
                    let upComingdDay = self.scheduleArr[0].dday
                    let upComingContent = self.scheduleArr[0].content
                    let upComingUniv = self.scheduleArr[0].univId
                    
                    if upComingdDay < 0 {
                        let dayNum = abs(upComingdDay)
                        self.upComingDate.text = "D+\(dayNum)"
                    } else {
                        self.upComingDate.text = "D-\(upComingdDay )"
                    }
                    if upComingUniv == 1 {
                        self.upComingTitle.text = "서울대학교 \(upComingContent)"
                    } else if upComingUniv == 2 {
                        self.upComingTitle.text = "연세대학교 \(upComingContent)"
                    } else if upComingUniv == 3 {
                        self.upComingTitle.text = "고려대학교 \(upComingContent)"
                    } else if upComingUniv == 4 {
                        self.upComingTitle.text = "카이스트 \(upComingContent)"
                    }
                } else {
                    self.upComingDate.isHidden = true
                    self.upComingTitle.text = "다가오는 일정이 없습니다"
                }
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    private func getMemberID() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.user.path
        
        APIService().getWithAccessToken(of: APIResponse<MemberId>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                let memberId = response.result.memberId
                UserDefaults.standard.set(memberId, forKey: "memberID")
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    private func setFavoriteBoardData() {
        favoriteBoardTableView.delegate = nil
        favoriteBoardTableView.dataSource = nil
        
        favoriteBoardTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.favoriteBoardViewModel.favoriteBoardItems
            .observe(on: MainScheduler.instance)
            .bind(to: self.favoriteBoardTableView.rx.items(cellIdentifier: FavoriteBoardTableViewCell.identifier, cellType: FavoriteBoardTableViewCell.self)) { index, item, cell in
                cell.prepare(favoriteBoard: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func setFavoriteBoardAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.community.path + "/favorite-post-list"
        
        APIService().getWithAccessToken(of: APIResponse<[FavoritesBoard]>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                if response.result.isEmpty {
                    self.favoriteBoardTableView.isHidden = true
                    print("없음")
                } else {
                    self.favoriteBoardTableView.isHidden = false
                    self.favoriteBoardViewModel.favoriteBoardItems = Observable.just(response.result)
                    self.setFavoriteBoardData()
                    self.view.layoutIfNeeded()
                }
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    private func setHotPostData() {
        hotPostTableView.delegate = nil
        hotPostTableView.dataSource = nil
        
        hotPostTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<HotPostSection>(
                configureCell: { _, tableView, indexPath, item in
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: HotPostTableViewCell.identifier, for: indexPath) as? HotPostTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.prepare(hotPost: item)
                    return cell
                }
            )
        
        self.hotPostViewModel.hotPostItems
                .map { [HotPostSection(items: $0)] } // 각 아이템을 섹션으로 만듦
                .observe(on: MainScheduler.instance)
                .bind(to: self.hotPostTableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
    }
    
    private func setHotPostAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.posts.path
        
        APIService().getWithAccessToken(of: APIResponse<[HotPost]>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                if response.result.isEmpty {
                    self.hotPostTableView.isHidden = true
                } else {
                    self.hotPostTableView.isHidden = false
                    self.hotPostViewModel.hotPostItems = Observable.just(response.result)
                    self.setHotPostData()
                    self.view.layoutIfNeeded()
                }
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    private func setFavoriteLabData() {
        favoriteLabCollectionView.delegate = nil
        favoriteLabCollectionView.dataSource = nil
        
        favoriteLabCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.favoriteLabViewModel.favoriteLabItems
            .observe(on: MainScheduler.instance)
            .bind(to: self.favoriteLabCollectionView.rx.items(cellIdentifier: FavoriteLabCollectionViewCell.identifier, cellType: FavoriteLabCollectionViewCell.self)) { index, item, cell in
                cell.prepare(favoriteLab: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func setFavoriteLabAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.labs.path
        
        APIService().getWithAccessToken(of: APIResponse<[FavoritesLab]>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                if response.result.isEmpty {
                    self.favoriteLabCollectionView.isHidden = true
                } else {
                    self.favoriteLabCollectionView.isHidden = false
                    self.favoriteLabViewModel.favoriteLabItems = Observable.just(response.result)
                    self.setFavoriteLabData()
                    self.view.layoutIfNeeded()
                }
            default:
                AlertController(message: response.message).show()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        if collectionView.tag == 2 {
            let contentOffsetX = scrollView.contentOffset.x
            let contentWidth = scrollView.contentSize.width
            let scrollViewWidth = scrollView.frame.size.width
            
            // 현재 스크롤 위치에 따라 진행도 계산
            let progress = Float(contentOffsetX / (contentWidth - scrollViewWidth))
            
            // ProgressView 업데이트
            favoriteLabProgressView.setProgress(progress, animated: true)
            
            // 컬렉션 뷰 끝에 도달했는지 확인
            if contentOffsetX + scrollViewWidth >= contentWidth {
                favoriteLabProgressView.setProgress(1.0, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize(width: 342, height: 100)
        } else {
            return CGSize(width: 300, height: 172)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       if tableView == favoriteBoardTableView {
           return 56
       } else {
           return 147
       }
   }
}

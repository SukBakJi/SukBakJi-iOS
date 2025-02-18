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
    
    private let favoriteBoardViewModel = FavoriteBoardViewModel()
    private let hotPostViewModel = HotPostViewModel()
    private let favoriteLabViewModel = FavoriteLabViewModel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleView = UIView().then {
        $0.backgroundColor = .white
    }
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
        $0.backgroundColor = .gray100
    }
    private let helloView = UIView().then {
        $0.backgroundColor = .white
    }
    private let nameLabel = UILabel().then {
        $0.text = "님, 반가워요!"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .orange800
    }
    private let titleLabel = UILabel().then {
        $0.text = "석박지와 함께\n오늘의 일정을 확인해 보세요!🏃"
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let upComingView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
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
        $0.textColor = .orange700
    }
    private let upComingTitle = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let adLabel = UILabel().then {
        $0.text = "석박지가 Pick!했어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let adImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Pick")
    }
    private let adLabel2 = UILabel().then {
        $0.text = "AD"
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .gray500
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
        
        return cv
    }()
    private let favoriteBoardView = UIView().then {
        $0.backgroundColor = .gray50
    }
    private let favoriteBoardLabel = UILabel().then {
        $0.text = "즐겨찾는 게시판"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let favoriteBoardImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Favorite")
    }
    private let favoriteBoardButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_More"), for: .normal)
        $0.setTitle("더보기 ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setTitleColor(.gray500, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    private let noFavoriteBoard = UILabel().then {
        $0.text = "아직 즐겨찾는 게시판이 없어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .gray500
    }
    private let noFavoriteBoardLabel = UILabel().then {
        $0.text = "게시판을 탐색하고 즐겨찾기를 등록해 보세요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 11)
        $0.textColor = .gray500
    }
    private var favoriteBoardTableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.separatorStyle = .singleLine
        $0.backgroundColor = .clear
        $0.register(FavoriteBoardTableViewCell.self, forCellReuseIdentifier: FavoriteBoardTableViewCell.identifier)
        $0.layer.masksToBounds = true// any value you want
        $0.layer.shadowOpacity = 0.2// any value you want
        $0.layer.shadowRadius = 1 // any value you want
        $0.layer.shadowOffset = .init(width: 0, height: 0.5)
        $0.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 0, right: 24)
    }
    private let hotPostView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let hotPostLabel = UILabel().then {
        $0.text = "실시간 인기글"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let hotPostImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Fire")
    }
    private var hotPostTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(HotPostTableViewCell.self, forCellReuseIdentifier: HotPostTableViewCell.identifier)
    }
    private let layerView = UIView().then {
        $0.backgroundColor = UIColor.orange500
    }
    private let favoriteLabView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let favoriteLabLabel = UILabel().then {
        $0.text = "즐겨찾는 연구실"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let favoriteLabImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Lab")
    }
    private let noFavoriteLab = UILabel().then {
        $0.text = "아직 즐겨찾는 연구실이 없어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .gray500
    }
    private let noFavoriteLabLabel = UILabel().then {
        $0.text = "연구실을 탐색하고 즐겨찾기를 등록해 보세요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 11)
        $0.textColor = .gray500
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
        cv.layer.shadowRadius = 1 // any value you want
        cv.layer.shadowOffset = .init(width: 0, height: 0.2)
        
        return cv
    }()
    private var favoriteLabProgressView = UIProgressView().then {
        $0.progressTintColor = UIColor.orange400
        $0.trackTintColor = .gray100
        $0.progress = 0.0
        $0.clipsToBounds = true
    }
    private let personalInfoButton = UIButton().then {
        $0.setTitle("개인정보처리방침", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.setTitleColor(.gray500, for: .normal)
    }
    private let topButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_FABtop"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    
    private var disposeBag = DisposeBag()
    private var reactor = HomeReactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
//        bind(reactor: reactor)
//        setAPI()
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
        
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(95)
        }
        
        self.titleView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(32)
            make.width.equalTo(74)
        }
        
        self.titleView.addSubview(mypageButton)
        mypageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalTo(logoImageView)
            make.height.width.equalTo(48)
        }
        mypageButton.addTarget(self, action: #selector(info_Tapped), for: .touchUpInside)
        
        self.titleView.addSubview(notificationButton)
        notificationButton.snp.makeConstraints { make in
            make.trailing.equalTo(mypageButton.snp.leading)
            make.centerY.equalTo(logoImageView)
            make.height.width.equalTo(48)
        }
        
        self.titleView.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.contentView.addSubview(helloView)
        helloView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(95)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(103)
        }
        
        self.helloView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(17)
        }
        
        self.helloView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(52)
            make.width.equalTo(230)
        }
        let fullText = titleLabel.text ?? ""
        let changeText = "석박지"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        titleLabel.attributedText = attributedString
        
        self.contentView.addSubview(upComingView)
        upComingView.snp.makeConstraints { make in
            make.top.equalTo(helloView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(93)
        }
        
        self.upComingView.addSubview(layerImageView)
        layerImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(8)
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
            make.height.equalTo(21)
        }
        let fullText2 = adLabel.text ?? ""
        let changeText2 = "석박지"
        let attributedString2 = NSMutableAttributedString(string: fullText2)
        
        if let range = fullText2.range(of: changeText2) {
            let nsRange = NSRange(range, in: fullText2)
            attributedString2.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        adLabel.attributedText = attributedString2
        
        self.contentView.addSubview(adImageView)
        adImageView.snp.makeConstraints { make in
            make.centerY.equalTo(adLabel)
            make.leading.equalTo(adLabel.snp.trailing).offset(4)
            make.height.width.equalTo(20)
        }
        
        self.contentView.addSubview(adLabel2)
        adLabel2.snp.makeConstraints { make in
            make.centerY.equalTo(adLabel)
            make.trailing.equalToSuperview().inset(24)
        }
        
        advertiseCollectionView.tag = 1
        self.contentView.addSubview(advertiseCollectionView)
        advertiseCollectionView.snp.makeConstraints { make in
            make.top.equalTo(adLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(124)
        }
        advertiseCollectionView.delegate = self
        advertiseCollectionView.dataSource = self
        
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
            make.height.equalTo(21)
        }
        
        self.favoriteBoardView.addSubview(favoriteBoardImageView)
        favoriteBoardImageView.snp.makeConstraints { make in
            make.centerY.equalTo(favoriteBoardLabel)
            make.leading.equalTo(favoriteBoardLabel.snp.trailing).offset(4)
            make.height.width.equalTo(21)
        }
        
        self.favoriteBoardView.addSubview(favoriteBoardButton)
        favoriteBoardButton.snp.makeConstraints { make in
            make.centerY.equalTo(favoriteBoardLabel)
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
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
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
            make.centerY.equalTo(hotPostLabel)
            make.leading.equalTo(hotPostLabel.snp.trailing).offset(4)
            make.height.width.equalTo(21)
        }
        
        self.hotPostView.addSubview(hotPostTableView)
        hotPostTableView.snp.makeConstraints { make in
            make.top.equalTo(hotPostLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
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
            make.centerY.equalTo(favoriteLabLabel)
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
}

extension HomeViewController {
    private func setAPI() {
        bindFavoriteBoardViewModel()
        bindHotPostViewModel()
        bindFavoriteLabViewModel()
        fetchFavoriteBoards()
    }
    
    private func bind(reactor: HomeReactor) {
        // Action: View가 나타나면 API 요청
        reactor.action.onNext(.getUserName)
        reactor.action.onNext(.getViewSchedule)
        reactor.action.onNext(.getMemberID)
        
        // State: 프로필 이름 업데이트
        reactor.state.map { $0.nameLabel }
            .distinctUntilChanged()
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        // State: 일정 정보 업데이트
        reactor.state.map { $0.upComingDate }
            .distinctUntilChanged()
            .bind(to: upComingDate.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.upComingTitle }
            .distinctUntilChanged()
            .bind(to: upComingTitle.rx.text)
            .disposed(by: disposeBag)
        
        // State: 에러 발생 시 Alert 표시
        reactor.state.map { $0.errorMessage }
            .compactMap { $0 }
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindFavoriteBoardViewModel() {
        // ✅ 데이터 변경 시 UI 자동 업데이트
        favoriteBoardViewModel.favoriteBoardList
            .bind(to: favoriteBoardTableView.rx.items(cellIdentifier: FavoriteBoardTableViewCell.identifier, cellType: FavoriteBoardTableViewCell.self)) { row, board, cell in
                cell.prepare(favoriteBoard: board)
            }
            .disposed(by: disposeBag)
        
        // ✅ 에러 메시지 처리
        favoriteBoardViewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindHotPostViewModel() {
        // ✅ 데이터 변경 시 UI 자동 업데이트
        hotPostViewModel.hotPostList
            .bind(to: hotPostTableView.rx.items(cellIdentifier: HotPostTableViewCell.identifier, cellType: HotPostTableViewCell.self)) { row, post, cell in
                cell.prepare(hotPost: post)
            }
            .disposed(by: disposeBag)
        
        // ✅ 에러 메시지 처리
        hotPostViewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindFavoriteLabViewModel() {
        // ✅ 데이터 변경 시 UI 자동 업데이트
        favoriteLabViewModel.favoriteLabList
            .bind(to: favoriteLabCollectionView.rx.items(cellIdentifier: FavoriteLabCollectionViewCell.identifier, cellType: FavoriteLabCollectionViewCell.self)) { row, lab, cell in
                cell.prepare(favoriteLab: lab)
            }
            .disposed(by: disposeBag)
        
        // ✅ 에러 메시지 처리
        favoriteLabViewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchFavoriteBoards() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        favoriteBoardViewModel.loadFavoriteBoard(token: retrievedToken)
        hotPostViewModel.loadHotPost(token: retrievedToken)
        favoriteLabViewModel.loadFavoriteLab(token: retrievedToken)
    }
    
    
    @objc func scrollToTop() {
        scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
    }
    
    @objc private func info_Tapped() {
        let mypageViewController = MypageViewController()
        self.navigationController?.pushViewController(mypageViewController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AdvertiseCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertiseCollectionViewCell.identifier, for: indexPath) as! AdvertiseCollectionViewCell
                
        return cell
    }
    
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
           return 159
       }
   }
}

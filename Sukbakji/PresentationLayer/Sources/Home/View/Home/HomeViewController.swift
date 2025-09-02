//
//  HomeViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit
import FirebaseMessaging

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let fCMViewModel = FCMViewModel()
    var disposeBag = DisposeBag()
    var profileReactor: ProfileReactor?
    var homeReactor: HomeReactor?
    
    private var favBoardHeightConstraint: Constraint?
    private var hotPostHeightConstraint: Constraint?
    private var favLabHeightConstraint: Constraint?
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        self.profileReactor = ProfileReactor()
        self.homeReactor = HomeReactor(homeUseCase: HomeUseCase(), dirUseCase: DirectoryUseCase())
        bind(reactor: profileReactor!)
        bind(reactor: homeReactor!)
        getFCMToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
        homeReactor?.action.onNext(.viewWillAppear)
    }
}

extension HomeViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        homeView.favBoardContainerView.snp.makeConstraints { make in
            favBoardHeightConstraint = make.height.equalTo(112).constraint
        }
        homeView.hotPostView.snp.makeConstraints { make in
            hotPostHeightConstraint = make.height.equalTo(228).constraint
        }
        homeView.favLabView.snp.makeConstraints { make in
            favLabHeightConstraint = make.height.equalTo(200).constraint
        }
        
        homeView.adCollectionView.delegate = self
        homeView.adCollectionView.dataSource = self
        
        homeView.notificationButton.rx.tap
            .bind(onNext: { [weak self] in
                let vc = NotificationViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        homeView.mypageButton.rx.tap
            .bind(onNext: { [weak self] in
                let vc = MypageViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        homeView.favBoardButton.rx.tap   // 기존 moveToBoard()
            .bind(onNext: { [weak self] in
                guard let tabBar = self?.tabBarController as? MainTabViewController
                else { return }
                tabBar.switchToTab(index: 2)
            })
            .disposed(by: disposeBag)
    }
    
    private func getFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("FCM 토큰 가져오기 실패: \(error.localizedDescription)")
            } else if let token = token {
                print("현재 FCM 토큰: \(token)")
                // 서버에 토큰 업로드
                TokenManager.shared.saveFCMToken(token)
                self.fCMViewModel.uploadFCMToken(fcmToken: token)
            }
        }
    }
    
    func bind(reactor: ProfileReactor) {
        // Action: View가 나타나면 API 요청
        reactor.action.onNext(.getUserName)
        reactor.action.onNext(.getViewSchedule)
        reactor.action.onNext(.getMemberID)
        
        // State: 프로필 이름 업데이트
        reactor.state.map { $0.nameLabel }
            .distinctUntilChanged()
            .bind(to: homeView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        // State: 일정 정보 업데이트
        reactor.state.map { $0.upComingDate }
            .distinctUntilChanged()
            .bind(to: homeView.upComingDate.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.upComingTitle }
            .distinctUntilChanged()
            .bind(to: homeView.upComingTitle.rx.text)
            .disposed(by: disposeBag)
        
        // State: 에러 발생 시 Alert 표시
        reactor.state.map { $0.errorMessage }
            .compactMap { $0 }
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    private func bind(reactor: HomeReactor) {
        homeView.favBoardTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        homeView.hotPostTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        homeView.favLabCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.favBoards)
            .bind(to: homeView.favBoardTableView.rx.items(
                cellIdentifier: FavoriteBoardTableViewCell.identifier,
                cellType: FavoriteBoardTableViewCell.self)
            ) { _, item, cell in
                cell.prepare(favoriteBoard: item)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map(\.hotPosts)
            .bind(to: homeView.hotPostTableView.rx.items(
                cellIdentifier: HotPostTableViewCell.identifier,
                cellType: HotPostTableViewCell.self)
            ) { _, item, cell in
                cell.prepare(hotPost: item)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map(\.favLabs)
            .bind(to: homeView.favLabCollectionView.rx.items(
                cellIdentifier: FavoriteLabCollectionViewCell.identifier,
                cellType: FavoriteLabCollectionViewCell.self)
            ) { _, item, cell in
                cell.prepare(favoriteLab: item)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isFavBoardEmpty)
            .map { $0 } // true면 숨김
            .bind(to: homeView.favBoardContainerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isFavBoardEmpty)
            .subscribe(onNext: { [weak self] isEmpty in
                self?.homeView.noFavBoard.isHidden = !isEmpty
                self?.homeView.noFavBoardLabel.isHidden = !isEmpty
            })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isHotPostEmpty)
            .map { !$0 } // 비어있지 않으면 'noHotPost' 감춤
            .bind(to: homeView.noHotPost.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isFavLabEmpty)
            .map { $0 }
            .bind(to: homeView.favLabProgressView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.favBoards.count)
            .subscribe(onNext: { [weak self] count in
                if count == 1 { self?.favBoardHeightConstraint?.update(offset: 56) }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.hotPosts.count)
            .subscribe(onNext: { [weak self] count in
                if count >= 2 { self?.hotPostHeightConstraint?.update(offset: 383) }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map(\.favLabs.isEmpty)
            .subscribe(onNext: { [weak self] isEmpty in
                if !isEmpty { self?.favLabHeightConstraint?.update(offset: 275) }
            })
            .disposed(by: disposeBag)
        
        reactor.state.compactMap(\.errorMessage)
            .subscribe(onNext: { AlertController(message: $0).show() })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AdvertiseCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertiseCollectionViewCell.identifier, for: indexPath) as! AdvertiseCollectionViewCell
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        if collectionView == homeView.favLabCollectionView {
            let contentOffsetX = scrollView.contentOffset.x
            let contentWidth = scrollView.contentSize.width
            let scrollViewWidth = scrollView.frame.size.width
            let progress = Float(contentOffsetX / (contentWidth - scrollViewWidth))
            
            homeView.favLabProgressView.setProgress(progress, animated: true)
            
            if contentOffsetX + scrollViewWidth >= contentWidth {
                homeView.favLabProgressView.setProgress(1.0, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == homeView.adCollectionView {
            return CGSize(width: 342, height: 100)
        } else {
            return CGSize(width: 300, height: 172)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == homeView.favBoardTableView {
            return 56
        } else {
            return 147
        }
    }
}

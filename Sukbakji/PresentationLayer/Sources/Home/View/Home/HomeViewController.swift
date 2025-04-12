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
import SwiftUI

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let favoriteBoardViewModel = FavoriteBoardViewModel()
    private let hotPostViewModel = HotPostViewModel()
    private let favoriteLabViewModel = FavoriteLabViewModel()
    private let myProfileViewModel = MyProfileViewModel()
    var disposeBag = DisposeBag()
    var reactor: HomeReactor?
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAPI()
        self.reactor = HomeReactor()
        bind(reactor: reactor!)
        getFCMToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
}

extension HomeViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        homeView.notificationButton.addTarget(self, action: #selector(notification_Tapped), for: .touchUpInside)
        homeView.mypageButton.addTarget(self, action: #selector(info_Tapped), for: .touchUpInside)
        homeView.adCollectionView.delegate = self
        homeView.adCollectionView.dataSource = self
    }
    
    private func setAPI() {
        bindFavoriteBoardViewModel()
        bindHotPostViewModel()
        bindFavoriteLabViewModel()
        favoriteBoardViewModel.loadFavoriteBoard()
//        hotPostViewModel.loadHotPost()
//        favoriteLabViewModel.loadFavoriteLab()
        hotPostViewModel.loadTestData()
        favoriteLabViewModel.loadTestData()
    }
    
    private func getFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("FCM 토큰 가져오기 실패: \(error.localizedDescription)")
            } else if let token = token {
                print("현재 FCM 토큰: \(token)")
                // 서버에 토큰 업로드
                TokenManager.shared.saveFCMToken(token)
                self.myProfileViewModel.uploadFCMTokenToServer(fcmToken: token)
            }
        }
    }
    
    func bind(reactor: HomeReactor) {
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
    
    private func bindFavoriteBoardViewModel() {
        self.homeView.favBoardTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        favoriteBoardViewModel.favoriteBoardList
            .subscribe(onNext: { favoriteBoardList in
                if !favoriteBoardList.isEmpty {
                    self.homeView.noFavBoard.isHidden = true
                    self.homeView.noFavBoardLabel.isHidden = true
                } else {
                    self.homeView.noFavBoard.isHidden = false
                    self.homeView.noFavBoardLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)

        favoriteBoardViewModel.favoriteBoardList
            .bind(to: homeView.favBoardTableView.rx.items(cellIdentifier: FavoriteBoardTableViewCell.identifier, cellType: FavoriteBoardTableViewCell.self)) { row, board, cell in
                cell.prepare(favoriteBoard: board)
            }
            .disposed(by: disposeBag)

        favoriteBoardViewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindHotPostViewModel() {
        self.homeView.hotPostTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        hotPostViewModel.hotPostList
            .bind(to: homeView.hotPostTableView.rx.items(cellIdentifier: HotPostTableViewCell.identifier, cellType: HotPostTableViewCell.self)) { row, post, cell in
                cell.prepare(hotPost: post)
            }
            .disposed(by: disposeBag)
        
        hotPostViewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindFavoriteLabViewModel() {
        self.homeView.favLabCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        favoriteLabViewModel.favoriteLabList
            .subscribe(onNext: { favoriteLabList in
                if !favoriteLabList.isEmpty {
                    self.homeView.noFavLab.isHidden = true
                    self.homeView.noFavLabLabel.isHidden = true
                } else {
                    self.homeView.noFavLab.isHidden = false
                    self.homeView.noFavLabLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        favoriteLabViewModel.favoriteLabList
            .bind(to: homeView.favLabCollectionView.rx.items(cellIdentifier: FavoriteLabCollectionViewCell.identifier, cellType: FavoriteLabCollectionViewCell.self)) { row, lab, cell in
                cell.prepare(favoriteLab: lab)
            }
            .disposed(by: disposeBag)
        
        favoriteLabViewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func notification_Tapped() {
        let notificationViewController = NotificationViewController()
        self.navigationController?.pushViewController(notificationViewController, animated: true)
    }
    
    @objc private func info_Tapped() {
        let mypageViewController = MypageViewController()
        self.navigationController?.pushViewController(mypageViewController, animated: true)
    }
    
    @objc private func hot_Tapped() {
        let hotBoardView = HotBoardViewController()
        let hostingController = UIHostingController(rootView: hotBoardView)
        hostingController.modalPresentationStyle = .fullScreen
        
        self.present(hostingController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
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

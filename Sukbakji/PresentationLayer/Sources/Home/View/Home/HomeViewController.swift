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

class HomeViewController: UIViewController, View {
    
    private let homeView = HomeView()
    private let favoriteBoardViewModel = FavoriteBoardViewModel()
    private let hotPostViewModel = HotPostViewModel()
    private let favoriteLabViewModel = FavoriteLabViewModel()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension HomeViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        homeView.mypageButton.addTarget(self, action: #selector(info_Tapped), for: .touchUpInside)
        homeView.adCollectionView.delegate = self
        homeView.adCollectionView.dataSource = self
    }
    
    private func setAPI() {
        bindFavoriteBoardViewModel()
        bindHotPostViewModel()
        bindFavoriteLabViewModel()
//        favoriteBoardViewModel.loadFavoriteBoard()
//        hotPostViewModel.loadHotPost()
//        favoriteLabViewModel.loadFavoriteLab()
        favoriteBoardViewModel.loadTestData()
        hotPostViewModel.loadTestData()
        favoriteLabViewModel.loadTestData()
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
        
        // 데이터 변경 시 UI 자동 업데이트
        favoriteBoardViewModel.favoriteBoardList
            .bind(to: homeView.favBoardTableView.rx.items(cellIdentifier: FavoriteBoardTableViewCell.identifier, cellType: FavoriteBoardTableViewCell.self)) { row, board, cell in
                cell.prepare(favoriteBoard: board)
            }
            .disposed(by: disposeBag)
        
        // 에러 메시지 처리
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
        
        // 데이터 변경 시 UI 자동 업데이트
        hotPostViewModel.hotPostList
            .bind(to: homeView.hotPostTableView.rx.items(cellIdentifier: HotPostTableViewCell.identifier, cellType: HotPostTableViewCell.self)) { row, post, cell in
                cell.prepare(hotPost: post)
            }
            .disposed(by: disposeBag)
        
        // 에러 메시지 처리
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
        
        // 데이터 변경 시 UI 자동 업데이트
        favoriteLabViewModel.favoriteLabList
            .bind(to: homeView.favLabCollectionView.rx.items(cellIdentifier: FavoriteLabCollectionViewCell.identifier, cellType: FavoriteLabCollectionViewCell.self)) { row, lab, cell in
                cell.prepare(favoriteLab: lab)
            }
            .disposed(by: disposeBag)
        
        // 에러 메시지 처리
        favoriteLabViewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func scrollToTop() {
        homeView.scrollView.setContentOffset(CGPoint(x: 0, y: -homeView.scrollView.contentInset.top), animated: true)
    }
    
    @objc private func info_Tapped() {
        let mypageViewController = MypageViewController()
        self.navigationController?.pushViewController(mypageViewController, animated: true)
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
            
            // 현재 스크롤 위치에 따라 진행도 계산
            let progress = Float(contentOffsetX / (contentWidth - scrollViewWidth))
            
            // ProgressView 업데이트
            homeView.favLabProgressView.setProgress(progress, animated: true)
            
            // 컬렉션 뷰 끝에 도달했는지 확인
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

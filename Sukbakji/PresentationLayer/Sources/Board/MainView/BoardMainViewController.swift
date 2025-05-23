//
//  BoardMainViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoardMainViewController: UIViewController {
    
    private let boardMainView = BoardMainView()
    private let favoriteBoardViewModel = FavoriteBoardViewModel()
    private let boardViewModel = BoardViewModel()
    var disposeBag = DisposeBag()
    
    private var latestQnAHeightConstraint: Constraint?
    
    override func loadView() {
        self.view = boardMainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
        setAPI()
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        boardMainView.qnaContainerView.snp.makeConstraints { make in
            latestQnAHeightConstraint = make.height.equalTo(168).constraint
        }
        
        boardMainView.hotBoardButton.addTarget(self, action: #selector(hotPost_Tapped), for: .touchUpInside)
        boardMainView.myPostButton.addTarget(self, action: #selector(myPost_Tapped), for: .touchUpInside)
        boardMainView.scrapButton.addTarget(self, action: #selector(scrap_Tapped), for: .touchUpInside)
        boardMainView.myCommentButton.addTarget(self, action: #selector(myComment_Tapped), for: .touchUpInside)
    }
    
    private func setBind() {
        bindLatestQnAViewModel()
        bindFavoriteBoardViewModel()
    }
    
    private func setAPI() {
        boardViewModel.loadLatestQnA()
        favoriteBoardViewModel.loadFavoriteBoard()
    }
    
    private func bindLatestQnAViewModel() {
        self.boardMainView.qnaTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        boardViewModel.latestQnAList
            .subscribe(onNext: { latestQnAList in
                if !latestQnAList.isEmpty {
                    self.boardMainView.qnaContainerView.isHidden = false
                    self.boardMainView.noQnA.isHidden = true
                    self.boardMainView.noQnALabel.isHidden = true
                } else {
                    self.boardMainView.qnaContainerView.isHidden = true
                    self.boardMainView.noQnA.isHidden = false
                    self.boardMainView.noQnALabel.isHidden = false
                }
                
                if latestQnAList.count == 1 {
                    self.latestQnAHeightConstraint?.update(offset: 56)
                } else if latestQnAList.count == 2 {
                    self.latestQnAHeightConstraint?.update(offset: 112)
                }
            })
            .disposed(by: disposeBag)

        boardViewModel.latestQnAList
            .bind(to: boardMainView.qnaTableView.rx.items(cellIdentifier: BoardQnATableViewCell.identifier, cellType: BoardQnATableViewCell.self)) { row, qna, cell in
                cell.prepare(qna: qna)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindFavoriteBoardViewModel() {
        self.boardMainView.favBoardCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        favoriteBoardViewModel.favoriteBoardList
            .subscribe(onNext: { favoriteLabList in
                if !favoriteLabList.isEmpty {
                    self.boardMainView.noFavBoard.isHidden = true
                    self.boardMainView.noFavBoardLabel.isHidden = true
                    self.boardMainView.favBoardProgressView.isHidden = false
                } else {
                    self.boardMainView.noFavBoard.isHidden = false
                    self.boardMainView.noFavBoardLabel.isHidden = false
                    self.boardMainView.favBoardProgressView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        favoriteBoardViewModel.favoriteBoardList
            .bind(to: boardMainView.favBoardCollectionView.rx.items(cellIdentifier: FavoriteBoardCollectionViewCell.identifier, cellType: FavoriteBoardCollectionViewCell.self)) { row, board, cell in
                cell.prepare(favoriteBoard: board)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func hotPost_Tapped() {
        let postListVC = PostListViewController(title: "HOT 게시판", buttonTitle: "HOT 게시판 선정 기준 안내드립니다", isPost: 0, isHidden: true)
        self.navigationController?.pushViewController(postListVC, animated: true)
    }
    
    @objc private func myPost_Tapped() {
        let myPostVC = MyPostViewController(title: "내가 쓴 글", isPost: 0)
        self.navigationController?.pushViewController(myPostVC, animated: true)
    }
    
    @objc private func scrap_Tapped() {
        let myPostVC = MyPostViewController(title: "스크랩", isPost: 1)
        self.navigationController?.pushViewController(myPostVC, animated: true)
    }
    
    @objc private func myComment_Tapped() {
        let myPostVC = MyPostViewController(title: "댓글 단 글", isPost: 2)
        self.navigationController?.pushViewController(myPostVC, animated: true)
    }
}

extension BoardMainViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        let contentOffsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let scrollViewWidth = scrollView.frame.size.width
        let progress = Float(contentOffsetX / (contentWidth - scrollViewWidth))
        
        boardMainView.favBoardProgressView.setProgress(progress, animated: true)
        
        if contentOffsetX + scrollViewWidth >= contentWidth {
            boardMainView.favBoardProgressView.setProgress(1.0, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 147)
    }
}

extension BoardMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}

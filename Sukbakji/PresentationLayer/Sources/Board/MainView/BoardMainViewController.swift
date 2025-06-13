//
//  BoardMainController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoardMainViewController: UIViewController {
    
    private let boardView = BoardView()
    private let favBoardViewModel = FavBoardViewModel()
    private let boardViewModel = BoardViewModel()
    var disposeBag = DisposeBag()
    
    private var latestQnAHeightConstraint: Constraint?
    
    override func loadView() {
        self.view = boardView
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
        
        boardView.qnaContainerView.snp.makeConstraints { make in
            latestQnAHeightConstraint = make.height.equalTo(168).constraint
        }
        
        boardView.hotBoardButton.addTarget(self, action: #selector(hotPost_Tapped), for: .touchUpInside)
        boardView.myPostButton.addTarget(self, action: #selector(myPost_Tapped), for: .touchUpInside)
        boardView.scrapButton.addTarget(self, action: #selector(scrap_Tapped), for: .touchUpInside)
        boardView.myCommentButton.addTarget(self, action: #selector(myComment_Tapped), for: .touchUpInside)
        boardView.qnaButton.addTarget(self, action: #selector(qnaList_Tapped), for: .touchUpInside)
    }
    
    private func setBind() {
        bindLatestQnAViewModel()
        bindFavoriteBoardViewModel()
    }
    
    private func setAPI() {
        boardViewModel.loadLatestQnA()
        favBoardViewModel.loadFavoriteBoard()
    }
    
    private func bindLatestQnAViewModel() {
        self.boardView.qnaTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        boardViewModel.latestQnAList
            .subscribe(onNext: { latestQnAList in
                if !latestQnAList.isEmpty {
                    self.boardView.qnaContainerView.isHidden = false
                    self.boardView.noQnA.isHidden = true
                    self.boardView.noQnALabel.isHidden = true
                } else {
                    self.boardView.qnaContainerView.isHidden = true
                    self.boardView.noQnA.isHidden = false
                    self.boardView.noQnALabel.isHidden = false
                }
                
                if latestQnAList.count == 1 {
                    self.latestQnAHeightConstraint?.update(offset: 56)
                } else if latestQnAList.count == 2 {
                    self.latestQnAHeightConstraint?.update(offset: 112)
                }
            })
            .disposed(by: disposeBag)

        boardViewModel.latestQnAList
            .bind(to: boardView.qnaTableView.rx.items(cellIdentifier: BoardQnATableViewCell.identifier, cellType: BoardQnATableViewCell.self)) { row, qna, cell in
                cell.prepare(qna: qna)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindFavoriteBoardViewModel() {
        self.boardView.favBoardCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        favBoardViewModel.favBoardList
            .subscribe(onNext: { favoriteLabList in
                if !favoriteLabList.isEmpty {
                    self.boardView.noFavBoard.isHidden = true
                    self.boardView.noFavBoardLabel.isHidden = true
                    self.boardView.favBoardProgressView.isHidden = false
                } else {
                    self.boardView.noFavBoard.isHidden = false
                    self.boardView.noFavBoardLabel.isHidden = false
                    self.boardView.favBoardProgressView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        favBoardViewModel.favBoardList
            .bind(to: boardView.favBoardCollectionView.rx.items(cellIdentifier: FavoriteBoardCollectionViewCell.identifier, cellType: FavoriteBoardCollectionViewCell.self)) { row, board, cell in
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
    
    @objc private func qnaList_Tapped() {
        let postListVC = PostListViewController(title: "질문 게시판", buttonTitle: "게시판 내 개인정보 유추 금지와 관련하여 안내드립니다", isPost: 1, isHidden: false)
        self.navigationController?.pushViewController(postListVC, animated: true)
    }
}

extension BoardMainViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        let contentOffsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let scrollViewWidth = scrollView.frame.size.width
        let progress = Float(contentOffsetX / (contentWidth - scrollViewWidth))
        
        boardView.favBoardProgressView.setProgress(progress, animated: true)
        
        if contentOffsetX + scrollViewWidth >= contentWidth {
            boardView.favBoardProgressView.setProgress(1.0, animated: true)
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

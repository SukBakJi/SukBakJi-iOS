//
//  BoardFreeViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoardFreeViewController: UIViewController, FavBoardCellDelegate {
    
    private let boardFreeView = BoardFreeView()
    private let favScrapViewModel = FavScrapViewModel()
    var disposeBag = DisposeBag()
    
    private var favBoardHeightConstraint: Constraint?
    
    override func loadView() {
        self.view = boardFreeView
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
        
        boardFreeView.favBoardView.snp.makeConstraints { make in
            favBoardHeightConstraint = make.height.equalTo(121).constraint
        }
        
        boardFreeView.makeBoardButton.addTarget(self, action: #selector(create_Tapped), for: .touchUpInside)
    }
    
    private func setAPI() {
        favScrapViewModel.loadBoardsFavorite()
    }
    
    private func setBind() {
        self.boardFreeView.freeFavoriteBoardTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        favScrapViewModel.boardsFavoriteList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                if list.count > 0 {
                    self.favBoardHeightConstraint?.update(offset: (CGFloat(list.count) * 60) + 61)
                    boardFreeView.noFavBoard.isHidden = true
                    boardFreeView.noFavBoardLabel.isHidden = true
                    boardFreeView.favBoardLabel.isHidden = false
                    boardFreeView.favBoardImageView.isHidden = false
                } else {
                    self.favBoardHeightConstraint?.update(offset: 150)
                    boardFreeView.noFavBoard.isHidden = false
                    boardFreeView.noFavBoardLabel.isHidden = false
                    boardFreeView.favBoardLabel.isHidden = true
                    boardFreeView.favBoardImageView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        favScrapViewModel.boardsFavoriteList
            .bind(to: boardFreeView.freeFavoriteBoardTableView.rx.items(cellIdentifier: FreeFavBoardTableViewCell.identifier, cellType: FreeFavBoardTableViewCell.self)) { row, favorite, cell in
                cell.prepare(favorite: favorite)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
    }
    
    func fav_Tapped(cell: FreeFavBoardTableViewCell) {
        guard let indexPath = boardFreeView.freeFavoriteBoardTableView.indexPath(for: cell) else { return }
        let boardId = favScrapViewModel.boardsFavoriteList.value[indexPath.row].boardId
        favScrapViewModel.favoriteBoard(boardId: boardId, isFav: false)
    }
    
    func more_Tapped(cell: FreeFavBoardTableViewCell) {
        guard let indexPath = boardFreeView.freeFavoriteBoardTableView.indexPath(for: cell) else { return }
        let boardName = favScrapViewModel.boardsFavoriteList.value[indexPath.row].boardName
        let postListVC = PostListViewController(title: boardName, buttonTitle: "게시판 공지", isPost: 2, isHidden: true)
        self.navigationController?.pushViewController(postListVC, animated: true)
    }
    
    @objc private func create_Tapped() {
        let viewController = BoardCreateViewController()
        let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 520, bottomSheetPanMinTopConstant: 230, isPannedable: true)
        self.present(bottomSheetVC, animated: true)
    }
}

extension BoardFreeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

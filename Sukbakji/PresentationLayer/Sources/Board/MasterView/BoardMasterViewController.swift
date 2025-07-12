//
//  BoardMasterViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoardMasterViewController: UIViewController {
    
    private let boardMasterView = BoardMasterView()
    private let boardViewModel = BoardViewModel()
    private let postViewModel = PostViewModel()
    var disposeBag = DisposeBag()
    
    private var isModelBound = false
    
    override func loadView() {
        self.view = boardMasterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBind()
        setAPI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setBind() {
        bindBoardsMenuModel()
        bindBoardsPostModel()
    }
    
    private func setAPI() {
        boardViewModel.loadMasterMenu()
        postViewModel.loadMasterPostList(boardName: "질문 게시판")
    }
    
    private func bindBoardsMenuModel() {
        self.boardMasterView.masterMenuCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        boardViewModel.masterMenuList
            .do(onNext: { [weak self] menus in
                if let first = menus.first {
                    self?.boardViewModel.selectMasterMenu(first)
                }
            })
            .bind(to: boardMasterView.masterMenuCollectionView.rx.items(cellIdentifier: MasterMenuCollectionViewCell.identifier, cellType: MasterMenuCollectionViewCell.self)) { row, menu, cell in
                cell.prepare(text: menu)
                
                self.boardViewModel.selectMasterMenuItem
                    .map { $0 == menu }
                    .bind(to: cell.isSelectedCell)
                    .disposed(by: cell.disposeBag)
                
                cell.labelButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        self.boardViewModel.selectMasterMenu(menu)
                        boardMasterView.changeColor(menu)
                        postViewModel.loadMasterPostList(boardName: menu)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindBoardsPostModel() {
        self.boardMasterView.masterPostTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        postViewModel.postMasterList
            .bind(to: boardMasterView.masterPostTableView.rx.items(cellIdentifier: MasterPostTableViewCell.identifier, cellType: MasterPostTableViewCell.self)) { row, post, cell in
                cell.prepare(post: post)
            }
            .disposed(by: disposeBag)
    }
}

extension BoardMasterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items = boardViewModel.masterMenuList.value
        let leng = items[indexPath.item].count
        
        return CGSize(width: 10 + leng * 10, height: 52)
    }
}

extension BoardMasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
}

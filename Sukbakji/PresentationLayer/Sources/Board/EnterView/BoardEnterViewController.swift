//
//  BoardEnterViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoardEnterViewController: UIViewController {
    
    private let boardEnterView = BoardEnterView()
    private let boardViewModel = BoardViewModel()
    private let postViewModel = PostViewModel()
    var disposeBag = DisposeBag()
    
    private var isModelBound = false
    
    override func loadView() {
        self.view = boardEnterView
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
        
        boardEnterView.writingButton.addTarget(self, action: #selector(writing_Tapped), for: .touchUpInside)
    }
    
    private func setBind() {
        bindBoardsMenuModel()
        bindBoardsPostModel()
    }
    
    private func setAPI() {
        boardViewModel.loadEnterMenu()
        postViewModel.loadEnterPostList(boardName: "질문 게시판")
    }
    
    private func bindBoardsMenuModel() {
        self.boardEnterView.enterMenuCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        boardViewModel.enterMenuList
            .do(onNext: { [weak self] menus in
                if let first = menus.first {
                    self?.boardViewModel.selectEnterMenu(first)
                }
            })
            .bind(to: boardEnterView.enterMenuCollectionView.rx.items(cellIdentifier: EnterMenuCollectionViewCell.identifier, cellType: EnterMenuCollectionViewCell.self)) { row, menu, cell in
                cell.prepare(text: menu)
                
                self.boardViewModel.selectEnterMenuItem
                    .map { $0 == menu }
                    .bind(to: cell.isSelectedCell)
                    .disposed(by: cell.disposeBag)
                
                cell.labelButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        self.boardViewModel.selectEnterMenu(menu)
                        boardEnterView.changeColor(menu)
                        postViewModel.loadEnterPostList(boardName: menu)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindBoardsPostModel() {
        self.boardEnterView.enterPostTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        postViewModel.postEnterList
            .bind(to: boardEnterView.enterPostTableView.rx.items(cellIdentifier: EnterPostTableViewCell.identifier, cellType: EnterPostTableViewCell.self)) { row, post, cell in
                cell.prepare(post: post)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func writing_Tapped() {
        let postWritingViewController = PostWritingViewController()
        self.navigationController?.pushViewController(postWritingViewController, animated: true)
    }
}

extension BoardEnterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items = boardViewModel.enterMenuList.value
        let leng = items[indexPath.item].count
        
        return CGSize(width: 10 + leng * 10, height: 52)
    }
}

extension BoardEnterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
}

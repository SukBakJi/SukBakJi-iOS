//
//  BoardDoctorViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoardDoctorViewController: UIViewController {
    
    private let boardDoctorView = BoardDoctorView()
    private let boardViewModel = BoardViewModel()
    private let postViewModel = PostViewModel()
    var disposeBag = DisposeBag()
    
    private var isModelBound = false
    
    override func loadView() {
        self.view = boardDoctorView
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
        boardViewModel.loadDoctorMenu()
        postViewModel.loadDoctorPostList(boardName: "질문 게시판")
    }

    private func bindBoardsMenuModel() {
        self.boardDoctorView.doctorMenuCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        boardViewModel.doctorMenuList
            .do(onNext: { [weak self] menus in
                if let first = menus.first {
                    self?.boardViewModel.selectDoctorMenu(first)
                }
            })
            .bind(to: boardDoctorView.doctorMenuCollectionView.rx.items(cellIdentifier: DoctorMenuCollectionViewCell.identifier, cellType: DoctorMenuCollectionViewCell.self)) { row, menu, cell in
                cell.prepare(text: menu)
                
                self.boardViewModel.selectDoctorMenuItem
                    .map { $0 == menu }
                    .bind(to: cell.isSelectedCell)
                    .disposed(by: cell.disposeBag)
                
                cell.labelButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        self.boardViewModel.selectDoctorMenu(menu)
                        boardDoctorView.changeColor(menu)
                        postViewModel.loadDoctorPostList(boardName: menu)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindBoardsPostModel() {
        self.boardDoctorView.doctorPostTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        postViewModel.postDocterList
            .bind(to: boardDoctorView.doctorPostTableView.rx.items(cellIdentifier: DoctorPostTableViewCell.identifier, cellType: DoctorPostTableViewCell.self)) { row, post, cell in
                cell.prepare(post: post)
            }
            .disposed(by: disposeBag)
    }
}

extension BoardDoctorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items = boardViewModel.doctorMenuList.value
        let leng = items[indexPath.item].count
        
        return CGSize(width: 10 + leng * 10, height: 52)
    }
}

extension BoardDoctorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
}

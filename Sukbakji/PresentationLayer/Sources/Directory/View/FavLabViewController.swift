//
//  FavLabViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 6/15/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FavLabViewController: UIViewController {
    
    private let favLabView = FavLabView()
    private let viewModel = FavLabViewModel()
    private let disposeBag = DisposeBag()
    
    var isGrouped: Bool = false

    override func loadView() {
        self.view = favLabView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        bindViewModel()
        setAPI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        favLabView.navigationbarView.delegate = self
        
        favLabView.editButton.addTarget(self, action: #selector(toggle_Tapped), for: .touchUpInside)
    }
}

extension FavLabViewController {
    private func setAPI() {
        viewModel.loadFavoriteLab()
    }
    
    private func bindViewModel() {
        favLabView.favLabTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.favLabList
            .subscribe(onNext: { favLabList in
                self.favLabView.allSelectLabel.text = "전체선택 (0/\(favLabList.count))"
            })
            .disposed(by: disposeBag)
        
        viewModel.favLabList
            .bind(to: favLabView.favLabTableView.rx.items(cellIdentifier: FavLabTableViewCell.identifier, cellType: FavLabTableViewCell.self)) { row, lab, cell in
                cell.prepare(favoriteLab: lab, showButton: self.isGrouped)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func toggle_Tapped() {
        isGrouped.toggle()
        let newTitle = isGrouped ? "취소" : "수정"
        favLabView.editButton.setTitle(newTitle, for: .normal)
        favLabView.favLabTableView.reloadData()
    }
}

extension FavLabViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

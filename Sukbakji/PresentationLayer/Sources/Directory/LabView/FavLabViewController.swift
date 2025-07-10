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

class FavLabViewController: UIViewController, FavLabCellDelegate {

    private let favLabView = FavLabView()
    private let viewModel = FavLabViewModel()
    private let disposeBag = DisposeBag()
    
    private var labIds: [Int] = []
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
                cell.delegate = self
                
                self.viewModel.selectedLabAll
                    .bind { isSelected in
                        let imageName = isSelected ? "Sukbakji_Check2" : "Sukbakji_Check"
                        cell.selectButton.setImage(UIImage(named: imageName), for: .normal)
                        self.favLabView.allSelectButton.setImage(UIImage(named: imageName), for: .normal)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        favLabView.favLabTableView.rx.modelSelected(FavoriteLab.self)
            .subscribe(onNext: { [weak self] labItem in
                guard let self = self else { return }
                let labVC = LabViewController(labId: labItem.labId)
                self.navigationController?.pushViewController(labVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        favLabView.allSelectButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.toggleSelectState()
            }
            .disposed(by: disposeBag)
    }
    
    func select_Tapped(cell: FavLabTableViewCell) {
        guard let indexPath = favLabView.favLabTableView.indexPath(for: cell) else { return }
        let labId = viewModel.favLabList.value[indexPath.row].labId
        
        if labIds.contains(labId) {
            labIds.removeAll { $0 == labId }
        } else {
            labIds.append(labId)
        }
        
        updateUIForSelectedCells()
    }
    
    private func updateUIForSelectedCells() {
        for (index, lab) in viewModel.favLabList.value.enumerated() {
            guard let cell = favLabView.favLabTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FavLabTableViewCell else { continue }
            let labId = lab.labId
            
            if labIds.contains(labId) {
                cell.selectButton.setImage(UIImage(named: "Sukbakji_Check2"), for: .normal)
            } else {
                cell.selectButton.setImage(UIImage(named: "Sukbakji_Check"), for: .normal)
            }
        }
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

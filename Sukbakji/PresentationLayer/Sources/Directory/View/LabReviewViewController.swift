//
//  LabReviewViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 6/14/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LabReviewViewController: UIViewController {
    
    private let labReviewView = LabReviewView()
    private let viewModel = DirectoryViewModel()
    private let disposeBag = DisposeBag()
    private var offset:Int = 3
    
    private var reviewHeightConstraint: Constraint?
    
    override func loadView() {
        self.view = labReviewView
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
            tabBarVC.customTabBarView.isHidden = false
        }
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        labReviewView.navigationbarView.delegate = self
        
        labReviewView.reviewView.snp.makeConstraints { make in
            reviewHeightConstraint = make.height.equalTo(516).constraint
        }
        
        labReviewView.moreButton.addTarget(self, action: #selector(more_Tapped), for: .touchUpInside)
    }
}

extension LabReviewViewController {
    private func setAPI() {
        viewModel.loadReviewList(offset: 0, limit: 3)
    }
    
    private func bindViewModel() {
        labReviewView.labReviewTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reviewList
            .bind(to: labReviewView.labReviewTableView.rx.items(cellIdentifier: LabReviewTableViewCell.identifier, cellType: LabReviewTableViewCell.self)) { row, review, cell in
                cell.prepare(review: review)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func more_Tapped() {
        if offset < 7 {
            viewModel.loadReviewList(offset: Int32(offset), limit: 2)
            reviewHeightConstraint?.update(offset: 516 + 145 * offset)
            offset += 2
        }
    }
}

extension LabReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}

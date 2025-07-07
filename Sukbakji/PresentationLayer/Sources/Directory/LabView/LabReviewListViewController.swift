//
//  LabReviewListViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 6/14/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LabReviewListViewController: UIViewController {
    
    private let labReviewListView = LabReviewListView()
    private let viewModel = DirectoryViewModel()
    private let disposeBag = DisposeBag()
    private var offset:Int = 1
    
    private var reviewHeightConstraint: Constraint?
    
    override func loadView() {
        self.view = labReviewListView
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
        labReviewListView.navigationbarView.delegate = self
        
        labReviewListView.reviewView.snp.makeConstraints { make in
            reviewHeightConstraint = make.height.equalTo(516).constraint
        }
        
        labReviewListView.moreButton.addTarget(self, action: #selector(more_Tapped), for: .touchUpInside)
    }
}

extension LabReviewListViewController {
    private func setAPI() {
        viewModel.loadReviewList(offset: 0, limit: 3)
    }
    
    private func bindViewModel() {
        labReviewListView.labReviewTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reviewList
            .bind(to: labReviewListView.labReviewTableView.rx.items(cellIdentifier: LabReviewListTableViewCell.identifier, cellType: LabReviewListTableViewCell.self)) { row, review, cell in
                cell.prepare(review: review)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func more_Tapped() {
        viewModel.loadReviewList(offset: Int32(offset), limit: 3)
        reviewHeightConstraint?.update(offset: 516 + 145 * (offset * 3))
        offset += 1
    }
}

extension LabReviewListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}

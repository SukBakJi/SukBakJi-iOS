//
//  LabReviewViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/2/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LabReviewViewController: UIViewController {
    
    private let labReviewView = LabReviewView()
    private let viewModel = LabViewModel()
    private let disposeBag = DisposeBag()
    var labId: Int = 0
    
    private var reviewHeightConstraint: Constraint?
    
    init(labId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.labId = labId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = labReviewView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        labReviewView.reviewView.snp.makeConstraints { make in
            reviewHeightConstraint = make.height.equalTo(516).constraint
        }
    }
    
    private func setAPI() {
        bindViewModel()
        viewModel.loadLabDetail(labId: labId)
    }
    
    private func bindViewModel() {
        viewModel.labDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] lab in
                self?.viewModel.reviewItems.accept(lab.review)
                self?.setReviewData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setReviewData() {
        labReviewView.labReviewTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reviewItems
            .subscribe(onNext: { review in
                self.reviewHeightConstraint?.update(offset: 61 + 153 * review.count)
            })
            .disposed(by: disposeBag)

        viewModel.reviewItems
            .observe(on: MainScheduler.instance)
            .bind(to: labReviewView.labReviewTableView.rx.items(cellIdentifier: LabReviewTableViewCell.identifier, cellType: LabReviewTableViewCell.self)) { index, item, cell in
                cell.prepare(review: item)
            }
            .disposed(by: disposeBag)
    }
}

extension LabReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}

//
//  DirectoryViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 6/13/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DirectoryViewController: UIViewController {

    private let directoryView = DirectoryView()
    private let favLabViewModel = FavLabViewModel()
    private let viewModel = DirectoryViewModel()
    private let disposeBag = DisposeBag()
    
    private var favLabHeightConstraint: Constraint?
    
    override func loadView() {
        self.view = directoryView
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
        
        directoryView.favLabView.snp.makeConstraints { make in
            favLabHeightConstraint = make.height.equalTo(187).constraint
        }
        
        directoryView.favLabButton.addTarget(self, action: #selector(fav_Tapped), for: .touchUpInside)
        directoryView.reviewButton.addTarget(self, action: #selector(review_Tapped), for: .touchUpInside)
    }
}

extension DirectoryViewController {
    
    private func setAPI() {
        favLabViewModel.loadFavoriteLab()
        viewModel.loadInterestTopic()
        viewModel.loadReviewList(offset: 0, limit: 3)
    }
    
    private func bindViewModel() {
        directoryView.favLabCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        directoryView.labReviewCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        favLabViewModel.favLabList
            .subscribe(onNext: { favLabList in
                if !favLabList.isEmpty {
                    self.directoryView.noFavLab.isHidden = true
                    self.directoryView.noFavLabLabel.isHidden = true
                    self.favLabHeightConstraint?.update(offset: 245)
                } else {
                    self.directoryView.noFavLab.isHidden = false
                    self.directoryView.noFavLabLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        favLabViewModel.favLabList
            .bind(to: directoryView.favLabCollectionView.rx.items(cellIdentifier: FavoriteLabCollectionViewCell.identifier, cellType: FavoriteLabCollectionViewCell.self)) { row, lab, cell in
                cell.prepare(favoriteLab: lab)
            }
            .disposed(by: disposeBag)
        viewModel.topicList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] topic in
                self?.viewModel.topicItems.accept(topic.topics)
                self?.setTopicData()
            })
            .disposed(by: disposeBag)
        viewModel.reviewList
            .bind(to: directoryView.labReviewCollectionView.rx.items(cellIdentifier: LabReviewCollectionViewCell.identifier, cellType: LabReviewCollectionViewCell.self)) { row, review, cell in
                cell.prepare(review: review)
            }
            .disposed(by: disposeBag)
    }
    
    private func setTopicData() {
        directoryView.topicCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        viewModel.topicItems
            .observe(on: MainScheduler.instance)
            .bind(to: directoryView.topicCollectionView.rx.items(cellIdentifier: TopicCollectionViewCell.identifier, cellType: TopicCollectionViewCell.self)) { row, topic, cell in
                cell.prepare(topics: topic)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func fav_Tapped() {
        let favLabVC = FavLabViewController()
        self.navigationController?.pushViewController(favLabVC, animated: true)
    }
    
    @objc private func review_Tapped() {
        let labReviewVC = LabReviewViewController()
        self.navigationController?.pushViewController(labReviewVC, animated: true)
    }
}

extension DirectoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items = viewModel.topicItems.value
        
        if collectionView == directoryView.favLabCollectionView {
            return CGSize(width: 300, height: 172)
        } else if collectionView == directoryView.topicCollectionView {
            guard indexPath.item < items.count else {
                return CGSize(width: 40, height: 29) // 기본 사이즈 반환
            }
            let label = UILabel().then {
                $0.text = String(items[indexPath.item])
                $0.sizeToFit()
            }
            let size = label.frame.size
            return CGSize(width: size.width + 22, height: 29)
        } else {
            return CGSize(width: 342, height: 145)
        }
    }
}

//
//  LabInfoViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/2/25.
//

import UIKit
import RxSwift
import RxCocoa

class LabInfoViewController: UIViewController {
    
    private let labInfoView = LabInfoView()
    private let viewModel = LabViewModel()
    private let disposeBag = DisposeBag()
    var labId: Int = 0
    
    init(labId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.labId = labId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = labInfoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
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
    
    private func setAPI() {
        bindViewModel()
        viewModel.loadLabInfo(labId: labId)
    }
    
    private func bindViewModel() {
        viewModel.labInfo
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] lab in
                self?.viewModel.researchTopicItems.accept(lab.researchTopics)
                self?.labInfoView.nameLabel.text = lab.professorName
                self?.labInfoView.univLabel.text = lab.universityName
                self?.labInfoView.departmentLabel.text = lab.departmentName
                self?.labInfoView.educationLabel2.text = "\(lab.universityName) \(lab.departmentName) 박사"
                self?.labInfoView.emailLabel2.text = lab.professorEmail
                self?.labInfoView.pageLabel2.text = lab.labLink
                self?.setTopicData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setTopicData() {
        labInfoView.labTopicCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        self.viewModel.researchTopicItems
            .observe(on: MainScheduler.instance)
            .bind(to: labInfoView.labTopicCollectionView.rx.items(cellIdentifier: LabTopicCollectionViewCell.identifier, cellType: LabTopicCollectionViewCell.self)) { index, item, cell in
                cell.prepare(topics: item)
            }
            .disposed(by: disposeBag)
    }
}

extension LabInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items = viewModel.researchTopicItems.value
        guard indexPath.item < items.count else {
            return CGSize(width: 40, height: 29) // 기본 사이즈 반환
        }
        
        let label = UILabel().then {
            $0.text = "#\(items[indexPath.item])"
            $0.sizeToFit()
        }
        let size = label.frame.size
        
        return CGSize(width: size.width + 22, height: 29)
    }
}

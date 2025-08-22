//
//  EditInfoViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit
import DropDown
import SnapKit
import RxSwift
import RxCocoa

class EditInfoViewController: UIViewController {
    
    private let editInfoView = EdifInfoView()
    private let viewModel = MyProfileViewModel()
    private let disposeBag = DisposeBag()
    private lazy var drop: DropDown = DropDownFactory.make(anchor: editInfoView.belongTextField)
    private var didSetupDropDowns = false
    
    private var degree: String = ""
    private var topics: [String] = []
    private let belongType = BehaviorRelay<[String]>(value: ["학사 재학 중", "학사 졸업", "석사 재학 중", "석사 졸업", "박사 재학 중", "박사 졸업", "석박사 통합 재학"])
    private let degreeMapping: [String: String] = [
        "학사 재학 중": "BACHELORS_STUDYING",
        "학사 졸업": "BACHELORS_GRADUATED",
        "석사 재학 중": "MASTERS_STUDYING",
        "석사 졸업": "MASTERS_GRADUATED",
        "박사 재학 중": "DOCTORAL_STUDYING",
        "박사 졸업": "DOCTORAL_GRADUATED",
        "석박사 통합 재학": "INTEGRATED_STUDYING"
    ]
    
    override func loadView() {
        self.view = editInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didSetupDropDowns {
            view.layoutIfNeeded()
            setDropdown()
            didSetupDropDowns = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
}

extension EditInfoViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        editInfoView.editButton.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        editInfoView.plusButton.addTarget(self, action: #selector(plusButton_Tapped), for: .touchUpInside)
    }

    private func setDropdown() {
        drop.selectionAction = { [weak self] _, item in
            self?.handleSelection(for: item)
        }
    }

    private func handleSelection(for item: String) {
        editInfoView.belongTextField.text = item
        degree = degreeMapping[item] ?? "BACHELORS_STUDYING"
    }
}
    
extension EditInfoViewController {
    
    private func setAPI() {
        bindViewModel()
        viewModel.loadMyProfile()
    }
    
    private func setTopicData() {
        editInfoView.researchTopicCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        /// CollectionView에 들어갈 Cell에 정보 제공
        self.viewModel.researchTopicItems
            .observe(on: MainScheduler.instance)
            .bind(to: editInfoView.researchTopicCollectionView.rx.items(cellIdentifier: ResearchTopicCollectionViewCell.identifier, cellType: ResearchTopicCollectionViewCell.self)) { index, item, cell in
                cell.prepare(topics: item)
                self.updateCollectionViewHeight()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        guard let retrievedEmail = KeychainHelper.standard.read(service: "email", account: "user") else {
            return
        }
        
        viewModel.myProfile
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] profile in
                self?.viewModel.researchTopicItems.accept(profile.researchTopics)
                self?.topics = profile.researchTopics
                self?.degree = profile.degreeLevel ?? ""
                if profile.provider == "APPLE" {
                    self?.editInfoView.logingImageView.image = UIImage(named: "Sukbakji_Apple")
                    self?.editInfoView.logingLabel.text = "애플 로그인으로 사용 중이에요"
                } else if profile.provider == "KAKAO" {
                    self?.editInfoView.logingImageView.image = UIImage(named: "Sukbakji_Kakao")
                    self?.editInfoView.logingLabel.text = "카카오 로그인으로 사용 중이에요"
                }
                self?.editInfoView.idTextField.text = retrievedEmail
                self?.editInfoView.nameTextField.text = profile.name
                self?.editInfoView.belongTextField.text = DegreeLevel.from(profile.degreeLevel)?.korean ?? "학위 정보 없음"
                self?.setTopicData()
            })
            .disposed(by: disposeBag)
        
        viewModel.profileUpdated
            .subscribe(onNext: { [weak self] success in
                if success {
                    AlertController(message: "프로필이 성공적으로 업데이트되었습니다.") {
                        self?.navigationController?.popViewController(animated: true)
                    }.show()
                }
            })
            .disposed(by: disposeBag)
        
        belongType
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in self?.drop.dataSource = $0 })
            .disposed(by: disposeBag)
        
        editInfoView.dropButton.rx.tap
            .bind(onNext: { [weak self] in self?.drop.show() })
            .disposed(by: disposeBag)
    }
    
    func calculateCollectionViewHeight() -> CGFloat {
        editInfoView.researchTopicCollectionView.layoutIfNeeded()
        let contentHeight = editInfoView.researchTopicCollectionView.collectionViewLayout.collectionViewContentSize.height
        return contentHeight + 3
    }
    
    func updateCollectionViewHeight() {
        let height = calculateCollectionViewHeight()
        editInfoView.researchTopicCollectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    @objc private func plusButton_Tapped() {
        let selectResearchTopicVC = SelectResearchTopicViewController()
        
        selectResearchTopicVC.selectedTags = topics
        selectResearchTopicVC.completionHandler = { [weak self] data in
            self?.viewModel.researchTopicItems.accept(data)
            self?.topics = data
            self?.editInfoView.researchTopicCollectionView.reloadData()
            self?.updateCollectionViewHeight()
            print("받은 데이터 : \(data)")
        }

        let navController = UINavigationController(rootViewController: selectResearchTopicVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    @objc private func updateProfile() {
        viewModel.loadEditProfile(degree: degree, topics: topics)
    }
}

extension EditInfoViewController: UICollectionViewDelegateFlowLayout {
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

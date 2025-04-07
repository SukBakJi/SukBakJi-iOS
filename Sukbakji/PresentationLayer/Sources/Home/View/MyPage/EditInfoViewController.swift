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
    private let researchTopicViewModel = ResearchTopicViewModel()
    private let disposeBag = DisposeBag()
    private let drop = DropDown()
    
    private var degree: String = ""
    private var topics: [String] = []
    private let belongType = ["학사 재학 중", "학사 졸업", "석사 재학 중", "석사 졸업", "박사 재학 중", "박사 졸업"]
    private let degreeMapping: [String: String] = [
        "학사 재학 중": "BACHELORS_STUDYING",
        "학사 졸업": "BACHELORS_GRADUATED",
        "석사 재학 중": "MASTERS_STUDYING",
        "석사 졸업": "MASTERS_GRADUATED",
        "박사 재학 중": "DOCTORAL_STUDYING",
        "박사 졸업": "DOCTORAL_GRADUATED"
    ]
    
    override func loadView() {
        self.view = editInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDrop()
        setAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension EditInfoViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
 
        editInfoView.dropButton.addTarget(self, action: #selector(drop_Tapped), for: .touchUpInside)
        editInfoView.editButton.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        editInfoView.plusButton.addTarget(self, action: #selector(plusButton_Tapped), for: .touchUpInside)
    }
    
    private func setDrop() {
        initUI()
        setDropdown()
    }
    
    private func initUI() {
        DropDown.appearance().textColor = .gray900 // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = .orange700 // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = .gray50 // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = .orange50 // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(5)
        DropDown.appearance().setupMaskedCorners(CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner))
        drop.dismissMode = .automatic // 팝업을 닫을 모드 설정
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 12)
    }
    
    private func setDropdown() {
        configureDropdownAppearance()
        configureDropdownSelection()
    }

    private func configureDropdownAppearance() {
        drop.dataSource = belongType
        drop.cellHeight = 44
        drop.anchorView = self.editInfoView.belongTextField
        drop.bottomOffset = CGPoint(x: 0, y: 45.5 + editInfoView.belongTextField.bounds.height)
        drop.shadowColor = .clear
        
        drop.cellConfiguration = { _, item in
            return "  \(item)" // 앞에 4칸 공백 추가
        }
        
        drop.customCellConfiguration = { [weak self] index, item, cell in
            self?.setupSeparator(for: cell, at: index)
        }
    }

    private func configureDropdownSelection() {
        drop.selectionAction = { [weak self] _, item in
            self?.handleSelection(for: item)
        }
        
        drop.cancelAction = { [weak self] in
            self?.editInfoView.belongTextField.text = "학사 졸업 또는 재학"
        }
    }

    private func handleSelection(for item: String) {
        editInfoView.belongTextField.text = item
        degree = degreeMapping[item] ?? "BACHELORS_STUDYING"
    }

    private func setupSeparator(for cell: DropDownCell, at index: Int) {
        guard index != drop.dataSource.count - 1 else { return }
        
        let separator = UIView()
        separator.backgroundColor = .gray300
        separator.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.5)
        ])
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
        self.researchTopicViewModel.ResearchTopicItems
            .observe(on: MainScheduler.instance)
            .bind(to: editInfoView.researchTopicCollectionView.rx.items(cellIdentifier: ResearchTopicCollectionViewCell.identifier, cellType: ResearchTopicCollectionViewCell.self)) { index, item, cell in
                cell.prepare(topics: item)
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
                self?.researchTopicViewModel.ResearchTopicItems.accept(profile.researchTopics)
                self?.topics = profile.researchTopics
                self?.degree = profile.degreeLevel
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
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                AlertController(message: message).show()
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
        
        viewModel.errorMessage
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
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
            self?.researchTopicViewModel.ResearchTopicItems.accept(data)
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
        print(degree)
        print(topics)
    }
    
    @objc private func drop_Tapped() {
        drop.show()
    }
}

extension EditInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items = researchTopicViewModel.ResearchTopicItems.value
        guard indexPath.item < items.count else {
            return CGSize(width: 40, height: 29) // 기본 사이즈 반환
        }
            
        let str = items[indexPath.item]
        let width = 40 + str.count * 12
        return CGSize(width: CGFloat(width), height: 29)
    }
}

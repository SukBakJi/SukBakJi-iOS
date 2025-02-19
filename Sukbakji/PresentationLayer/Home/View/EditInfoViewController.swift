//
//  EditInfoViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit
import DropDown
import Alamofire
import SnapKit
import Then
import RxSwift
import RxCocoa

class EditInfoViewController: UIViewController {
    
    let researchTopicViewModel = ResearchTopicViewModel()
    
    private let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let idTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray300
    }
    private let logingImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Kakao")
    }
    private let logingLabel = UILabel().then {
        $0.text = "카카오 로그인으로 사용 중이에요"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .gray900
    }
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let nameTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray300
    }
    private let belongLabel = UILabel().then {
        $0.text = "현재 소속"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let belongTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    private let dropButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Down2"), for: .normal)
    }
    private let certificateView = UIView().then {
        $0.backgroundColor = .gray50
    }
    private let certificateLabel = UILabel().then {
        $0.text = "현재 학사 재학으로 학력인증이\n완료된 상태입니다"
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray600
    }
    private let certificateButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("새로 인증하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(.orange700, for: .normal)
    }
    private let researchLabel = UILabel().then {
        $0.text = "연구 주제"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private var researchTopicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ResearchTopicCollectionViewCell.self, forCellWithReuseIdentifier: ResearchTopicCollectionViewCell.identifier)
        cv.allowsSelection = false
        cv.backgroundColor = .clear
        
        return cv
    }()
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray300
    }
    private let plusButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_plusButton"), for: .normal)
    }
    private let editButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("수정하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.orange700, for: .normal)
    }
    
    private let disposeBag = DisposeBag()
    
    private var degreeLevel: String?
    
    private let drop = DropDown()
    private let belongType = ["학사 재학 중", "학사 졸업", "석사 재학 중", "석사 졸업", "박사 재학 중", "박사 졸업"]
    
    private let degreeMapping: [String: String] = [
        "학사 재학 중": "BACHELORS_STUDYING",
        "학사 졸업": "BACHELORS_GRADUATED",
        "석사 재학 중": "MASTERS_STUDYING",
        "석사 졸업": "MASTERS_GRADUATED",
        "박사 재학 중": "DOCTORAL_STUDYING",
        "박사 졸업": "DOCTORAL_GRADUATED"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDrop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        //        setProfileAPI()
    }
}
    
extension EditInfoViewController {
    
    private func setDrop() {
        initUI()
        setDropdown()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(66)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.view.addSubview(idTextField)
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        idTextField.addTFUnderline()
        idTextField.setLeftPadding(15)
        
        self.view.addSubview(logingImageView)
        logingImageView.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(6)
            make.leading.equalToSuperview().inset(24)
            make.height.width.equalTo(16)
        }
        
        self.view.addSubview(logingLabel)
        logingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logingImageView)
            make.leading.equalTo(logingImageView.snp.trailing).offset(6)
            make.height.equalTo(12)
        }
        
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(logingImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        nameTextField.addTFUnderline()
        nameTextField.setLeftPadding(15)
        
        self.view.addSubview(belongLabel)
        belongLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        belongLabel.addImageAboveLabel(referenceView: nameTextField, spacing: 20)
        
        self.view.addSubview(belongTextField)
        belongTextField.snp.makeConstraints { make in
            make.top.equalTo(belongLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        belongTextField.addTFUnderline()
        belongTextField.setLeftPadding(15)
        belongTextField.isEnabled = false
        
        self.view.addSubview(dropButton)
        dropButton.snp.makeConstraints { make in
            make.top.equalTo(belongLabel.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(24)
            make.height.width.equalTo(44)
        }
        dropButton.addTarget(self, action: #selector(drop_Tapped), for: .touchUpInside)
        
        self.view.addSubview(certificateView)
        certificateView.snp.makeConstraints { make in
            make.top.equalTo(belongTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(84)
        }
        
        self.certificateView.addSubview(certificateLabel)
        certificateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
        }
        let fullText = certificateLabel.text ?? ""
        let changeText = "학사 재학"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        certificateLabel.attributedText = attributedString
        
        self.certificateView.addSubview(certificateButton)
        certificateButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(120)
        }
        
        self.view.addSubview(researchLabel)
        researchLabel.snp.makeConstraints { make in
            make.top.equalTo(certificateView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        researchLabel.addImageAboveLabel(referenceView: belongTextField, spacing: 124)
        
        self.view.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(researchLabel.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(22)
            make.width.equalTo(44)
        }
        
        self.view.addSubview(researchTopicCollectionView)
        researchTopicCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(plusButton)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalTo(plusButton.snp.leading).inset(8)
            make.height.equalTo(45)
        }
        
        self.view.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(plusButton.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(1.2)
        }
        
        self.view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        editButton.addTarget(self, action: #selector(edit_Tapped), for: .touchUpInside)
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
        drop.anchorView = self.belongTextField
        drop.bottomOffset = CGPoint(x: 0, y: 45.5 + belongTextField.bounds.height)
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
            self?.belongTextField.text = "학사 졸업 또는 재학"
        }
    }

    private func handleSelection(for item: String) {
        belongTextField.text = item
        degreeLevel = degreeMapping[item] ?? "BACHELORS_STUDYING"
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
    
    private func setTopicData() {
        researchTopicCollectionView.delegate = nil
        researchTopicCollectionView.dataSource = nil
        
        researchTopicCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.researchTopicViewModel.ResearchTopicItems
            .observe(on: MainScheduler.instance)
            .bind(to: self.researchTopicCollectionView.rx.items(cellIdentifier: ResearchTopicCollectionViewCell.identifier, cellType: ResearchTopicCollectionViewCell.self)) { index, item, cell in
                cell.prepare(topics: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func setProfileAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        guard let retrievedEmail = KeychainHelper.standard.read(service: "email", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.userMypage.path
        
        APIService.shared.getWithToken(of: APIResponse<MyProfile>.self, url: url, accessToken: retrievedToken)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                let data = response.result
                self.researchTopicViewModel.ResearchTopicItems.accept(data.researchTopics!)
                self.idTextField.text = retrievedEmail
                self.nameTextField.text = data.name
                self.belongTextField.text = DegreeLevel.from(data.degreeLevel)?.korean ?? "학위 정보 없음"
                self.setTopicData()
                self.view.layoutIfNeeded()
            }, onFailure: { error in
                print("❌ 오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func editProfileAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.userProfile.path
        
        let params = [
            "degreeLevel": self.degreeLevel ?? "",
            "researchTopics": [
            ],
        ] as [String : Any]
        
        APIService.shared.putWithToken(of: APIResponse<EditProfile>.self, url: url, parameters: params, accessToken: retrievedToken)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                print("✅ 사용자 등록 성공:", response)
            }, onFailure: { error in
                print("❌ 오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func drop_Tapped() {
        drop.show()
    }
    
    @objc private func edit_Tapped(_ sender: Any) {
        editProfileAPI()
        self.navigationController?.popViewController(animated: true)
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

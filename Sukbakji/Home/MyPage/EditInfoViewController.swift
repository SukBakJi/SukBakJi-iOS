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
        $0.textColor = .black
    }
    private let idTextField = UITextField().then {
       $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(hexCode: "E1E1E1")
    }
    private let logingImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Kakao")
    }
    private let logingLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .black
    }
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let nameTextField = UITextField().then {
       $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(hexCode: "E1E1E1")
    }
    private let belongLabel = UILabel().then {
        $0.text = "현재 소속"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let belongTextField = UITextField().then {
       $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .black
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
        $0.textColor = UIColor(hexCode: "767676")
    }
    private let certificateButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8

        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("새로 인증하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(UIColor(named: "Coquelicot")!, for: .normal)
    }
    private let researchLabel = UILabel().then {
        $0.text = "연구 주제"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
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
       $0.backgroundColor = .gray200
    }
    private let plusButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_plusButton"), for: .normal)
    }
    private let editButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8

        $0.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
        $0.setTitle("수정하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(UIColor(hexCode: "EFEFEF"), for: .normal)
    }
    
    private let disposeBag = DisposeBag()
    
    var topicData: [String] = []
    
    private var degreeLevel: String?
    
    private let drop = DropDown()
    private let belongType = ["학사 재학 중", "학사 졸업", "석사 재학 중", "석사 졸업", "박사 재학 중", "박사 졸업"]
    
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
        idTextField.setLeftPadding(10)
        
        self.view.addSubview(logingImageView)
        logingImageView.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(6)
            make.leading.equalToSuperview().inset(24)
            make.height.width.equalTo(16)
        }
        
        self.view.addSubview(logingLabel)
        logingLabel.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(8)
            make.leading.equalTo(logingImageView.snp.trailing).inset(6)
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
        nameTextField.setLeftPadding(10)
        
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
        belongTextField.setLeftPadding(10)
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
        
        self.view.addSubview(researchTopicCollectionView)
        researchTopicCollectionView.snp.makeConstraints { make in
            make.top.equalTo(certificateLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
           make.height.equalTo(88)
        }
        
        self.view.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(researchTopicCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(1.2)
        }
        
        self.view.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.bottom.equalTo(backgroundLabel.snp.top)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(43)
        }
        
        self.view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.top.equalTo(researchTopicCollectionView.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        editButton.addTarget(self, action: #selector(edit_Tapped), for: .touchUpInside)
    }
    
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
        
        APIService().getWithAccessToken(of: APIResponse<MyProfile>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                let data = response.result
                for i in 0..<(data.researchTopics?.count ?? 0) {
                    self.topicData.append(data.researchTopics![i])
                }
                self.idTextField.text = retrievedEmail
                self.nameTextField.text = data.name
                self.degreeLevel = data.degreeLevel
                switch data.degreeLevel {
                case "BACHELORS_STUDYING":
                    self.belongTextField.text = "학사 재학 중"
                case "BACHELORS_GRADUATED":
                    self.belongTextField.text = "학사 졸업"
                case "MASTERS_STUDYING":
                    self.belongTextField.text = "석사 재학 중"
                case "MASTERS_GRADUATED":
                    self.belongTextField.text = "석사 졸업"
                case "DOCTORAL_STUDYING":
                    self.belongTextField.text = "박사 재학 중"
                case "DOCTORAL_GRADUATED":
                    self.belongTextField.text = "박사 졸업"
                default:
                    self.belongTextField.text = "학사 재학 중"
                }
                self.setTopicData()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    func initUI() {
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor(red: 236/255, green: 73/255, blue: 8/255, alpha: 1.0) // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor(hexCode: "F5F5F5") // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor(red: 253/255, green: 233/255, blue: 230/255, alpha: 1.0) // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(10)
        DropDown.appearance().setupMaskedCorners(CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner))
        drop.dismissMode = .automatic // 팝업을 닫을 모드 설정
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 12)
    }
    
    func setDropdown() {
        self.view.layoutIfNeeded()
        // dataSource로 ItemList를 연결
        drop.dataSource = belongType
        drop.cellHeight = 44
        // anchorView를 통해 UI와 연결
        drop.anchorView = self.belongTextField
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        drop.bottomOffset = CGPoint(x: 0, y: 1.5 + belongTextField.bounds.height)
        
        drop.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
            // separatorInset을 조정하여 separator 앞의 간격을 없앱니다.
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
                        
            // 새로운 separator 추가
            let separator = UIView()
            separator.backgroundColor = UIColor(hexCode: "E1E1E1")
            separator.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(separator)
                        
            // separator 높이(굵기) 설정
            let separatorHeight: CGFloat = 1.5 // 원하는 굵기 설정
                        
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: separatorHeight)
            ])
        }
        
        // Item 선택 시 처리
        drop.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self?.belongTextField.text = "\(item)"
            let belong = self?.belongTextField.text
            switch belong {
            case "학사 재학 중":
                self?.degreeLevel = "BACHELORS_STUDYING"
            case "학사 졸업":
                self?.degreeLevel = "BACHELORS_GRADUATED"
            case "석사 재학 중":
                self?.degreeLevel = "MASTERS_STUDYING"
            case "석사 졸업":
                self?.degreeLevel = "MASTERS_GRADUATED"
            case "박사 재학 중 ":
                self?.degreeLevel = "DOCTORAL_STUDYING"
            case "박사 졸업":
                self?.degreeLevel = "DOCTORAL_GRADUATED"
            default:
                self?.degreeLevel = "BACHELORS_STUDYING"
            }
        }
        
        // 취소 시 처리
        drop.cancelAction = { [weak self] in
            self?.belongTextField.text = "학사 졸업 또는 재학"
        }
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
        
        APIService().putWithAccessToken(of: APIResponse<String>.self, url: url, parameters: params, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                print("프로필 수정이 정상적으로 처리되었습니다.")
            default:
                AlertController(message: response.message).show()
            }
        }
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
        let str = topicData[indexPath.item].count
        return CGSize(width: 40 + str * 12, height: 29)
    }
}

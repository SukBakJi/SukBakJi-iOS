//
//  EditInfoViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit
import DropDown
import Alamofire

class EditInfoViewController: UIViewController {
    
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var belongTF: UITextField!
    @IBOutlet weak var researchTopicCV: UICollectionView!
    @IBOutlet weak var setButton: UIButton!
    
    @IBOutlet weak var socialImage: UIImageView!
    @IBOutlet weak var socialLabel: UILabel!
    
    var userData: MyPageResult?
    private var EditData: EditProfileResult!
    
    var degreeLevel: DegreeLevel?
    
    private var userEmail: String?
    
    let drop = DropDown()
    let belongType = ["학사 졸업 또는 재학", "석사 재학", "석사 졸업", "박사 재학", "박사 졸업", "석박사 통합 재학"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        idTF.addBottomShadow()
        idTF.setLeftPadding(10)
        nameTF.addBottomShadow()
        nameTF.setLeftPadding(10)
        belongTF.addBottomShadow()
        belongTF.setLeftPadding(10)
        
        initUI()
        setDropdown()
        settingButton()
        
        researchTopicCV.delegate = self
        researchTopicCV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getUserName()
    }
    
    func settingButton() {
        setButton.isEnabled = true
        setButton.layer.masksToBounds = true
        setButton.layer.cornerRadius = 10
        setButton.backgroundColor = UIColor(named: "Coquelicot")
        setButton.setTitleColor(.white, for: .normal)
        setButton.setTitleColor(.white, for: .selected)
    }
    
    func getUserName() {
        if let retrievedData = KeychainHelper.standard.read(service: "email", account: "user", type: String.self) {
            userEmail = retrievedData
            print("Password retrieved and stored in userPW: \(userEmail ?? "")")
        } else {
            print("Failed to retrieve password.")
        }
        
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            print("Failed to retrieve password.")
            return
        }
        
        let url = APIConstants.userURL + "/mypage"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(MyPageResultModel.self, from: data)
                    self.userData = decodedData.result
                    DispatchQueue.main.async {
                        self.idTF.text = self.userEmail
                        self.nameTF.text = self.userData?.name
                        if self.userData?.degreeLevel == "BACHELORS_STUDYING" || self.userData?.degreeLevel == "BACHELORS_GRADUATED"{
                            self.belongTF.text = "학사 졸업 또는 재학"
                            self.degreeLevel = .bachelorsGraduated
                        } else if self.userData?.degreeLevel == "MASTERS_STUDYING" {
                            self.belongTF.text = "석사 재학"
                            self.degreeLevel = .mastersStudying
                        } else if self.userData?.degreeLevel == "MASTERS_GRADUATED" {
                            self.belongTF.text = "석사 졸업"
                            self.degreeLevel = .mastersGraduated
                        } else if self.userData?.degreeLevel == "DOCTORAL_STUDYING" {
                            self.belongTF.text = "박사 재학"
                            self.degreeLevel = .doctoralStudying
                        } else if self.userData?.degreeLevel == "DOCTORAL_GRADUATED" {
                            self.belongTF.text = "박사 졸업"
                            self.degreeLevel = .doctoralGraduated
                        } else {
                            self.belongTF.text = "석박사 통합 재학"
                            self.degreeLevel = .integratedStudying
                        }
                        if self.userData?.provider == "BASIC" {
                            self.socialImage.image = UIImage(named: "Sukbakji_Email")
                            self.socialLabel.text = "이메일 로그인으로 사용 중이에요"
                        }
                        self.researchTopicCV.reloadData()
                    }
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func initUI() {
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor(red: 236/255, green: 73/255, blue: 8/255, alpha: 1.0) // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor(hexCode: "F5F5F5") // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor(red: 253/255, green: 233/255, blue: 230/255, alpha: 1.0) // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(5)
        DropDown.appearance().setupMaskedCorners(CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner))
        drop.dismissMode = .automatic // 팝업을 닫을 모드 설정
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 12)
    }
    
    func setDropdown() {
        // dataSource로 ItemList를 연결
        drop.dataSource = belongType
        drop.cellHeight = 44
        // anchorView를 통해 UI와 연결
        drop.anchorView = self.belongTF
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        drop.bottomOffset = CGPoint(x: 0, y: 1.5 + belongTF.bounds.height)
        
        drop.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
            // separatorInset을 조정하여 separator 앞의 간격을 없앱니다.
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
                        
            // 새로운 separator 추가
            let separator = UIView()
            separator.backgroundColor = UIColor(hexCode: "E1E1E1")
            separator.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(separator)
                        
            // separator 높이(굵기) 설정
            let separatorHeight: CGFloat = 1.0 // 원하는 굵기 설정
                        
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
            self?.belongTF.text = "\(item)"
            let belong = self?.belongTF.text
            switch belong {
            case "학사 졸업 또는 재학":
                self?.degreeLevel = .bachelorsStudying
            case "석사 재학":
                self?.degreeLevel = .mastersStudying
            case "석사 졸업":
                self?.degreeLevel = .mastersGraduated
            case "박사 재학":
                self?.degreeLevel = .doctoralStudying
            case "박사 졸업":
                self?.degreeLevel = .doctoralGraduated
            case "석박사 통합 재학":
                self?.degreeLevel = .integratedStudying
            default:
                break
            }
        }
        
        // 취소 시 처리
        drop.cancelAction = { [weak self] in
            self?.belongTF.text = "학사 졸업 또는 재학"
        }
    }
    
    @IBAction func drop_Tapped(_ sender: Any) {
        drop.show()
    }
    
    @IBAction func edit_Tapped(_ sender: Any) {
        let parameters = EditProfileModel(degreeLevel: degreeLevel!, researchTopics: userData?.researchTopics ?? [])
        APIEditProfile.instance.SendingEditProfile(parameters: parameters) { result in self.EditData = result }
        self.presentingViewController?.dismiss(animated: true)
    }
}

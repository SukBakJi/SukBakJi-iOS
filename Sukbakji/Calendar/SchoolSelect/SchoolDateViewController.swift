//
//  SchoolDateViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/24/24.
//

import UIKit
import DropDown
import Alamofire

class SchoolDateViewController: UIViewController {
    
    private var memberId = UserDefaults.standard.integer(forKey: "memberID")
    
    @IBOutlet weak var univLabel: UILabel!
    
    @IBOutlet weak var RecruitTF: UITextField!
    @IBOutlet weak var recruitFirstButton: UIButton!
    @IBOutlet weak var recruitSecondButton: UIButton!
    
    @IBOutlet weak var recruitDayLabel: UILabel!
    @IBOutlet weak var recruitTypeLabel: UILabel!
    
    @IBOutlet weak var warningImage: UIImageView!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var setButton: UIButton!
    
    var receivedUnivName: String?
    var univId: Int?
    
    let drop = DropDown()
    private var recruitType: [String] = []
    
    private var methodData: UniMethod?
    private var allMethodDatas: [UniMethodList] = []
    
    private var uniData: UniPostResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSchoolDateView()
        
        settingButton()
        
        initUI()
        
        recruitFirstButton.isEnabled = false
        recruitFirstButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        recruitSecondButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(self.didDismissDetailNotification(_:)),
                  name: NSNotification.Name("DismissOneMore"),
                  object: nil
        )
    }
    
    func setSchoolDateView() {
        RecruitTF.addTFUnderline()
        RecruitTF.setLeftPadding(10)
        RecruitTF.isEnabled = false
        
        warningImage.isHidden = true
        warningLabel.isHidden = true
        
        univLabel.text = receivedUnivName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getSchool(univId: self.univId ?? 0)
        }
    }
    
    func getSchool(univId: Int) {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }

        let url = APIConstants.calendar.path + "/univ/method?univId=\(univId)"
        
        let parameter: Parameters = [
            "keyword": "\(univId)"
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
        AF.request(url, method: .get, parameters: parameter, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(UniMethod.self, from: data)
//                    self.methodData = decodedData.result
//                    self.allMethodDatas = self.methodData?.methodList ?? []
//                    
//                    DispatchQueue.main.async {
//                        for i in 0..<self.allMethodDatas.count {
//                            self.recruitType.append(self.allMethodDatas[i].method)
//                            self.setDropdown()
//                        }
//                    }
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
    
    func settingButton() {
        setButton.isEnabled = false
        setButton.layer.masksToBounds = true
        setButton.layer.cornerRadius = 10
        setButton.backgroundColor = UIColor(hexCode: "EFEFEF")
        setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 텍스트 필드 내용이 변경될 때 버튼 색깔 업데이트
        DispatchQueue.main.async {
            self.updateButtonColor()
        }
        return true
    }
        
    func updateButtonColor() {
        if (RecruitTF.text?.isEmpty == false) {
            setButton.isEnabled = true
            setButton.backgroundColor = UIColor(named: "Coquelicot")
            setButton.setTitleColor(.white, for: .normal)
            setButton.setTitleColor(.white, for: .selected)
        } else {
            setButton.isEnabled = false
            setButton.backgroundColor = UIColor(hexCode: "EFEFEF")
            setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
            setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .selected)
        }
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
        NotificationCenter.default.post(name: NSNotification.Name("DismissTwo"), object: nil, userInfo: nil)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if recruitFirstButton.image(for: .normal) == UIImage(named: "Sukbakji_RadioButton") && recruitSecondButton.image(for: .normal) == UIImage(named: "Sukbakji_RadioButton2") {
            recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
            recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
            recruitFirstButton.isEnabled = true
            recruitSecondButton.isEnabled = false
            recruitDayLabel.text = "2025년 후기"
        } else {
            recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
            recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
            recruitFirstButton.isEnabled = false
            recruitSecondButton.isEnabled = true
            recruitDayLabel.text = "2025년 전기"
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
        drop.dataSource = recruitType
        drop.cellHeight = 44
        // anchorView를 통해 UI와 연결
        drop.anchorView = self.RecruitTF
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        drop.bottomOffset = CGPoint(x: 0, y: 1.5 + RecruitTF.bounds.height)
        
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
            self?.RecruitTF.text = "\(item)"
            self?.recruitTypeLabel.text = "\(item)"
            self?.recruitTypeLabel.textColor = UIColor(named: "Coquelicot")
            self?.updateButtonColor()
        }
        
        // 취소 시 처리
        drop.cancelAction = { [weak self] in
            self?.RecruitTF.text = ""
        }
    }
    
    @IBAction func drop_Tapped(_ sender: Any) {
        drop.show()
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SchoolAlertVC") as? SchoolAlertViewController else {
            return
        }
        self.present(nextVC, animated: false)
    }
    
    @IBAction func next_Tapped(_ sender: Any) {
        let parameters = UniPost(memberId: memberId, univId: univId ?? 0, season: recruitDayLabel.text ?? "", method: recruitTypeLabel.text ?? "")
        APIUniPost.instance.SendingPostUni(parameters: parameters) { result in self.uniData = result }
        NotificationCenter.default.post(name: NSNotification.Name("DismissTwo"), object: nil, userInfo: nil)
        self.presentingViewController?.dismiss(animated: true)
    }
}

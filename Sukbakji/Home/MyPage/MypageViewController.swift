//
//  MypageViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit
import Alamofire

class MypageViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var isDegreeLabel: UILabel!
    @IBOutlet weak var warningImage: UIImageView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    private var userData: MyPageResult?
    private var logoutData: LogoutResult!
    
    private var userToken: String?
    private var point: String?
    
    private let numberFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getUserName()
        }
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func getUserName() {
        if let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) {
            userToken = retrievedToken
        } else {
            print("Failed to retrieve password.")
        }
        
        let url = APIConstants.userURL + "/mypage"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(userToken ?? "")",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(MyPageResultModel.self, from: data)
                    self.userData = decodedData.result
                    
                    DispatchQueue.main.async {
                        self.nameLabel.text = self.userData?.name
                        if self.userData?.degreeLevel == "BACHELORS_STUDYING" || self.userData?.degreeLevel == "BACHELORS_GRADUATED"{
                            self.degreeLabel.text = "학사 졸업 또는 재학중"
                        } else if self.userData?.degreeLevel == "MASTERS_STUDYING" {
                            self.degreeLabel.text = "석사 재학중"
                        } else if self.userData?.degreeLevel == "MASTERS_GRADUATED" {
                            self.degreeLabel.text = "석사 졸업중"
                        } else if self.userData?.degreeLevel == "DOCTORAL_STUDYING" {
                            self.degreeLabel.text = "박사 재학중"
                        } else if self.userData?.degreeLevel == "DOCTORAL_GRADUATED" {
                            self.degreeLabel.text = "박사 졸업중"
                        } else {
                            self.degreeLabel.text = "석박사 통합 재학"
                        }
                        if self.userData?.degreeLevel == nil {
                            self.warningImage.isHidden = false
                            self.warningLabel.isHidden = false
                            self.isDegreeLabel.text = "아직 학적 인증이 완료되지 않은 상태입니다"
                        } else {
                            self.warningImage.isHidden = true
                            self.warningLabel.isHidden = true
                            self.isDegreeLabel.text = "현재 학적 인증이 완료된 상태입니다"
                        }
                        
                        self.numberFormatter.numberStyle = .decimal
                        self.point = self.numberFormatter.string(from: NSNumber(value: self.userData?.point ?? 0))
                        self.pointLabel.text = "\(self.point ?? "")"
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

    @IBAction func edit_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileViewController else { return }
        
        self.present(nextVC, animated: true)
    }
    
    @IBAction func logout_Tapped(_ sender: Any) {
        let parameters = LogoutModel(accessToken: userToken ?? "")
        APILogoutPost.instance.SendingLogout(parameters: parameters) { result in self.logoutData = result }
        let mainViewController = UINavigationController(rootViewController: LoginViewController())
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController, animated: true)
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

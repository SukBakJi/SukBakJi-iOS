//
//  SchoolSelectViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/18/24.
//

import UIKit
import Alamofire

class SchoolSelectViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var SchoolTV: UITableView!
    @IBOutlet weak var noResultImage: UIImageView!
    @IBOutlet weak var noResultSV: UIStackView!
    
    @IBOutlet weak var schoolSearchTF: UITextField!
    @IBOutlet weak var setButton: UIButton!

    var uniData: UniResponse?
    var allUniDatas: [UniListResponse] = []
    
    var selectedIndex: IndexPath?
    
    var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.SchoolTV.dataSource = self
        self.SchoolTV.delegate = self
        
        schoolSearchTF.errorfix()
        schoolSearchTF.delegate = self
        
        settingButton()
        
        NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(self.didDismissDetailNotification(_:)),
                  name: NSNotification.Name("DismissTwo"),
                  object: nil
        )
    }
    
    func getSchool() {
        guard let retrievedData = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self),
              let userToken = String(data: retrievedData, encoding: .utf8) else {
            print("Failed to retrieve password.")
            return
        }
        
        let url = APIConstants.calendarURL + "/search"
        
        let parameter: Parameters = [
            "keyword": "\(schoolSearchTF.text ?? "")"
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(userToken)",
        ]
        
        AF.request(url, method: .get, parameters: parameter, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(UniResultModel.self, from: data)
                    self.uniData = decodedData.result
                    self.allUniDatas = self.uniData?.universityList ?? []
                    DispatchQueue.main.async {
                        self.SchoolTV.reloadData()
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchTimer?.invalidate() // 이전 타이머를 취소
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] _ in
            self?.getSchool()
        })
        return true
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func settingButton() {
        setButton.isEnabled = false
        setButton.layer.masksToBounds = true
        setButton.layer.cornerRadius = 10
        setButton.backgroundColor = UIColor(hexCode: "EFEFEF")
        setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
    }
    
    @IBAction func delete_Tapped(_ sender: Any) {
        schoolSearchTF.text = ""
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func next_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SchoolDateVC") as? SchoolDateViewController else {
            return
        }
        self.present(nextVC, animated: false)
    }
}

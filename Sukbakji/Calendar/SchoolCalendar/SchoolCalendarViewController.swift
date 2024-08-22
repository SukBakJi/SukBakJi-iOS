//
//  SchoolCalendarViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/27/24.
//

import UIKit
import Alamofire

class SchoolCalendarViewController: UIViewController {
    
    @IBOutlet weak var schoolCalendarTV: UITableView!
    @IBOutlet weak var univCount: UILabel!
    
    var allDatas: UnivListResponse?
    var allDetailDatas: [UnivList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        schoolCalendarTV.delegate = self
        schoolCalendarTV.dataSource = self
        schoolCalendarTV.layer.masksToBounds = false// any value you want
        schoolCalendarTV.layer.shadowOpacity = 0.2// any value you want
        schoolCalendarTV.layer.shadowRadius = 2 // any value you want
        schoolCalendarTV.layer.shadowOffset = .init(width: 0, height: 0.5)
        schoolCalendarTV.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(self.didDismissDetailNotification(_:)),
                  name: NSNotification.Name("deleteUni"),
                  object: nil
        )
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
        self.getUnivList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getUnivList()
    }
    
    func getUnivList() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            print("Failed to retrieve password.")
            return
        }
        
        let url = APIConstants.calendarURL + "/univ"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(UnivListResultModel.self, from: data)
                    self.allDatas = decodedData.result
                    self.allDetailDatas = self.allDatas?.univList ?? []
                    DispatchQueue.main.async {
                        self.univCount.text = "전체선택 (0/\(self.allDetailDatas.count))"
                        self.schoolCalendarTV.reloadData()
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
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

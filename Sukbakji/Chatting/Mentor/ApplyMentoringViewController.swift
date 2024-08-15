//
//  ApplyMentoringViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/10/24.
//

import UIKit
import Alamofire

class ApplyMentoringViewController: UIViewController {
    
    @IBOutlet weak var MentoringTV: UITableView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var moreView: UIView!
    
    var allDatas: MentorListResponse?
    var allDetailDatas: [MentorList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setMoreButton()
        
        getMentorList()
    }
    
    func setTableView() {
        MentoringTV.delegate = self
        MentoringTV.dataSource = self
        MentoringTV.layer.masksToBounds = true// any value you want
        MentoringTV.layer.shadowOpacity = 0.2// any value you want
        MentoringTV.layer.shadowRadius = 2 // any value you want
        MentoringTV.layer.shadowOffset = .init(width: 0, height: 0.2)
        MentoringTV.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    func setMoreButton() {
        moreButton.layer.masksToBounds = true
        moreButton.layer.cornerRadius = 15
        moreButton.layer.borderColor = UIColor(hexCode: "E1E1E1").cgColor
        moreButton.layer.borderWidth = 1.0
    }
    
    func getMentorList() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            print("Failed to retrieve password.")
            return
        }
        
        let url = APIConstants.mentorURL
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(MentorListResultModel.self, from: data)
                    self.allDatas = decodedData.result
                    self.allDetailDatas = self.allDatas?.mentorList ?? []
                    DispatchQueue.main.async {
                        self.MentoringTV.reloadData()
                        if self.allDetailDatas.count >= 4 {
                            self.moreView.isHidden = false
                        } else {
                            self.moreView.isHidden = true
                        }
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
    
    @IBAction func more_Tapped(_ sender: Any) {
        MentoringTV.isScrollEnabled = true
        moreView.isHidden = true
    }
}

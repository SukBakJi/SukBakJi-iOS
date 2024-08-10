//
//  HomeViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/15/24.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    @IBOutlet weak var UpComingView: UIView!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var allDatas: UpComingResult?
    var allDetailDatas: [UpcomingResponse] = []
    var memberData: memberIdResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UpComingView.layer.cornerRadius = 10
        UpComingView.layer.masksToBounds = false// any value you want
        UpComingView.layer.shadowOpacity = 0.2// any value you want
        UpComingView.layer.shadowRadius = 2 // any value you want
        UpComingView.layer.shadowOffset = .init(width: 0, height: 0.2)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func getViewAll() {
        
        let url = APIConstants.calendarURL + "/schedule"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer ",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(UpComingResultModel.self, from: data)
                    self.allDatas = decodedData.result
                    self.allDetailDatas = self.allDatas?.scheduleList ?? []
                    let upComingdDay = self.allDetailDatas[0].dday
                    let upComingContent = self.allDetailDatas[0].content
                    DispatchQueue.main.async {
                        self.dDayLabel.text = "D-\(upComingdDay)"
                        self.contentLabel.text = "\(upComingContent)"
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
    
    func getMemberID() {
        
        let url = APIConstants.calendarURL + "/member"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer ",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(memberIdResultModel.self, from: data)
                    self.memberData = decodedData.result
                    let memberId = self.memberData?.memberId
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(memberId, forKey: "memberID")
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
    
    @IBAction func info_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MypageVC") as? MypageViewController else { return }
        
        self.present(nextVC, animated: true)
    }
}

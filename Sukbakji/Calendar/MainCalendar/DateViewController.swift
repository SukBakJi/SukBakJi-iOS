//
//  DateViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/18/24.
//

import UIKit
import Alamofire

class DateViewController: UIViewController {
    
    @IBOutlet weak var DateCV: UICollectionView!
    
    var allDatas: UpComingResult?
    var allDetailDatas: [UpcomingResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DateCV.delegate = self
        DateCV.dataSource = self
        
        DateCV.layer.masksToBounds = false// any value you want
        DateCV.layer.shadowOpacity = 0.2// any value you want
        DateCV.layer.shadowRadius = 2 // any value you want
        DateCV.layer.shadowOffset = .init(width: 0, height: 1)
        
        getViewSchedule()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getViewSchedule()
    }

    func getViewSchedule() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            print("Failed to retrieve password.")
            return
        }

        let url = APIConstants.calendarURL + "/schedule"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(UpComingResultModel.self, from: data)
                    self.allDatas = decodedData.result
                    self.allDetailDatas = self.allDatas?.scheduleList ?? []
                    self.allDetailDatas = self.allDetailDatas.filter { $0.dday >= 0 && $0.dday <= 10 }
                    DispatchQueue.main.async {
                        self.DateCV.reloadData()
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
}

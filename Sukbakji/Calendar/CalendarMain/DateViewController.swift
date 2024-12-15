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
    
    private var allDatas: UpComingResult?
    var allDetailDatas: [UpComingResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getViewSchedule()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getViewSchedule()
        }
    }

    func getViewSchedule() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }

        let url = APIConstants.calendarSchedule.path
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(UpComingResult.self, from: data)
//                    self.allDatas = decodedData.result
//                    self.allDetailDatas = self.allDatas?.scheduleList ?? []
//                    self.allDetailDatas = self.allDetailDatas.filter { $0.dday >= 0 && $0.dday <= 10 }
//                    
//                    DispatchQueue.main.async {
//                        self.DateCV.reloadData()
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
}

//
//  MyAlarmViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/4/24.
//

import UIKit
import Alamofire

class MyAlarmViewController: UIViewController {
    
    @IBOutlet weak var myAlarmTV: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var calendarDate = Date()
    
    var allDatas: AlarmResponse?
    var allDetailDatas: [AlarmList] = []
    
    var alarmData: AlarmPatchResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myAlarmTV.delegate = self
        myAlarmTV.dataSource = self
        myAlarmTV.layer.masksToBounds = true// any value you want
        myAlarmTV.layer.shadowOpacity = 0.2// any value you want
        myAlarmTV.layer.shadowRadius = 2 // any value you want
        myAlarmTV.layer.shadowOffset = .init(width: 0, height: 0.5)
        myAlarmTV.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        self.configureCalendar()
        self.getAlarmList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.getAlarmList()
    }
    
    func getAlarmList() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            print("Failed to retrieve password.")
            return
        }
        
        let url = APIConstants.calendarURL + "/alarm"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(AlarmResultModel.self, from: data)
                    self.allDatas = decodedData.result
                    self.allDetailDatas = self.allDatas?.alarmList ?? []
                    DispatchQueue.main.async {
                        self.myAlarmTV.reloadData()
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
    
    private func configureCalendar() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        self.updateTitle()
    }
    
    private func updateTitle(){
        let date = self.dateFormatter.string(from: self.calendarDate)
        self.dateLabel.text = date
    }

    @IBAction func add_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "AlarmVC") as? AlarmViewController else {
            return
        }
        self.present(nextVC, animated: true)
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

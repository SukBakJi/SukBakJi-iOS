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
    
    private var allDatas: AlarmListResult?
    var allDetailDatas: [AlarmList] = []
    
    private var alarmData: AlarmPatchResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMyAlarmTableView()
        
        self.configureCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getAlarmList()
        }
    }
    
    func setMyAlarmTableView() {
        myAlarmTV.delegate = self
        myAlarmTV.dataSource = self
        myAlarmTV.layer.masksToBounds = true// any value you want
        myAlarmTV.layer.shadowOpacity = 0.2// any value you want
        myAlarmTV.layer.shadowRadius = 2 // any value you want
        myAlarmTV.layer.shadowOffset = .init(width: 0, height: 0.5)
        myAlarmTV.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    func getAlarmList() {
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
                    let decodedData = try JSONDecoder().decode(AlarmListResult.self, from: data)
//                    self.allDatas = decodedData.result
//                    self.allDetailDatas = self.allDatas?.alarmList ?? []
//                    
//                    DispatchQueue.main.async {
//                        self.myAlarmTV.reloadData()
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

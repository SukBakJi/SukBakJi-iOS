//
//  CalendarViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/15/24.
//

import UIKit
import Alamofire

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var AlertView: UIView!
    @IBOutlet weak var triangleView: UIImageView!
    @IBOutlet weak var univLabel: UILabel!
    
    @IBOutlet weak var dateListTV: UITableView!
    @IBOutlet weak var dateListTVHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var alarmButton: UIButton!
    
    private lazy var weekStackView = UIStackView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var calendarDate = Date()
    private var days = [String]()
    
    var dateDatas: DateResponse?
    var allDateDatas: [DateListResponse] = []
    
    var UniDatas: UnivListResponse?
    var UniDetailDatas: [UnivList] = []
    
    var alarmDatas: AlarmResponse?
    var alarmDetailDatas: [AlarmList] = []
    var alarmDateDatas: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DateView.layer.cornerRadius = 10
        AlertView.layer.cornerRadius = 10
        
        dateListTV.delegate = self
        dateListTV.dataSource = self
        dateListTV.layer.masksToBounds = false// any value you want
        dateListTV.layer.shadowOpacity = 0.2// any value you want
        dateListTV.layer.shadowRadius = 2 // any value you want
        dateListTV.layer.shadowOffset = .init(width: 0, height: 0.2)
        dateListTV.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        self.configure()
        self.setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getUnivList()
        self.getAlarmList()
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
                    self.UniDatas = decodedData.result
                    self.UniDetailDatas = self.UniDatas?.univList ?? []
                    DispatchQueue.main.async {
                        if self.UniDetailDatas.count >= 1 {
                            self.AlertView.isHidden = true
                            self.triangleView.isHidden = true
                            self.univLabel.text = "모든 학교"
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
    
    func getSchedule(date: String) {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            print("Failed to retrieve password.")
            return
        }
        
        let url = APIConstants.calendarURL + "/schedule/\(date)"
        
        let parameter: Parameters = [
            "date": "\(date)"
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
        AF.request(url, method: .get, parameters: parameter, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(DateResultModel.self, from: data)
                    self.dateDatas = decodedData.result
                    self.allDateDatas = self.dateDatas?.scheduleList ?? []
                    DispatchQueue.main.async {
                        self.dateListTV.reloadData()
                        if self.allDateDatas.count >= 1 {
                            self.expandHeight()
                        } else {
                            self.reduceHeight()
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
                    self.alarmDatas = decodedData.result
                    self.alarmDetailDatas = self.alarmDatas?.alarmList ?? []
                    for i in 0..<self.alarmDetailDatas.count {
                        self.alarmDateDatas.append(self.alarmDetailDatas[i].alarmDate)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
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
    
    func setTableView() {
        dateListTV.delegate = self
        dateListTV.dataSource = self
        dateListTV.layer.masksToBounds = false// any value you want
        dateListTV.layer.shadowOpacity = 0.2// any value you want
        dateListTV.layer.shadowRadius = 2 // any value you want
        dateListTV.layer.shadowOffset = .init(width: 0, height: 0.5)
        dateListTV.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    private func configure() {
        self.configureWeekStackView()
        self.configureWeekLabel()
        self.configureCollectionView()
        self.configureCalendar()
    }
    
    private func configureWeekStackView() {
        self.DateView.addSubview(self.weekStackView)
        self.weekStackView.distribution = .fillEqually
        self.weekStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.weekStackView.topAnchor.constraint(equalTo: self.DateView.topAnchor, constant: 20),
            self.weekStackView.leadingAnchor.constraint(equalTo: self.DateView.leadingAnchor, constant: 8),
            self.weekStackView.trailingAnchor.constraint(equalTo: self.DateView.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureWeekLabel() {
        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            label.textAlignment = .center
            label.font = UIFont(name: "SUITE-SemiBold", size: 14)
            self.weekStackView.addArrangedSubview(label)
            
            if i == 0 {
                label.textColor = .black
            } else if i == 6 {
                label.textColor = .black
            } else {
                label.textColor = .black
            }
        }
    }
    
    private func configureCollectionView() {
        self.DateView.addSubview(self.collectionView)
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant: 20),
            self.collectionView.leadingAnchor.constraint(equalTo: self.DateView.leadingAnchor, constant: 8),
            self.collectionView.trailingAnchor.constraint(equalTo: self.DateView.trailingAnchor, constant: -8),
            self.collectionView.bottomAnchor.constraint(equalTo: self.DateView.bottomAnchor,  constant: 8)
        ])
    }
    
    private func configureCalendar() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        self.updateCalendar()
    }
    
    private func startDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self.calendarDate) - 1
    }
    
    private func endDate() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
    }
    
    private func updateTitle(){
        let date = self.dateFormatter.string(from: self.calendarDate)
        self.dayLabel.text = date
    }
    
    private func updateDays(){
        self.days.removeAll()
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let totalDays = startDayOfTheWeek + self.endDate()
        
        for day in Int()..<totalDays {
            if day < startDayOfTheWeek {
                self.days.append("")
                continue
            }
            self.days.append("\(day - startDayOfTheWeek + 1)")
        }
        
        self.collectionView.reloadData()
    }
    
    private func updateCalendar() {
        self.updateTitle()
        self.updateDays()
    }
    
    @IBAction func school_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SchoolCalendarVC") as? SchoolCalendarViewController else {
            return
        }
        self.present(nextVC, animated: true)
    }
    
    @IBAction func School_Select_Tapped(_ sender: Any) {
        AlertView.isHidden = true
        triangleView.isHidden = true
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SchoolSelectVC") as? SchoolSelectViewController else {
            return
        }
        self.present(nextVC, animated: true)
    }
    
    @IBAction func Alarm_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "CalendarFBCVC") as? CalendarFBCViewController else {
            return
        }
        self.present(nextVC, animated: false)
    }
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let day = days[indexPath.item]
        let dayNum = Int(day) ?? 0
        
        let date = dayLabel.text ?? ""
        let replacedString = date.replacingOccurrences(of: " ", with: "")
        let reReplacedString = replacedString.replacingOccurrences(of: "년|월", with: "-", options: .regularExpression)
        
        if dayNum <= 9 {
            getSchedule(date: "\(reReplacedString)0\(day)")
        } else {
            getSchedule(date: "\(reReplacedString)\(day)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
        let day = self.days[indexPath.item]
        
        cell.updateDay(day: day)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dayInt = Int(day), dayInt > 0 {
            var components = self.calendar.dateComponents([.year, .month], from: self.calendarDate)
            components.day = dayInt
            if let date = self.calendar.date(from: components) {
                let dateString = dateFormatter.string(from: date)
                // 알람이 있는 날짜인지 확인
                if self.alarmDateDatas.contains(dateString) {
                    cell.firstDot.isHidden = false
                } else {
                    cell.firstDot.isHidden = true
                }
            }
        } else {
            cell.firstDot.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.weekStackView.frame.width / 7
        return CGSize(width: width, height: width * 0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

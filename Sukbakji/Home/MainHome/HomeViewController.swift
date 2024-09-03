//
//  HomeViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/15/24.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var UpComingView: UIView!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var topButton: UIButton!
    
    var allDatas: UpComingResult?
    var allDetailDatas: [UpcomingResponse] = []
    var userData: MyPageResult?
    var memberData: memberIdResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpComingView()
        
        topButton.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
    }
    
    func setUpComingView() {
        UpComingView.layer.cornerRadius = 10
        UpComingView.layer.masksToBounds = false// any value you want
        UpComingView.layer.shadowOpacity = 0.2// any value you want
        UpComingView.layer.shadowRadius = 2 // any value you want
        UpComingView.layer.shadowOffset = .init(width: 0, height: 0.2)
    }
    
    @objc func scrollToTop() {
        // 스크롤뷰의 가장 위로 이동
        scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top - 59), animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.getUserName()
            self.getViewSchedule()
            self.getMemberID()
        }

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func getUserName() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        let url = APIConstants.userURL + "/mypage"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(MyPageResultModel.self, from: data)
                    self.userData = decodedData.result
                    
                    DispatchQueue.main.async {
                        self.nameLabel.text = self.userData?.name
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
    
    func getViewSchedule() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
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
                    
                    DispatchQueue.main.async {
                        if self.allDetailDatas.count >= 1{
                            let upComingdDay = self.allDetailDatas[0].dday
                            let upComingContent = self.allDetailDatas[0].content
                            let upComingUniv = self.allDetailDatas[0].univId
                            
                            if upComingdDay < 0 {
                                let dayNum = abs(upComingdDay)
                                self.dDayLabel.text = "D+\(dayNum)"
                            } else {
                                self.dDayLabel.text = "D-\(upComingdDay)"
                            }
                            if upComingUniv == 1 {
                                self.contentLabel.text = "서울대학교 \(upComingContent)"
                            } else if upComingUniv == 2 {
                                self.contentLabel.text = "연세대학교 \(upComingContent)"
                            } else if upComingUniv == 3 {
                                self.contentLabel.text = "고려대학교 \(upComingContent)"
                            } else if upComingUniv == 4 {
                                self.contentLabel.text = "카이스트 \(upComingContent)"
                            }
                        } else {
                            self.dDayLabel.isHidden = true
                            self.contentLabel.text = "다가오는 일정이 없습니다"
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
    
    func getMemberID() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        let url = APIConstants.calendarURL + "/member"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
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

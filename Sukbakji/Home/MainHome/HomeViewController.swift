//
//  HomeViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/15/24.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire

class HomeViewController: UIViewController {
   
   @IBOutlet weak var scrollView: UIScrollView!
   
   @IBOutlet weak var nameLabel: UILabel!
   
   @IBOutlet weak var UpComingView: UIView!
   @IBOutlet weak var dDayLabel: UILabel!
   @IBOutlet weak var contentLabel: UILabel!
   
   @IBOutlet weak var topButton: UIButton!
   
   private var allDatas: UpComingResult?
   private var allDetailDatas: [UpcomingResponse] = []
   private var userData: MyPageResult?
   private var memberData: memberIdResult?
   
   private let disposeBag = DisposeBag()
   
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
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
   
   func fetchAccessToken() -> Observable<String> {
       return Observable.create { observer in
           if let token = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) {
               observer.onNext(token)
               observer.onCompleted()
           } else {
               observer.onError(NSError(domain: "TokenError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No token found"]))
           }
           return Disposables.create()
       }
   }
   
   func getUserName() {
       fetchAccessToken()
           .flatMap { retrievedToken -> Observable<(HTTPURLResponse, Data)> in
               let url = APIConstants.user.path + "/mypage"
               let headers: HTTPHeaders = [
                   "Authorization": "Bearer \(retrievedToken)"
               ]
               
               return RxAlamofire.requestData(.get, url, headers: headers)
           }
           .subscribe(onNext: { [weak self] (response, data) in
               do {
                   let decodedData = try JSONDecoder().decode(MyPageResultModel.self, from: data)
                   self?.userData = decodedData.result
                   
                   // UI 업데이트는 메인 스레드에서 처리
                   DispatchQueue.main.async {
                       self?.nameLabel.text = self?.userData?.name
                   }
               } catch let error {
                   print("Decoding error: \(error)")
               }
           }, onError: { error in
               print("Error: \(error)")
           })
           .disposed(by: disposeBag)
   }
   
   func getViewSchedule() {
      fetchAccessToken()
         .flatMap { retrievedToken -> Observable<(HTTPURLResponse, Data)> in
             let url = APIConstants.calendar.path + "/schedule"
            let headers: HTTPHeaders = [
               "Authorization": "Bearer \(retrievedToken)"
            ]
            
            return RxAlamofire.requestData(.get, url, headers: headers)
         }
         .subscribe(onNext: { [weak self] (response, data) in
            do {
               let decodedData = try JSONDecoder().decode(UpComingResultModel.self, from: data)
               self?.allDatas = decodedData.result
               self?.allDetailDatas = self?.allDatas?.scheduleList ?? []
               
               DispatchQueue.main.async {
                  if self?.allDetailDatas.count ?? 0 >= 1{
                     let upComingdDay = self?.allDetailDatas[0].dday
                     let upComingContent = self?.allDetailDatas[0].content
                     let upComingUniv = self?.allDetailDatas[0].univId
                     
                     if upComingdDay ?? 0 < 0 {
                        let dayNum = abs(upComingdDay ?? 0)
                        self?.dDayLabel.text = "D+\(dayNum)"
                     } else {
                        self?.dDayLabel.text = "D-\(upComingdDay ?? 0)"
                     }
                     if upComingUniv == 1 {
                        self?.contentLabel.text = "서울대학교 \(upComingContent ?? "")"
                     } else if upComingUniv == 2 {
                        self?.contentLabel.text = "연세대학교 \(upComingContent ?? "")"
                     } else if upComingUniv == 3 {
                        self?.contentLabel.text = "고려대학교 \(upComingContent ?? "")"
                     } else if upComingUniv == 4 {
                        self?.contentLabel.text = "카이스트 \(upComingContent ?? "")"
                     }
                  } else {
                     self?.dDayLabel.isHidden = true
                     self?.contentLabel.text = "다가오는 일정이 없습니다"
                  }
               }
            } catch let error {
               print("Decoding error: \(error)")
           }
       }, onError: { error in
           print("Error: \(error)")
       })
       .disposed(by: disposeBag)
   }
   
   func getMemberID() {
      fetchAccessToken()
         .flatMap { retrievedToken -> Observable<(HTTPURLResponse, Data)> in
             let url = APIConstants.calendar.path + "/member"
            let headers: HTTPHeaders = [
               "Authorization": "Bearer \(retrievedToken)"
            ]
            
            return RxAlamofire.requestData(.get, url, headers: headers)
         }
         .subscribe(onNext: { [weak self] (response, data) in
            do {
               let decodedData = try JSONDecoder().decode(memberIdResultModel.self, from: data)
               self?.memberData = decodedData.result
               let memberId = self?.memberData?.memberId
               
               DispatchQueue.main.async {
                  UserDefaults.standard.set(memberId, forKey: "memberID")
               }
            } catch let error {
               print("Decoding error: \(error)")
           }
       }, onError: { error in
           print("Error: \(error)")
       })
       .disposed(by: disposeBag)
   }
   
   @IBAction func info_Tapped(_ sender: Any) {
      guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MypageVC") as? MypageViewController else { return }
      
      self.present(nextVC, animated: true)
   }
}

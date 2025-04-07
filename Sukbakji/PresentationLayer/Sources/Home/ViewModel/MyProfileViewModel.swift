//
//  MyProfileViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 2/19/25.
//

import RxSwift
import RxCocoa

class MyProfileViewModel {
    private let disposeBag = DisposeBag()
    
    let myProfile = PublishSubject<MyProfile>()
    let errorMessage = PublishSubject<String>()
    
    let logoutResult = PublishSubject<Bool>()
    let profileUpdated = PublishSubject<Bool>()
    let pwChanged = PublishSubject<Bool>()
    
    let newPWInput = BehaviorRelay<String>(value: "")
    let confirmPWInput = BehaviorRelay<String>(value: "")
    
    func loadMyProfile() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        HomeRepository.shared.fetchMyProfile(token: token)
            .observe(on: MainScheduler.instance) // ✅ UI 업데이트를 위해 Main 스레드에서 실행
            .subscribe(onSuccess: { response in
                self.myProfile.onNext(response.result)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadLogOut() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        HomeRepository.shared.fetchLogOut(token: token)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.logoutResult.onNext(true)
            }, onFailure: { error in
                self.logoutResult.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func loadEditProfile(degree: String, topics: [String]) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        let params = [
            "degreeLevel": degree,
            "researchTopics": topics
        ] as [String : Any]
        
        HomeRepository.shared.fetchEditProfile(token: token, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.profileUpdated.onNext(true)
            }, onFailure: { error in
                self.profileUpdated.onNext(false)
                print("비밀번호 변경 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadChangePW() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        let params = [
            "newPassword": newPWInput.value,
            "confirmPassword": confirmPWInput.value
        ] as [String : Any]
        
        HomeRepository.shared.fetchChangePW(token: token, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.pwChanged.onNext(true)
            }, onFailure: { error in
                self.pwChanged.onNext(false)
                print("비밀번호 변경 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func uploadFCMTokenToServer(fcmToken : String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        FCMRepository.shared.postFCMToken(token: token, fcmToken: fcmToken)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                print("FCM 토큰 서버 업로드 성공: \(response.message)")
            }, onFailure: { error in
                print("FCM 토큰 서버 업로드 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

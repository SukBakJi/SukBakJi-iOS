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
    private let useCase: ProfileUseCase
    
    let myProfile = PublishSubject<MyProfile>()
    let errorMessage = PublishSubject<String>()
    let logoutResult = PublishSubject<Bool>()
    let profileUpdated = PublishSubject<Bool>()
    let pwChanged = PublishSubject<Bool>()

    let newPWInput = BehaviorRelay<String>(value: "")
    let confirmPWInput = BehaviorRelay<String>(value: "")
    
    init(useCase: ProfileUseCase = ProfileUseCase()) {
        self.useCase = useCase
    }
    
    func loadMyProfile() {
        useCase.fetchMyProfile()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] profile in
                self?.myProfile.onNext(profile)
            }, onFailure: { [weak self] error in
                self?.errorMessage.onNext("프로필 로딩 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadLogOut() {
        useCase.logOut()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.logoutResult.onNext(success)
            })
            .disposed(by: disposeBag)
    }
    
    func loadEditProfile(degree: String, topics: [String]) {
        useCase.editProfile(degree: degree, topics: topics)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.profileUpdated.onNext(isSuccess)
            })
            .disposed(by: disposeBag)
    }
    
    func loadChangePW() {
        useCase.changePassword(newPassword: newPWInput.value, confirmPassword: confirmPWInput.value)
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] isSuccess in
            self?.pwChanged.onNext(isSuccess)
            if !isSuccess {
                self?.errorMessage.onNext("비밀번호 변경 실패")
            }
        })
        .disposed(by: disposeBag)
    }
    
    func uploadFCMTokenToServer(fcmToken : String) {
        useCase.uploadFCMToken(fcmToken: fcmToken)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { message in
                print("\(message)")
            }, onFailure: { error in
                print("FCM 토큰 업로드 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

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
    private let useCase: HomeUseCase
    
    let myProfile = PublishSubject<MyProfile>()
    
    let logoutResult = PublishSubject<Bool>()
    let profileUpdated = PublishSubject<Bool>()
    let pwChanged = PublishSubject<Bool>()

    let newPWInput = BehaviorRelay<String>(value: "")
    let confirmPWInput = BehaviorRelay<String>(value: "")
    
    init(useCase: HomeUseCase = HomeUseCase()) {
        self.useCase = useCase
    }
    
    func loadMyProfile() {
        useCase.fetchMyProfile()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] profile in
                self?.myProfile.onNext(profile)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadLogOut() {
        useCase.logOut()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.logoutResult.onNext(success)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadEditProfile(degree: String, topics: [String]) {
        useCase.editProfile(degree: degree, topics: topics)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.profileUpdated.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadChangePW() {
        useCase.changePassword(newPassword: newPWInput.value, confirmPassword: confirmPWInput.value)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.pwChanged.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

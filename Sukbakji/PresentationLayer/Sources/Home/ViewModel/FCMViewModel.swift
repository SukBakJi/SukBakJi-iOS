//
//  FCMViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/4/25.
//

import RxSwift
import RxCocoa

class FCMViewModel {
    private let disposeBag = DisposeBag()
    private let useCase: FCMUseCase
    
    init(useCase: FCMUseCase = FCMUseCase()) {
        self.useCase = useCase
    }
    
    func uploadFCMToken(fcmToken : String) {
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

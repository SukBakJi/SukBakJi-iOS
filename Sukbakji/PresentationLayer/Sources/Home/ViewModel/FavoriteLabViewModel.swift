//
//  FavoriteLabViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import RxSwift
import RxCocoa

class FavoriteLabViewModel {
    
    private let disposeBag = DisposeBag()
    
    let favoriteLabList = BehaviorRelay<[FavoriteLab]>(value: [])
    let errorMessage = PublishSubject<String>()
    
    func loadFavoriteLab() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        HomeRepository.shared.fetchFavoriteLab(token: token)
            .observe(on: MainScheduler.instance) // ✅ UI 업데이트를 위해 Main 스레드에서 실행
            .subscribe(onSuccess: { response in
                self.favoriteLabList.accept(response.result)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

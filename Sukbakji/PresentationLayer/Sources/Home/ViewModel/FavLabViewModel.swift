//
//  FavLabViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import RxSwift
import RxCocoa

class FavLabViewModel {
    
    private let disposeBag = DisposeBag()
    
    let favLabList = BehaviorRelay<[FavoriteLab]>(value: [])
    let errorMessage = PublishSubject<String>()
    
    func loadFavoriteLab() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        DirectoryRepository.shared.fetchFavoriteLabs(token: token)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.favLabList.accept(response.result)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

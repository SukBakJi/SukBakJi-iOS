//
//  FavBoardViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import RxSwift
import RxCocoa

class FavBoardViewModel {
    
    private let disposeBag = DisposeBag()
    
    let favBoardList = BehaviorRelay<[FavoriteBoard]>(value: [])
    let errorMessage = PublishSubject<String>()
    
    func loadFavoriteBoard() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        HomeRepository.shared.fetchFavoriteBoard(token: token)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.favBoardList.accept(response.result)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

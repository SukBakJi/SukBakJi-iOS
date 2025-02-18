//
//  FavoriteBoardViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import RxSwift
import RxCocoa

class FavoriteBoardViewModel {
    
    private let disposeBag = DisposeBag()
    
    let favoriteBoardList = BehaviorRelay<[FavoriteBoard]>(value: [])
    let errorMessage = PublishSubject<String>()
    
    func loadFavoriteBoard(token: String) {
        let url = APIConstants.communityFavoriteBoard.path
        
        HomeRepository.shared.fetchFavoriteBoard(token: token, url: url)
            .observe(on: MainScheduler.instance) // ✅ UI 업데이트를 위해 Main 스레드에서 실행
            .subscribe(onSuccess: { response in
                self.favoriteBoardList.accept(response.result)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadTestData() {
        let testfavoriteBoardList: [FavoriteBoard] = [
            FavoriteBoard(postId: 0, title: "1", boardName: "1"),
            FavoriteBoard(postId: 0, title: "1", boardName: "1")
        ]
        favoriteBoardList.onNext(testfavoriteBoardList)
    }
}

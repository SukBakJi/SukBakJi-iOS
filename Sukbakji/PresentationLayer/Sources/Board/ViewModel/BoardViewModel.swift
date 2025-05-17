//
//  BoardViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 5/15/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardViewModel {
    private let repository = BoardRepository()
    private let disposeBag = DisposeBag()
    
    let latestQnAList = BehaviorRelay<[QnA]>(value: [])
    
    var selectPostItem: Post?
    
    let errorMessage = PublishSubject<String>()
    
    func loadLatestQnA() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        BoardRepository.shared.fetchLatestQnA(token: token)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.latestQnAList.accept(response.result)
            
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func favoriteBoard(isFavorite: Bool) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        let boardId = selectPostItem
        repository.favoriteBoardAddRemove(token: token, boardId: boardId?.postId ?? 0, isFavorite: isFavorite)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

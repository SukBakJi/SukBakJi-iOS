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
    
    var selectPostItem: PostList?
    
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

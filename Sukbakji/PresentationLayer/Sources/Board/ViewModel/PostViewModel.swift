//
//  PostViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 5/15/25.
//

import Foundation
import RxSwift
import RxCocoa

final class PostViewModel {
    private let repository = BoardRepository()
    private let disposeBag = DisposeBag()
    
    let postList = BehaviorRelay<[PostList]>(value: [])
    
    func loadPostList(menu: String, boardName: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchPostList(token: token, menu: menu, boardName: boardName)
            .map { $0.result }
            .subscribe(onSuccess: { [weak self] posts in
                self?.postList.accept(posts)
            })
            .disposed(by: disposeBag)
    }
}

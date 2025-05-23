//
//  MyPostViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 5/23/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPostViewModel {
    private let repository = BoardRepository()
    private let disposeBag = DisposeBag()
    
    let myPostList = BehaviorRelay<[MyPost]>(value: [])
    let scrapList = BehaviorRelay<[MyPost]>(value: [])
    let myCommentList = BehaviorRelay<[MyPost]>(value: [])
    
    func loadmyPostList() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchMyPostList(token: token)
            .map { $0.result }
            .subscribe(onSuccess: { [weak self] posts in
                self?.myPostList.accept(posts)
            })
            .disposed(by: disposeBag)
    }
    
    func loadScrapList() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchScrapList(token: token)
            .map { $0.result }
            .subscribe(onSuccess: { [weak self] posts in
                self?.scrapList.accept(posts)
            })
            .disposed(by: disposeBag)
    }
    
    func loadMyCommentList() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchMyCommentList(token: token)
            .map { $0.result }
            .subscribe(onSuccess: { [weak self] posts in
                self?.myCommentList.accept(posts)
            })
            .disposed(by: disposeBag)
    }
}

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
    
    let postDocterList = BehaviorRelay<[Post]>(value: [])
    let postMasterList = BehaviorRelay<[Post]>(value: [])
    let postEnterList = BehaviorRelay<[Post]>(value: [])
    
    func loadDoctorPostList(boardName: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchPostList(token: token, menu: "박사", boardName: boardName)
            .map { $0.result }
            .subscribe(onSuccess: { [weak self] posts in
                self?.postDocterList.accept(posts)
            })
            .disposed(by: disposeBag)
    }
    
    func loadMasterPostList(boardName: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchPostList(token: token, menu: "석사", boardName: boardName)
            .map { $0.result }
            .subscribe(onSuccess: { [weak self] posts in
                self?.postMasterList.accept(posts)
            })
            .disposed(by: disposeBag)
    }
    
    func loadEnterPostList(boardName: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchPostList(token: token, menu: "진학예정", boardName: boardName)
            .map { $0.result }
            .subscribe(onSuccess: { [weak self] posts in
                self?.postEnterList.accept(posts)
            })
            .disposed(by: disposeBag)
    }
}

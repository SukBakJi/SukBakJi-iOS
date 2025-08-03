//
//  PostViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 5/15/25.
//

import RxSwift
import RxCocoa

final class PostViewModel {
    private let useCase: BoardUseCase
    private let disposeBag = DisposeBag()
    
    let latestQnAList = BehaviorRelay<[QnA]>(value: [])
    let mergedQnAList = BehaviorRelay<[Post]>(value: [])
    
    let postList = BehaviorRelay<[Post]>(value: [])
    let postDocterList = BehaviorRelay<[Post]>(value: [])
    let postMasterList = BehaviorRelay<[Post]>(value: [])
    let postEnterList = BehaviorRelay<[Post]>(value: [])
    
    init(useCase: BoardUseCase = BoardUseCase()) {
        self.useCase = useCase
    }
    
    func loadLatestQnA() {
        useCase.fetchLatestQnA()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] posts in
                self?.latestQnAList.accept(posts)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadPostList(boardName: String) {
        useCase.fetchPostList(menu: "자유", boardName: boardName)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] posts in
                self?.postList.accept(posts)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadDoctorPostList(boardName: String) {
        useCase.fetchPostList(menu: "박사", boardName: boardName)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] posts in
                self?.postDocterList.accept(posts)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadMasterPostList(boardName: String) {
        useCase.fetchPostList(menu: "석사", boardName: boardName)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] posts in
                self?.postMasterList.accept(posts)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadEnterPostList(boardName: String) {
        useCase.fetchPostList(menu: "진학예정", boardName: boardName)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] posts in
                self?.postEnterList.accept(posts)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadAllPosts() {
        loadDoctorPostList(boardName: "질문 게시판")
        loadMasterPostList(boardName: "질문 게시판")
        loadEnterPostList(boardName: "질문 게시판")
        
        Observable.zip(postDocterList, postMasterList, postEnterList)
            .map { $0 + $1 + $2 }
            .bind(to: mergedQnAList)
            .disposed(by: disposeBag)
    }
}

//
//  MyPostViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 5/23/25.
//

import RxSwift
import RxCocoa

final class MyPostViewModel {
    private let useCase: BoardUseCase
    private let disposeBag = DisposeBag()
    
    let myPostList = BehaviorRelay<[MyPost]>(value: [])
    let myCommentList = BehaviorRelay<[MyPost]>(value: [])
    let scrapList = BehaviorRelay<[MyPost]>(value: [])
    
    init(useCase: BoardUseCase = BoardUseCase()) {
        self.useCase = useCase
    }
    
    func loadMyPostList() {
        useCase.fetchMyPostList()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] posts in
                self?.myPostList.accept(posts)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadMyCommentList() {
        useCase.fetchMyCommentList()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] comments in
                self?.myCommentList.accept(comments)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadScrapList() {
        useCase.fetchScrap()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] posts in
                self?.scrapList.accept(posts)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

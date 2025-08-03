//
//  PostDetailViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/4/25.
//

import RxSwift
import RxCocoa

final class PostDetailViewModel {
    private let useCase: BoardUseCase
    private let disposeBag = DisposeBag()
    
    let postDetail = PublishSubject<PostDetail>()
    let postCommentList = BehaviorRelay<[Comment]>(value: [])
    var selectCommentItem: Comment?
    
    let postCreated = PublishSubject<Bool>()
    let postDeleted = PublishSubject<Bool>()
    
    init(useCase: BoardUseCase = BoardUseCase()) {
        self.useCase = useCase
    }
    
    func loadPostDetail(postId: Int) {
        useCase.fetchPostDetail(postId: postId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detail in
                self?.postDetail.onNext(detail)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func createPost(menu: String, boardName: String, title: String, content: String) {
        useCase.createPost(menu: menu, boardName: boardName, title: title, content: content)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.postCreated.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func deletePost(postId: Int) {
        useCase.deletePost(postId: postId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.postDeleted.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func createComment(postId: Int, content: String) {
        useCase.createComment(postId: postId, content: content)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { isSuccess in
                NotificationCenter.default.post(name: .isCommentComplete, object: nil)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func editComment(commentId: Int, content: String) {
        useCase.editComment(commentId: commentId, content: content)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { _ in
                NotificationCenter.default.post(name: .isCommentComplete, object: nil)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

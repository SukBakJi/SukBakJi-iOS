//
//  PostDetailViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/4/25.
//

import RxSwift
import RxCocoa

enum PostEvent {
    case created
    case deleted
}

enum CommentEvent {
    case created
    case edited
}

final class PostDetailViewModel {
    private let useCase: BoardUseCase
    private let disposeBag = DisposeBag()
    
    let postDetail = PublishSubject<PostDetail>()
    let postCommentList = BehaviorRelay<[Comment]>(value: [])
    var selectCommentItem: Comment?
    
    private let postEventRelay = PublishRelay<PostEvent>()
    var postEvent: Signal<PostEvent> { postEventRelay.asSignal() }
    private let commentEventRelay = PublishRelay<CommentEvent>()
    var commentEvent: Signal<CommentEvent> { commentEventRelay.asSignal() }
    
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
            .subscribe(onSuccess: { [weak self] _ in
                self?.postEventRelay.accept(.created)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func deletePost(postId: Int) {
        useCase.deletePost(postId: postId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] _ in
                self?.postEventRelay.accept(.deleted)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func createComment(postId: Int, content: String) {
        useCase.createComment(postId: postId, content: content)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] _ in
                self?.commentEventRelay.accept(.created)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func editComment(commentId: Int, content: String) {
        useCase.editComment(commentId: commentId, content: content)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] _ in
                self?.commentEventRelay.accept(.edited)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

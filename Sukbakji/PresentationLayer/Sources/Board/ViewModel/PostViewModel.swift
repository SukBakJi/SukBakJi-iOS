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
    private let useCase: PostUseCase
    private let disposeBag = DisposeBag()
    
    let postDocterList = BehaviorRelay<[Post]>(value: [])
    let postMasterList = BehaviorRelay<[Post]>(value: [])
    let postEnterList = BehaviorRelay<[Post]>(value: [])
    
    let mergedQnAList = BehaviorRelay<[Post]>(value: [])
    
    let postDetail = PublishSubject<PostDetail>()
    var postCommentList = BehaviorRelay<[Comment]>(value: [])
    var selectCommentItem: Comment?
    
    let commentUpdated = PublishSubject<Bool>()
    let postDeleted = PublishSubject<Bool>()
    let errorMessage = PublishSubject<String>()
    
    init(useCase: PostUseCase = PostUseCase()) {
        self.useCase = useCase
    }
    
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
    
    func loadAllPosts() {
        loadDoctorPostList(boardName: "질문 게시판")
        loadMasterPostList(boardName: "질문 게시판")
        loadEnterPostList(boardName: "질문 게시판")
        
        Observable.zip(postDocterList, postMasterList, postEnterList)
            .map { $0 + $1 + $2 }
            .bind(to: mergedQnAList)
            .disposed(by: disposeBag)
    }
    
    func loadPostDetail(postId: Int) {
        useCase.fetchPostDetail(postId: postId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detail in
                self?.postDetail.onNext(detail)
            }, onFailure: { [weak self] error in
                self?.errorMessage.onNext("프로필 로딩 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func enrollComment(postId: Int?, content: String?) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        let params = [
            "postId": postId!,
            "content": content!,
        ] as [String : Any]
        
        repository.fetchCommentEnroll(token: token, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                NotificationCenter.default.post(name: .isCommentComplete, object: nil)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadEditComment(commentId: Int, content: String) {
        useCase.editComment(commentId: commentId, content: content)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.commentUpdated.onNext(isSuccess)
                NotificationCenter.default.post(name: .isCommentComplete, object: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func enrollPost(menu: String, boardName: String, title: String, content: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        let params = [
            "menu": menu,
            "boardName": boardName,
            "title": title,
            "content": content
        ] as [String : Any]
        
        repository.fetchPostEnroll(token: token, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                
            }, onFailure: { error in
                
            })
            .disposed(by: disposeBag)
    }
    
    func deletePost(postId: Int) {
        useCase.deletePost(postId: postId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.postDeleted.onNext(isSuccess)
                print("성공")
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

//
//  DirectoryViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 6/13/25.
//

import RxSwift
import RxCocoa

class DirectoryViewModel {
    private let repository = DirectoryRepository()
    private let disposeBag = DisposeBag()
    
    let topicList = PublishSubject<Topic>()
    var topicItems = BehaviorRelay<[String]>(value: [])
    let reviewList = BehaviorRelay<[LabReview]>(value: [])
    let reviewSearchList = BehaviorRelay<[LabReview]>(value: [])
    let errorMessage = PublishSubject<String>()
    
    func loadInterestTopic() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchInterestTopics(token: token)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] topic in
                self?.topicList.onNext(topic.result)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadReviewList(offset: Int32, limit: Int32) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchLabsReviews(token: token, offset: offset, limit: limit)
            .map { $0.result }
            .subscribe(onSuccess: { [weak self] reviews in
                guard let self = self else { return }
                let current = self.reviewList.value
                self.reviewList.accept(current + reviews)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadReviewSearch(professorName: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchReviewsSearch(token: token, professorName: professorName)
            .map { $0.result }
            .subscribe(onSuccess: { [weak self] reviews in
                guard let self = self else { return }
                self.reviewSearchList.accept(reviews)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

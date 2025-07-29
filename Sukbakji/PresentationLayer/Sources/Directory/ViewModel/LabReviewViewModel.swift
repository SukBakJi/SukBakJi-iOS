//
//  LabReviewViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 7/29/25.
//

import RxSwift
import RxCocoa

class LabReviewViewModel {
    private let repository = DirectoryRepository()
    private let disposeBag = DisposeBag()
    
    let reviewList = BehaviorRelay<[LabReview]>(value: [])
    var reviewItems = BehaviorRelay<[LabReview]>(value: [])
    
    let reviewSearchList = BehaviorRelay<[LabReview]>(value: [])
    
    let errorMessage = PublishSubject<String>()
    
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

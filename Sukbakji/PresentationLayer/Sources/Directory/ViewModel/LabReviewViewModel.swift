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
    private let useCase: LabUseCase
    
    let reviewList = BehaviorRelay<[LabReview]>(value: [])
    var reviewItems = BehaviorRelay<[LabReview]>(value: [])
    
    let reviewSearchList = BehaviorRelay<[LabReview]>(value: [])
    
    let reviewPosted = PublishSubject<Bool>()
    
    let errorMessage = PublishSubject<String>()
    
    init(useCase: LabUseCase = LabUseCase()) {
        self.useCase = useCase
    }
    
    func loadReviewList(offset: Int32, limit: Int32) {
        useCase.fetchLabReview(offset: offset, limit: limit)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] reviews in
                guard let self = self else { return }
                let current = self.reviewList.value
                self.reviewList.accept(current + reviews)
            }, onFailure: { [weak self] error in
                self?.errorMessage.onNext("\(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func postLabReview(labId: Int, content: String, leadershipStyle: String, salaryLevel: String, autonomy: String) {
        useCase.postLabReview(lab_id: labId, content: content, leadershipStyle: leadershipStyle, salaryLevel: salaryLevel, autonomy: autonomy)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.reviewPosted.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadReviewSearch(professorName: String) {
        useCase.fetchReviewSearch(professorName: professorName)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] reviews in
                guard let self = self else { return }
                self.reviewSearchList.accept(reviews)
            }, onFailure: { [weak self] error in
                self?.errorMessage.onNext("\(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

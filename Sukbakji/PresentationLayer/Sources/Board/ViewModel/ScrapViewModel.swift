//
//  ScrapViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 5/28/25.
//

import RxSwift
import RxCocoa

final class ScrapViewModel {
    private let useCase: BoardUseCase
    private let disposeBag = DisposeBag()
    
    private let isScrappedRelay = BehaviorRelay<Bool>(value: false)
    var isScrapped: Driver<Bool> { isScrappedRelay.asDriver() }
    let scrapResult = PublishSubject<Bool>()
    
    init(useCase: BoardUseCase = BoardUseCase()) { self.useCase = useCase }
    
    func loadScrapList(postId: Int) {
        useCase.fetchScrap()
            .map { posts in posts.contains { $0.postId == postId } }
            .asDriver(onErrorJustReturn: false)
            .drive(isScrappedRelay)
            .disposed(by: disposeBag)
    }
        
    func scrapPost(postId: Int) {
        useCase.createScrap(postId: postId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.scrapResult.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}



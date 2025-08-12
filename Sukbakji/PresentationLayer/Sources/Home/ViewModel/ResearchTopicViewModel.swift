//
//  ResearchTopicViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ResearchTopicViewModel {
    private let useCase: DirectoryUseCase
    private let disposeBag = DisposeBag()
    
    var topicItems = BehaviorRelay<[String]>(value: [])
    
    init(useCase: DirectoryUseCase = DirectoryUseCase()) {
        self.useCase = useCase
    }
    
    func loadInterestTopic() {
        useCase.fetchInterestTopics()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] topics in
                self?.topicItems.accept(topics)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

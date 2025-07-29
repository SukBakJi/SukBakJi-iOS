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
    private let repository = DirectoryRepository()
    private let disposeBag = DisposeBag()
    
    var selectResearchTopicItem: String?
    var ResearchTopicItems = BehaviorRelay<[String]>(value: [])
    
    let topicList = PublishSubject<Topic>()
    var topicItems = BehaviorRelay<[String]>(value: [])
    
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
}

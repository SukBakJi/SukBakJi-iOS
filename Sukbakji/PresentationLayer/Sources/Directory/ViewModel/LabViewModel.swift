//
//  LabViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 6/21/25.
//

import RxSwift
import RxCocoa

class LabViewModel {
    private let repository = DirectoryRepository()
    private let disposeBag = DisposeBag()
    
    let labList = BehaviorRelay<[LabSearch]>(value: [])
    let errorMessage = PublishSubject<String>()
    
    func loadLabList(topicName: String, page: Int32, size: Int32) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchLabsSearch(token: token, topicName: topicName, page: page, size: size)
            .map { $0.result.responseDTOList }
            .subscribe(onSuccess: { labs in
                print("성공")
                self.labList.accept(labs)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

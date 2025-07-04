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
    private let useCase: LabUseCase
    
    let labInfo = PublishSubject<LabInfo>()
    let labList = BehaviorRelay<[LabSearch]>(value: [])
    var researchTopicItems = BehaviorRelay<[String]>(value: [])
    let errorMessage = PublishSubject<String>()
    
    init(useCase: LabUseCase = LabUseCase()) {
        self.useCase = useCase
    }
    
    func loadLabInfo(labId: Int) {
        useCase.fetchLabInfo(labId: labId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] lab in
                self?.labInfo.onNext(lab)
            }, onFailure: { [weak self] error in
                self?.errorMessage.onNext("프로필 로딩 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
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

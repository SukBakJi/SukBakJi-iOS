//
//  LabInfoViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 6/21/25.
//

import RxSwift
import RxCocoa

class LabInfoViewModel {
    private let disposeBag = DisposeBag()
    private let useCase: DirectoryUseCase
    
    let labInfo = PublishSubject<LabInfo>()
    let labDetail = PublishSubject<LabDetail>()
    let labList = BehaviorRelay<[LabSearch]>(value: [])
    
    var researchTopicItems = BehaviorRelay<[String]>(value: [])
    
    init(useCase: DirectoryUseCase = DirectoryUseCase()) {
        self.useCase = useCase
    }
    
    func loadLabInfo(labId: Int) {
        useCase.fetchLabInfo(labId: labId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] lab in
                self?.labInfo.onNext(lab)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadLabDetail(labId: Int) {
        useCase.fetchLabDetail(labId: labId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] lab in
                self?.labDetail.onNext(lab)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadLabSearch(topicName: String, page: Int32, size: Int32, completion: @escaping (Bool) -> Void) {
        useCase.fetchLabSearch(topicName: topicName, page: page, size: size)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] labs in
                guard let self = self else { return }
                let current = self.labList.value
                if current.suffix(labs.count) == labs {
                    completion(false)
                    return
                }
                self.labList.accept(labs)
                completion(true)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
                completion(false)
            })
            .disposed(by: disposeBag)
    }
}

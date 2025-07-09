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
    let labDetail = PublishSubject<LabDetail>()
    let labList = BehaviorRelay<[LabSearch]>(value: [])
    var researchTopicItems = BehaviorRelay<[String]>(value: [])
    var reviewItems = BehaviorRelay<[LabReview]>(value: [])
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
    
    func loadLabDetail(labId: Int) {
        useCase.fetchLabDetail(labId: labId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] lab in
                self?.labDetail.onNext(lab)
            }, onFailure: { [weak self] error in
                self?.errorMessage.onNext("프로필 로딩 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadLabSearch(topicName: String, page: Int32, size: Int32, completion: @escaping (Bool) -> Void) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            completion(false)
            return
        }
        
        repository.fetchLabsSearch(token: token, topicName: topicName, page: page, size: size)
            .map { $0.result.responseDTOList }
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
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
                completion(false)
            })
            .disposed(by: disposeBag)
    }
    
    func loadFavoriteLabList(labId: Int, scrapButton: UIButton) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchFavoriteLabs(token: token)
            .map { $0.result }
            .subscribe(onSuccess: { labs in
                let isScrapped = labs.contains { $0.labId == labId }
                
                DispatchQueue.main.async {
                    let imageName = isScrapped ? "Sukbakji_Bookmark2" : "Sukbakji_Bookmark"
                    scrapButton.setImage(UIImage(named: imageName), for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func favoriteLab(labId: Int) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.favoriteLabToggle(token: token, labId: labId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

//
//  UnivDetailViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/12/25.
//

import RxSwift
import RxCocoa

final class UnivDetailViewModel {
    private let useCase: CalendarUseCase
    private let disposeBag = DisposeBag()
    
    let univCreated = PublishSubject<Bool>()
    let univEdited = PublishSubject<Bool>()
    let univDeleted = PublishSubject<Bool>()
    let univSelectDeleted = PublishSubject<Bool>()
    let univAllDeleted = PublishSubject<Bool>()
    
    let selectedUnivAll = BehaviorRelay<Bool>(value: false)
    
    init(useCase: CalendarUseCase = CalendarUseCase()) {
        self.useCase = useCase
    }
    
    func createUniv(memberId: Int, univId: Int, season: String, method: String) {
        useCase.createUniv(memberId: memberId, univId: univId, season: season, method: method)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.univCreated.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func editUniv(univId: Int, season: String, method: String) {
        useCase.editUniv(univId: univId, season: season, method: method)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.univEdited.onNext(isSuccess)
                NotificationCenter.default.post(name: .isUnivEditComplete, object: nil)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteUniv(memberId: Int, univId: Int, season: String, method: String) {
        useCase.deleteUniv(memberId: memberId, univId: univId, season: season, method: method)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.univDeleted.onNext(isSuccess)
                NotificationCenter.default.post(name: .isUnivDeleteComplete, object: nil)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteSelectedUniv(univIds: [Int]) {
        useCase.deleteSelectedUniv(univIds: univIds)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.univSelectDeleted.onNext(isSuccess)
                NotificationCenter.default.post(name: .isUnivDeleteSelectedComplete, object: nil)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteAllUniv() {
        useCase.deleteAllUniv()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.univAllDeleted.onNext(isSuccess)
                NotificationCenter.default.post(name: .isUnivDeleteAllComplete, object: nil)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func toggleSelectState() {
        let newState = !selectedUnivAll.value
        selectedUnivAll.accept(newState)
    }
}

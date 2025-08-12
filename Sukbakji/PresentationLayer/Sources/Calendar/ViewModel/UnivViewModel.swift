//
//  UnivViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/19/24.
//

import RxSwift
import RxCocoa

final class UnivViewModel {
    private let useCase: CalendarUseCase
    private let disposeBag = DisposeBag()
    
    let univSearchList = BehaviorRelay<[UnivSearchList]>(value: [])
    let selectUnivItem = BehaviorRelay<UnivSearchList?>(value: nil)
    
    let recruitTypes = BehaviorRelay<[String]>(value: [])
    
    let univList = BehaviorRelay<[UnivList]>(value: [])
    var selectUnivList: UnivList?
    
    init(useCase: CalendarUseCase = CalendarUseCase()) {
        self.useCase = useCase
    }
    
    func loadUnivSearch(keyword: String) {
        useCase.fetchUnivSearch(keyword: keyword)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] univs in
                self?.univSearchList.accept(univs)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func selectUniversity(_ univ: UnivSearchList?) {
        selectUnivItem.accept(univ)
    }
    
    func loadUnivMethod(univId: Int) {
        useCase.fetchUnivMethod(univId: univId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] methods in
                self?.recruitTypes.accept(methods)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadUnivList() {
        useCase.fetchUnivList()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] univs in
                self?.univList.accept(univs)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadUnivName(univId: Int) -> Observable<String> {
        return Observable.create { observer in
            self.useCase.fetchUnivName(univId: univId)
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: { univName in
                    observer.onNext(univName)
                    observer.onCompleted()
                }, onFailure: { error in
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

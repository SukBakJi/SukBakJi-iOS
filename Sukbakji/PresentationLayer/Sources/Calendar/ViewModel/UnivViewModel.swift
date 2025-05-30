//
//  UnivViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UnivViewModel {
    private let repository = CalendarRepository()
    private let disposeBag = DisposeBag()
    
    let univSearchList = BehaviorRelay<[UnivSearchList]>(value: [])
    let selectUnivItem = BehaviorRelay<UnivSearchList?>(value: nil)
    
    let recruitTypes = BehaviorRelay<[String]>(value: [])
    
    let univEnrolled = PublishSubject<Bool>()
    
    func loadUnivSearch(keyword: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchUnivSearch(token: token, keyword: keyword)
            .map { $0.result.universityList }
            .subscribe(onSuccess: { [weak self] univs in
                self?.univSearchList.accept(univs)
            })
            .disposed(by: disposeBag)
    }
    
    func selectUniversity(_ univ: UnivSearchList?) {
        selectUnivItem.accept(univ)
    }
    
    func loadUnivName(univId: Int) -> Observable<String> {
        return Observable.create { observer in
            guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            self.repository.fetchUnivName(token: token, univId: univId)
                .map { $0.result.univName }
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
    
    func loadUnivMethod(univId: Int) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchUnivMethod(token: token, univId: univId)
            .map { $0.result.methodList.map { $0.method } }
            .subscribe(onSuccess: { [weak self] methods in
                self?.recruitTypes.accept(methods)
            })
            .disposed(by: disposeBag)
    }
    
    func enrollUniv(memberId: Int?, univId: Int?, season: String?, method: String?) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        let params = [
            "memberId": memberId!,
            "univId": univId!,
            "season": season!,
            "method": method!
        ] as [String : Any]
        
        repository.fetchUnivEnroll(token: token, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.univEnrolled.onNext(true)
            }, onFailure: { error in
                self.univEnrolled.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}

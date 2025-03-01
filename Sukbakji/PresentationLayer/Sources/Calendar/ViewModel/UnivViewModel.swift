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
    private let disposeBag = DisposeBag()
    
    let selectUnivItem = BehaviorRelay<UnivSearchList?>(value: nil)
    let univSearchList = BehaviorRelay<[UnivSearchList]>(value: [])
    
    let recruitTypes = BehaviorRelay<[String]>(value: [])
    let selectedRecruitType = BehaviorRelay<String?>(value: nil)
    
    let univEnrolled = PublishSubject<Bool>()
    
    func loadUnivSearch(keyword: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        CalendarRepository.shared.fetchUnivSearch(token: token, keyword: keyword)
            .map { $0.result.universityList }
            .subscribe(onSuccess: { [weak self] univs in
                self?.univSearchList.accept(univs)
            })
            .disposed(by: disposeBag)
    }
    
    func selectUniversity(_ univ: UnivSearchList?) {
        selectUnivItem.accept(univ)
    }
    
    func loadUnivMethod(univId: Int) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        CalendarRepository.shared.fetchUnivMethod(token: token, univId: univId)
            .map { $0.result.methodList.map { $0.method } }
            .subscribe(onSuccess: { [weak self] methods in
                self?.recruitTypes.accept(methods)
            })
            .disposed(by: disposeBag)
    }
    
    func loadUnivEnroll(memberId: Int?, univId: Int?, season: String?, method: String?) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        let params = [
            "memberId": memberId!,
            "univId": univId!,
            "season": season!,
            "method": method!
        ] as [String : Any]
        
        CalendarRepository.shared.fetchUnivEnroll(token: token, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.univEnrolled.onNext(true)
            }, onFailure: { error in
                self.univEnrolled.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}

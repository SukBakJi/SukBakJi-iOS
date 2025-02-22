//
//  UnivSearchViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UnivSearchViewModel {
    private let repository = CalendarRepository()
    private let disposeBag = DisposeBag()
    
    let selectUnivItem = BehaviorRelay<UnivSearchList?>(value: nil)
    let univSearchList = BehaviorRelay<[UnivSearchList]>(value: [])
    
    func loadUnivSearch(keyword: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        repository.fetchUnivSearch(token: token, keyword: keyword)
            .map { $0.result.universityList }
            .subscribe(onSuccess: { [weak self] schedules in
                self?.univSearchList.accept(schedules)
            })
            .disposed(by: disposeBag)
    }
    
    func selectUniversity(_ univ: UnivSearchList?) {
        selectUnivItem.accept(univ)
    }
}

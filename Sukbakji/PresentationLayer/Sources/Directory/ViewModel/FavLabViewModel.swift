//
//  FavLabViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import RxSwift
import RxCocoa

class FavLabViewModel {
    private let useCase: DirectoryUseCase
    private let disposeBag = DisposeBag()
    
    let favLabList = BehaviorRelay<[FavoriteLab]>(value: [])
    let selectedLabAll = BehaviorRelay<Bool>(value: false)
    
    init(useCase: DirectoryUseCase = DirectoryUseCase()) {
        self.useCase = useCase
    }
    
    func loadFavoriteLab() {
        useCase.fetchLabFavorite()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] schedules in
                self?.favLabList.accept(schedules)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func toggleSelectState() {
        let newState = !selectedLabAll.value
        selectedLabAll.accept(newState) // 상태 변경
    }
}

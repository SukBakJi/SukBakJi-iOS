//
//  FavBoardViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import RxSwift
import RxCocoa

class FavBoardViewModel {
    private let useCase: HomeUseCase
    private let disposeBag = DisposeBag()
    
    let favBoardList = BehaviorRelay<[FavoriteBoard]>(value: [])
    
    init(useCase: HomeUseCase = HomeUseCase()) {
        self.useCase = useCase
    }
    
    func loadFavoriteBoard() {
        useCase.fetchFavoriteBoard()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] boards in
                self?.favBoardList.accept(boards)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

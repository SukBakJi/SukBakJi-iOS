//
//  FavViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/25.
//

import RxSwift
import RxCocoa

final class FavViewModel {
    private let useCase: BoardUseCase
    private let disposeBag = DisposeBag()
    
    let favoriteBoardList = BehaviorRelay<[Favorite]>(value: [])
    
    init(useCase: BoardUseCase = BoardUseCase()) {
        self.useCase = useCase
    }
    
    func loadFavoriteBoard() {
        useCase.fetchFavoriteBoard()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detail in
                self?.favoriteBoardList.accept(detail)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func favoriteBoard(boardId: Int, isFav: Bool) {
        useCase.favoriteBoard(boardId: boardId, isFav: isFav)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] _ in
                self?.loadFavoriteBoard()
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

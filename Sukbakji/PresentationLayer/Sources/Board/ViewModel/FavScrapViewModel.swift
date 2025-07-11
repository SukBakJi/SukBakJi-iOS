//
//  FavScrapViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 5/28/25.
//

import Foundation
import RxSwift
import RxCocoa

final class FavScrapViewModel {
    private let repository = BoardRepository()
    private let useCase: BoardUseCase
    private let disposeBag = DisposeBag()
    
    let boardsFavoriteList = BehaviorRelay<[Favorite]>(value: [])
    
    let errorMessage = PublishSubject<String>()
    
    init(useCase: BoardUseCase = BoardUseCase()) {
        self.useCase = useCase
    }
    
    func favoriteBoard(boardId: Int, isFav: Bool) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.favoriteBoardToggle(token: token, boardId: boardId, isFav: isFav)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.loadBoardsFavorite()
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadBoardsFavorite() {
        useCase.fetchBoardsFavorite()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detail in
                self?.boardsFavoriteList.accept(detail)
            }, onFailure: { [weak self] error in
                self?.errorMessage.onNext("즐겨찾기 로딩 실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadScrapList(postId: Int, scrapButton: UIButton) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchScrapList(token: token)
            .map { $0.result }
            .subscribe(onSuccess: { posts in
                let isScrapped = posts.contains { $0.postId == postId }
                
                DispatchQueue.main.async {
                    let imageName = isScrapped ? "Sukbakji_Bookmark2" : "Sukbakji_Bookmark"
                    scrapButton.setImage(UIImage(named: imageName), for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
        
    
    func scrapPost(postId: Int) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchScrapToggle(token: token, postId: postId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}



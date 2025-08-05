//
//  ScrapViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 5/28/25.
//

import RxSwift
import RxCocoa

final class ScrapViewModel {
    private let useCase: BoardUseCase
    private let disposeBag = DisposeBag()
    
    let scrapResult = PublishSubject<Bool>()
    
    init(useCase: BoardUseCase = BoardUseCase()) {
        self.useCase = useCase
    }
    
    func loadScrapList(postId: Int, scrapButton: UIButton) {
        useCase.fetchScrap()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { posts in
                let isScrapped = posts.contains { $0.postId == postId }
                
                DispatchQueue.main.async {
                    let imageName = isScrapped ? "Sukbakji_Bookmark2" : "Sukbakji_Bookmark"
                    scrapButton.setImage(UIImage(named: imageName), for: .normal)
                }
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
        
    func scrapPost(postId: Int) {
        useCase.createScrap(postId: postId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.scrapResult.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}



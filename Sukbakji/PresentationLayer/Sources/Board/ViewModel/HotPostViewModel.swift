//
//  HotPostViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import RxSwift
import RxCocoa

class HotPostViewModel {
    private let useCase: HomeUseCase
    private let disposeBag = DisposeBag()
    
    let hotPostList = BehaviorRelay<[HotPost]>(value: [])
    var selectPostItem: HotPost?
    
    init(useCase: HomeUseCase = HomeUseCase()) {
        self.useCase = useCase
    }
    
    func loadHotPost() {
        useCase.fetchHotPost()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] posts in
                self?.hotPostList.accept(posts)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

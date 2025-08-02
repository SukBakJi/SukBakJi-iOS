//
//  LabFavoriteViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 7/29/25.
//

import RxSwift
import RxCocoa

class LabFavoriteViewModel {
    private let repository = DirectoryRepository()
    private let disposeBag = DisposeBag()
    private let useCase: LabUseCase
    
    let favoritePosted = PublishSubject<Bool>()
    
    let errorMessage = PublishSubject<String>()
    
    init(useCase: LabUseCase = LabUseCase()) {
        self.useCase = useCase
    }
    
    func loadFavoriteLabList(labId: Int, scrapButton: UIButton) {
        useCase.fetchLabFavorite()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { labs in
                let isScrapped = labs.contains { $0.labId == labId }
                
                DispatchQueue.main.async {
                    let imageName = isScrapped ? "Sukbakji_Bookmark2" : "Sukbakji_Bookmark"
                    scrapButton.setImage(UIImage(named: imageName), for: .normal)
                }
            }, onFailure: { [weak self] error in
                self?.errorMessage.onNext("\(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func postLabFavorite(labId: Int) {
        useCase.postLabFavorite(labId: labId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.favoritePosted.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

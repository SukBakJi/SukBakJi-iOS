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
    
    func loadFavoriteLabList(labId: Int, scrapButton: UIButton) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchFavoriteLabs(token: token)
            .map { $0.result }
            .subscribe(onSuccess: { labs in
                let isScrapped = labs.contains { $0.labId == labId }
                
                DispatchQueue.main.async {
                    let imageName = isScrapped ? "Sukbakji_Bookmark2" : "Sukbakji_Bookmark"
                    scrapButton.setImage(UIImage(named: imageName), for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func favoriteLab(labId: Int) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.favoriteLabToggle(token: token, labId: labId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

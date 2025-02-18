//
//  FavoriteLabViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import RxSwift
import RxCocoa

final class FavoriteLabViewModel {
    
    private let disposeBag = DisposeBag()
    
    let favoriteLabList = PublishSubject<[FavoriteLab]>()
    let errorMessage = PublishSubject<String>()
    
    func loadFavoriteLab(token: String) {
        let url = APIConstants.labsFavoriteLab.path
        
        HomeRepository.shared.fetchFavoriteLab(token: token, url: url)
            .observe(on: MainScheduler.instance) // ✅ UI 업데이트를 위해 Main 스레드에서 실행
            .subscribe(onSuccess: { response in
                self.favoriteLabList.onNext(response.result)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadTestData() {
        let testFavoriteLabList: [FavoriteLab] = [
            FavoriteLab(labId: 0, labName: "1", universityName: "1", departmentName: "1", professorName: "1", researchTopics: ["인공지능", "AI"]),
            FavoriteLab(labId: 0, labName: "1", universityName: "1", departmentName: "1", professorName: "1", researchTopics: ["인공지능", "AI"])
        ]
        favoriteLabList.onNext(testFavoriteLabList)
    }
}

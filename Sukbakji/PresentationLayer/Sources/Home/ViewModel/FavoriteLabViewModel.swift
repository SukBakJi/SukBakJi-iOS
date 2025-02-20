//
//  FavoriteLabViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import RxSwift
import RxCocoa

class FavoriteLabViewModel {
    
    private let disposeBag = DisposeBag()
    
    let favoriteLabList = BehaviorRelay<[FavoriteLab]>(value: [])
    let errorMessage = PublishSubject<String>()
    
    func loadFavoriteLab(token: String) {
        let url = APIConstants.labsFavoriteLab.path
        
        HomeRepository.shared.fetchFavoriteLab(token: token, url: url)
            .observe(on: MainScheduler.instance) // ✅ UI 업데이트를 위해 Main 스레드에서 실행
            .subscribe(onSuccess: { response in
                self.favoriteLabList.accept(response.result)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadTestData() {
        let testFavoriteLabList: [FavoriteLab] = [
            FavoriteLab(labId: 0, labName: "화학에너지융합학부 에너지재료연구실", universityName: "성신여자대학교", departmentName: "성신여자대학교 화학에너지융합학부", professorName: "구본재", researchTopics: ["인공지능", "AI"]),
            FavoriteLab(labId: 0, labName: "화학에너지융합학부 에너지재료연구실", universityName: "성신여자대학교", departmentName: "성신여자대학교 화학에너지융합학부", professorName: "구본재", researchTopics: ["인공지능", "AI"])
        ]
        favoriteLabList.accept(testFavoriteLabList)
    }
}

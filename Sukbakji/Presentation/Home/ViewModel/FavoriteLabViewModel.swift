//
//  FavoriteLabViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteLabViewModel {
    var selectFavoriteLabItem: FavoriteLab?
    var favoriteLabItems: Observable<[FavoriteLab]> = Observable.just([])
    
    let favoriteLabList: [FavoriteLab] = [
        FavoriteLab(labId: 0, labName: "1", universityName: "1", departmentName: "1", professorName: "1", researchTopics: ["인공지능", "AI"]),
        FavoriteLab(labId: 0, labName: "1", universityName: "1", departmentName: "1", professorName: "1", researchTopics: ["인공지능", "AI"])
    ]
}

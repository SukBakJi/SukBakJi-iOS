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
    var selectFavoriteLabItem: FavoritesLab?
    var favoriteLabItems: Observable<[FavoritesLab]> = Observable.just([])
}

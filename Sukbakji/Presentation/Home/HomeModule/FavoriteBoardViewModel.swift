//
//  FavoriteBoardViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteBoardViewModel {
    var selectFavoriteBoardItem: FavoritesBoard?
    var favoriteBoardItems: Observable<[FavoritesBoard]> = Observable.just([])
}

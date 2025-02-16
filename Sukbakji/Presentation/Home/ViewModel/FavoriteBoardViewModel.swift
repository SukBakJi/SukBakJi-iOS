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
    var selectFavoriteBoardItem: FavoriteBoard?
    var favoriteBoardItems: Observable<[FavoriteBoard]> = Observable.just([])
    
    let favoriteBoardList: [FavoriteBoard] = [
        FavoriteBoard(postId: 0, title: "1", boardName: "1"),
        FavoriteBoard(postId: 0, title: "1", boardName: "1")
    ]
}

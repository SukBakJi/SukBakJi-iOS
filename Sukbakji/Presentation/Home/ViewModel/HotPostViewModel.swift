//
//  HotPostViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HotPostViewModel {
    var selectHotPostItem: HotPost?
    var hotPostItems: Observable<[HotPost]> = Observable.just([])
    
    let HotPostList: [HotPost] = [
        HotPost(postId: 0, menu: "1", boardName: "1", title: "1", content: "1", commentCount: 10, views: 10),
        HotPost(postId: 0, menu: "1", boardName: "1", title: "1", content: "1", commentCount: 10, views: 10)
    ]
}

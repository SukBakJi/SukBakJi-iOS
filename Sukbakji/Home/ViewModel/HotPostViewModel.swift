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
}

//
//  UpComingViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UpComingViewModel {
    var selectUpComingItem: UpComingResult?
    var upComingItems: Observable<[UpComingResult]> = Observable.just([])
}

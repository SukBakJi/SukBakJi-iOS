//
//  UnivSearchViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UnivSearchViewModel {
    var selectUnivSearchItem: UnivSearchList?
    var univSearchItems: Observable<[UnivSearchList]> = Observable.just([])
}

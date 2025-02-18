//
//  UnivCalendarViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 1/2/25.
//

import Foundation
import RxSwift
import RxCocoa

final class UnivCalendarViewModel {
    var selectUnivCalendarItem: UnivList?
    var univCalendarItems: BehaviorRelay<[UnivList]> = BehaviorRelay(value: [])
}

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
    var selectUnivCalendarItem: UnivListResult?
    var univCalendarItems: BehaviorRelay<[UnivListResult]> = BehaviorRelay(value: [])
}

protocol univCalendarDeleteDelegate: AnyObject {
    func univDelete_Tapped(cell: UnivCalendarTableViewCell)
}

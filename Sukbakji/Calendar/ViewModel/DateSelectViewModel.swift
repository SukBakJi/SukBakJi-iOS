//
//  DateSelectViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DateSelectViewModel {
    var selectDateSelectItem: DateSelectList?
    var dateSelectItems: Observable<[DateSelectList]> = Observable.just([])
}

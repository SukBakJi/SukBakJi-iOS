//
//  MyAlarmViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 1/6/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MyAlarmViewModel {
    var selectMyAlarmItem: AlarmListResult?
    var myAlarmItems: Observable<[AlarmListResult]> = Observable.just([])
}

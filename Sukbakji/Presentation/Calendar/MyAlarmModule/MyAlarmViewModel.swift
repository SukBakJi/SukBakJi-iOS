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
    var myAlarmItems: BehaviorRelay<[AlarmListResult]> = BehaviorRelay(value: [])
    
    func alarmSwitchToggled(at index: Int, isOn: Int) {
        var currentItems = myAlarmItems.value // 현재 값 가져오기
        guard index >= 0, index < currentItems.count else { return }
        
        currentItems[index].onoff = isOn // 스위치 상태 업데이트
        myAlarmItems.accept(currentItems) // 변경된 값 반영
        
        print("✅ Alarm \(currentItems[index].alarmName) is now \((isOn == 0) ? "OFF" : "ON")")
    }
}


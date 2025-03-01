//
//  AlarmViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 1/6/25.
//

import Foundation
import RxSwift
import RxCocoa

final class AlarmViewModel {
    private let repository = CalendarRepository()
    private let disposeBag = DisposeBag()
    
    var alarmItems: BehaviorRelay<[AlarmList]> = BehaviorRelay(value: [])
    var selectAlarmItem: AlarmList?
    
    func fetchMyAlarms() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        repository.fetchAlarmList(token: token)
            .map { $0.result.alarmList }
            .subscribe(onSuccess: { [weak self] alarm in
                self?.alarmItems.accept(alarm)
            })
            .disposed(by: disposeBag)
    }
    
    func toggleAlarm(at index: Int, isOn: Bool) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        let alarmItem = alarmItems.value[index]
        repository.fetchAlarmPatch(token: token, alarmId: alarmItem.alarmId, isOn: isOn)
            .subscribe(onSuccess: { _ in
                var updatedItems = self.alarmItems.value
                updatedItems[index].onoff = isOn ? 1 : 0
                self.alarmItems.accept(updatedItems)
            }, onFailure: { error in
                print("❌ 오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func alarmSwitchToggled(at index: Int, isOn: Int) {
        var currentItems = alarmItems.value // 현재 값 가져오기
        guard index >= 0, index < currentItems.count else { return }
        
        currentItems[index].onoff = isOn // 스위치 상태 업데이트
        alarmItems.accept(currentItems) // 변경된 값 반영
        
        print("✅ Alarm \(currentItems[index].alarmName) is now \((isOn == 0) ? "OFF" : "ON")")
    }
}


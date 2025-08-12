//
//  AlarmViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 1/6/25.
//

import RxSwift
import RxCocoa

final class AlarmViewModel {
    private let useCase: CalendarUseCase
    private let disposeBag = DisposeBag()
    
    init(useCase: CalendarUseCase = CalendarUseCase()) {
        self.useCase = useCase
    }
    
    let alarmList = BehaviorRelay<[AlarmList]>(value: [])
    var selectAlarmItem: AlarmList?
    
    let univItems = BehaviorRelay<[String]>(value: [])
    
    func loadAlarmList() {
        useCase.fetchAlarmList()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] alarms in
                self?.alarmList.accept(alarms)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func toggleAlarm(at index: Int, alarmId: Int, isOn: Bool) {
        useCase.onOffAlarm(alarmId: alarmId, isOn: isOn)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { isSuccess in
                var updatedItems = self.alarmList.value
                updatedItems[index].onoff = isOn ? 1 : 0
                self.alarmList.accept(updatedItems)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadAlarmUniv() {
        useCase.fetchAlarmUniv()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] univs in
                self?.univItems.accept(univs)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

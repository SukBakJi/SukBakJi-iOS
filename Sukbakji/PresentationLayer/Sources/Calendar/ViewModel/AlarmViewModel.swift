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
    
    let alarmEnrolled = PublishSubject<Bool>()
    
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
    
    func loadAlarmEnroll(memberId: Int?, univName: String?, name: String?, date: String?, time: String?) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        let params = [
            "memberId": memberId!,
            "univName": univName!,
            "name": name!,
            "date": date!,
            "time": time!,
            "onoff": 1
        ] as [String : Any]
        
        repository.fetchAlarmEnroll(token: token, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.alarmEnrolled.onNext(true)
                NotificationCenter.default.post(name: .isAlarmComplete, object: nil)
            }, onFailure: { error in
                self.alarmEnrolled.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}

protocol myAlarmSwitchDelegate: AnyObject {
    func alarmSwitchToggled(cell: MyAlarmTableViewCell, isOn: Bool)
    func editToggled(cell: MyAlarmTableViewCell)
}

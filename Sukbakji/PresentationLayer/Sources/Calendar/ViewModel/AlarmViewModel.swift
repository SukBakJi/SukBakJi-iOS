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
    
    let alarmItems = BehaviorRelay<[AlarmList]>(value: [])
    var selectAlarmItem: AlarmList?
    
    let univItems = BehaviorRelay<[String]>(value: [])
    
    var patchAlarmItem: AlarmPatch?
    
    let alarmEnrolled = PublishSubject<Bool>()
    let alarmDeleted = PublishSubject<Bool>()
    
    func loadMyAlarms() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchAlarmList(token: token)
            .map { $0.result.alarmList }
            .subscribe(onSuccess: { [weak self] alarmList in
                self?.alarmItems.accept(alarmList)
            })
            .disposed(by: disposeBag)
    }
    
    func loadAlarmUniv() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchAlarmUniv(token: token)
            .map { $0.result }
            .subscribe(onSuccess: { [weak self] univList in
                self?.univItems.accept(univList)
            })
            .disposed(by: disposeBag)
    }
    
    func toggleAlarm(at index: Int, isOn: Bool) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        let alarmItem = selectAlarmItem
        repository.fetchAlarmOnOff(token: token, alarmId: alarmItem?.alarmId ?? 0, isOn: isOn)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                var updatedItems = self.alarmItems.value
                updatedItems[index].onoff = isOn ? 1 : 0
                self.alarmItems.accept(updatedItems)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func enrollAlarm(memberId: Int?, univName: String?, name: String?, date: String?, time: String?) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
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
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func editAlarm(memberId: Int?, alarmId: Int?, univName: String?, name: String?, date: String?, time: String?, onoff: Int?) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        let params = [
            "memberId": memberId!,
            "univName": univName!,
            "name": name!,
            "date": date!,
            "time": time!,
            "onoff": onoff!
        ] as [String : Any]
        
        repository.fetchAlarmEdit(token: token, alarmId: alarmId!, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                NotificationCenter.default.post(name: .isAlarmEditComplete, object: nil)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteAlarm(alarmId: Int?) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }

        repository.fetchAlarmDelete(token: token, alarmId: alarmId!)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.alarmDeleted.onNext(true)
                NotificationCenter.default.post(name: .isAlarmDeleteComplete, object: nil)
            }, onFailure: { error in
                self.alarmDeleted.onNext(false)
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

protocol myAlarmSwitchDelegate: AnyObject {
    func alarmSwitchToggled(cell: MyAlarmTableViewCell, isOn: Bool)
    func editToggled(cell: MyAlarmTableViewCell)
}

//
//  CalendarViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 2/21/25.
//

import Foundation
import RxSwift
import RxCocoa

class CalendarViewModel {
    private let repository = CalendarRepository()
    private let disposeBag = DisposeBag()
    
    let univList = BehaviorRelay<[UnivList]>(value: [])
    let upComingSchedules = BehaviorRelay<[UpComingList]>(value: [])
    let dateSelectSchedules = BehaviorRelay<[DateSelectList]>(value: [])
    let alarmDates = BehaviorRelay<[AlarmList]>(value: [])
    
    func loadUnivList() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        repository.fetchUnivList(token: token)
            .map { $0.result.univList }
            .subscribe(onSuccess: { [weak self] univList in
                self?.univList.accept(univList)
            })
            .disposed(by: disposeBag)
    }
    
    func loadUpComingSchedule() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        repository.fetchUpComing(token: token)
            .map { $0.result.scheduleList.filter { $0.dday >= 0 && $0.dday <= 10 } }
            .subscribe(onSuccess: { [weak self] schedules in
                self?.upComingSchedules.accept(schedules)
            })
            .disposed(by: disposeBag)
    }
    
    func loadDateSelect(date: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        repository.fetchDateSelect(token: token, date: date)
            .map { $0.result.scheduleList }
            .subscribe(onSuccess: { [weak self] schedules in
                self?.dateSelectSchedules.accept(schedules)
            })
            .disposed(by: disposeBag)
    }
    
    func loadAlarmList() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        repository.fetchAlarmList(token: token)
            .map { $0.result.alarmList }
            .subscribe(onSuccess: { [weak self] alarmDates in
                self?.alarmDates.accept(alarmDates)
            })
            .disposed(by: disposeBag)
    }
}

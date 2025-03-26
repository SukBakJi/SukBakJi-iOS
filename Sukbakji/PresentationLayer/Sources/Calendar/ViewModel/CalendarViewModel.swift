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
    var selectUnivList: UnivList?
    let selectedUnivList = BehaviorRelay<[UnivList]>(value: [])
    let selectedUnivAll = BehaviorRelay<Bool>(value: false)
    
    let upComingSchedules = BehaviorRelay<[UpComingList]>(value: [])
    let dateSelectSchedules = BehaviorRelay<[DateSelectList]>(value: [])
    let alarmDates = BehaviorRelay<[AlarmList]>(value: [])
    
    let univDeleted = PublishSubject<Bool>()

    func loadUnivList() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
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
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
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
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
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
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchAlarmList(token: token)
            .map { $0.result.alarmList }
            .subscribe(onSuccess: { [weak self] alarmDates in
                self?.alarmDates.accept(alarmDates)
                print(self?.alarmDates.value)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteUnivCalendar(memberId: Int?, univId: Int?, season: String?, method: String?) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        let params = [
            "memberId": memberId!,
            "univId": univId!,
            "season": season!,
            "method": method!
        ] as [String : Any]
        
        repository.fetchUnivDelete(token: token, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.univDeleted.onNext(true)
            }, onFailure: { error in
                self.univDeleted.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteUnivCalendarAll() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        repository.fetchUnivDeleteAll(token: token)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.loadUnivList()
            }, onFailure: { error in
            })
            .disposed(by: disposeBag)
    }
    
    func editUnivCalendar(univId: Int?, season: String?, method: String?) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        let params = [
            "season": season!,
            "method": method!
        ] as [String : Any]
        
        repository.fetchUnivEdit(token: token, univId: univId!, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                NotificationCenter.default.post(name: .isUnivComplete, object: nil)
            }, onFailure: { error in
            })
            .disposed(by: disposeBag)
    }
    
    func toggleSelectState() {
        let newState = !selectedUnivAll.value
        selectedUnivAll.accept(newState) // 상태 변경
    }
    
    func loadTestData() {
        let testUnivList: [UnivList] = [
            UnivList(univId: 1, season: "ㅇㅇ", method: "ㅇㅇ", showing: 1),
            UnivList(univId: 2, season: "ㅇㅇ", method: "ㅇㅇ", showing: 1)
        ]
        univList.accept(testUnivList)
    }
}

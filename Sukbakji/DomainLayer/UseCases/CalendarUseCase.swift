//
//  CalendarUseCase.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/25.
//

import RxSwift

class CalendarUseCase {
    private let calendarRepository: CalendarRepository
    
    init(calendarRepository: CalendarRepository = CalendarRepository.shared) {
        self.calendarRepository = calendarRepository
    }
    
    func fetchUpComing() -> Single<[UpComingList]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return calendarRepository.fetchUpComing(token: token)
            .map { $0.result.scheduleList.filter { $0.dday >= 0 && $0.dday <= 30 } }
    }
    
    func fetchDateSelect(date: String) -> Single<[DateSelectList]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return calendarRepository.fetchDateSelect(token: token, date: date)
            .map { $0.result.scheduleList }
    }
    
    func fetchUnivSearch(keyword: String) -> Single<[UnivSearchList]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return calendarRepository.fetchUnivSearch(token: token, keyword: keyword)
            .map { $0.result.universityList }
    }
    
    func fetchUnivName(univId: Int) -> Single<String> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return calendarRepository.fetchUnivName(token: token, univId: univId)
            .map { $0.result.univName }
    }
    
    func fetchUnivMethod(univId: Int) -> Single<[String]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return calendarRepository.fetchUnivMethod(token: token, univId: univId)
            .map { $0.result.methodList.map { $0.method } }
    }
    
    func fetchUnivList() -> Single<[UnivList]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return calendarRepository.fetchUnivList(token: token)
            .map { $0.result.univList }
    }
    
    func createUniv(memberId: Int, univId: Int, season: String, method: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "memberId": memberId,
            "univId": univId,
            "season": season,
            "method": method
        ]
        
        return calendarRepository.createUniv(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func editUniv(univId: Int, season: String, method: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "season": season,
            "method": method
        ]
        
        return calendarRepository.editUniv(token: token, univId: univId, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func deleteUniv(memberId: Int, univId: Int, season: String, method: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "memberId": memberId,
            "univId": univId,
            "season": season,
            "method": method
        ]
        
        return calendarRepository.deleteUniv(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func deleteAllUniv() -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        return calendarRepository.deleteAllUniv(token: token)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func deleteSelectedUniv(univIds: [Int]) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: [Any]] = [
            "univIds": univIds
        ]
        
        return calendarRepository.deleteSelectedUniv(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func fetchAlarmList() -> Single<[AlarmList]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return calendarRepository.fetchAlarmList(token: token)
            .map { $0.result.alarmList }
    }
    
    func createAlarm(memberId: Int, univName: String, name: String, date: String, time: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "memberId": memberId,
            "univName": univName,
            "name": name,
            "date": date,
            "time": time,
            "onoff": 1
        ]
        
        return calendarRepository.createAlarm(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func onOffAlarm(alarmId: Int, isOn: Bool) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        return calendarRepository.onOffAlarm(token: token, alarmId: alarmId, isOn: isOn)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func editAlarm(alarmId: Int, memberId: Int, univName: String, name: String, date: String, time: String, onoff: Int) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "memberId": memberId,
            "univName": univName,
            "name": name,
            "date": date,
            "time": time,
            "onoff": onoff
        ]
        
        return calendarRepository.editAlarm(token: token, alarmId: alarmId, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func deleteAlarm(alarmId: Int) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        return calendarRepository.deleteAlarm(token: token, alarmId: alarmId)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func fetchAlarmUniv() -> Single<[String]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return calendarRepository.fetchAlarmUniv(token: token)
            .map { $0.result }
    }
}

//
//  CalendarRepository.swift
//  Sukbakji
//
//  Created by jaegu park on 2/18/25.
//

import Foundation
import RxSwift

class CalendarRepository {
    static let shared = CalendarRepository()
    
    func fetchUpComing(token: String) -> Single<APIResponse<UpComing>> {
        let url = APIConstants.calendarSchedule.path
        return APIService.shared.getWithToken(of: APIResponse<UpComing>.self, url: url, accessToken: token)
    }
    
    func fetchDateSelect(token: String, date: String) -> Single<APIResponse<DateSelect>> {
        let url = APIConstants.calendarScheduleDate(date).path
        let params = ["date": date]
        return APIService.shared.getWithTokenAndParams(of: APIResponse<DateSelect>.self, url: url, parameters: params, accessToken: token)
    }
    
    func fetchUnivSearch(token: String, keyword: String) -> Single<APIResponse<UnivSearch>> {
        let url = APIConstants.calendarSearch.path
        let params = ["keyword": keyword]
        return APIService.shared.getWithTokenAndParams(of: APIResponse<UnivSearch>.self, url: url, parameters: params, accessToken: token)
    }
    
    func fetchUnivName(token: String, univId: Int) -> Single<APIResponse<UnivName>> {
        let url = APIConstants.calendar.path
        let params = ["univId": univId]
        return APIService.shared.getWithTokenAndParams(of: APIResponse<UnivName>.self, url: url, parameters: params, accessToken: token)
    }
    
    func fetchUnivMethod(token: String, univId: Int) -> Single<APIResponse<UnivMethod>> {
        let url = APIConstants.calendarUnivMethod.path
        let params = ["univId": univId]
        return APIService.shared.getWithTokenAndParams(of: APIResponse<UnivMethod>.self, url: url, parameters: params, accessToken: token)
    }
    
    func fetchUnivList(token: String) -> Single<APIResponse<Univ>> {
        let url = APIConstants.calendarUniv.path
        return APIService.shared.getWithToken(of: APIResponse<Univ>.self, url: url, accessToken: token)
    }
    
    func fetchUnivEnroll(token: String, parameters: [String: Any]?) -> Single<APIResponse<UnivPost>> {
        let url = APIConstants.calendarUniv.path
        return APIService.shared.postWithToken(of: APIResponse<UnivPost>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func fetchUnivEdit(token: String, univId: Int, parameters: [String: Any]?) -> Single<APIResponse<String>> {
        let url = APIConstants.calendarUnivId(univId).path
        return APIService.shared.patchWithToken(of: APIResponse<String>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func fetchUnivDelete(token: String, parameters: [String: Any]?) -> Single<APIResponse<UnivDeleteResult>> {
        let url = APIConstants.calendarUniv.path
        return APIService.shared.deleteWithToken(of: APIResponse<UnivDeleteResult>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func fetchUnivDeleteAll(token: String) -> Single<APIResponseNoResult> {
        let url = APIConstants.calendarUnivAll.path
        return APIService.shared.deleteWithToken(of: APIResponseNoResult.self, url: url, parameters: nil, accessToken: token)
    }
    
    func fetchUnivDeleteSelected(token: String, parameters: [String: [Any]]?) -> Single<APIResponseNoResult> {
        let url = APIConstants.calendarUnivSelected.path
        return APIService.shared.deleteWithToken(of: APIResponseNoResult.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func fetchAlarmList(token: String) -> Single<APIResponse<Alarm>> {
        let url = APIConstants.calendarAlarm.path
        return APIService.shared.getWithToken(of: APIResponse<Alarm>.self, url: url, accessToken: token)
    }
    
    func fetchAlarmEnroll(token: String, parameters: [String: Any]?) -> Single<APIResponse<AlarmPost>> {
        let url = APIConstants.calendarAlarm.path
        return APIService.shared.postWithToken(of: APIResponse<AlarmPost>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func fetchAlarmOnOff(token: String, alarmId: Int, isOn: Bool) -> Single<APIResponse<AlarmPatch>> {
        let url = isOn ? APIConstants.calendarAlarmOn.path : APIConstants.calendarAlarmOff.path
        let params = ["alarmId": alarmId]
        return APIService.shared.patchWithToken(of: APIResponse<AlarmPatch>.self, url: url, parameters: params, accessToken: token)
    }
    
    func fetchAlarmEdit(token: String, alarmId: Int, parameters: [String: Any]?) -> Single<APIResponse<AlarmList>> {
        let url = APIConstants.calendarAlarmId(alarmId).path
        return APIService.shared.patchWithToken(of: APIResponse<AlarmList>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func fetchAlarmDelete(token: String, alarmId: Int) -> Single<APIResponseNoResult> {
        let url = APIConstants.calendarAlarmId(alarmId).path
        let params = ["alarmId": alarmId]
        return APIService.shared.deleteWithToken(of: APIResponseNoResult.self, url: url, parameters: params, accessToken: token)
    }
    
    func fetchAlarmUniv(token: String) -> Single<APIResponse<[String]>> {
        let url = APIConstants.calendarAlarmUniv.path
        return APIService.shared.getWithToken(of: APIResponse<[String]>.self, url: url, accessToken: token)
    }
}

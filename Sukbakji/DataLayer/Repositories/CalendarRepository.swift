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
    
    func fetchUnivList(token: String) -> Single<APIResponse<Univ>> {
        let url = APIConstants.calendarUniv.path
        return APIService.shared.getWithToken(of: APIResponse<Univ>.self, url: url, accessToken: token)
    }
    
    func fetchUpComing(token: String) -> Single<APIResponse<UpComing>> {
        let url = APIConstants.calendarSchedule.path
        return APIService.shared.getWithToken(of: APIResponse<UpComing>.self, url: url, accessToken: token)
    }
    
    func fetchAlarmList(token: String) -> Single<APIResponse<Alarm>> {
        let url = APIConstants.calendarAlarm.path
        return APIService.shared.getWithToken(of: APIResponse<Alarm>.self, url: url, accessToken: token)
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
}

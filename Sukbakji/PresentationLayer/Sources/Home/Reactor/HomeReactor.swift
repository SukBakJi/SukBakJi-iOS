//
//  HomeReactor.swift
//  Sukbakji
//
//  Created by jaegu park on 2/12/25.
//

import Foundation
import ReactorKit
import RxSwift
import Alamofire

final class HomeReactor: Reactor {
    let initialState = State()
    let apiService = APIService()
    
    enum Action {
        case getUserName
        case getViewSchedule
        case getMemberID
    }

    enum Mutation {
        case setUserName(MyProfile)
        case setViewSchedule(UpComing?)
        case setMemberID(Int)
        case setError(String)
    }

    struct State {
        var nameLabel: String?
        var upComingDate: String?
        var upComingTitle: String?
        var memberID: Int?
        var errorMessage: String?
    }
    
    private func fetchData<T: Codable>(
        _ type: T.Type,
        url: URLConvertible,
        token: String,
        mutation: @escaping (T) -> Mutation
    ) -> Observable<Mutation> {
        return apiService.getWithToken(of: APIResponse<T>.self, url: url, accessToken: token)
            .asObservable()
            .map { response -> Mutation in
                return response.code == "COMMON200" ? mutation(response as! T) : .setError(response.message)
            }
    }

    func mutate(action: Action) -> Observable<Mutation> {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .empty()
        }

        switch action {
        case .getUserName:
            return fetchData(APIResponse<MyProfile>.self, url: APIConstants.userMypage.path, token: retrievedToken) { response in
                    .setUserName(response.result)
            }
        case .getViewSchedule:
            return fetchData(APIResponse<UpComing>.self, url: APIConstants.calendarSchedule.path, token: retrievedToken) { response in
                    .setViewSchedule(response.result)
            }
        case .getMemberID:
            return fetchData(APIResponse<MemberId>.self, url: APIConstants.calendarMember.path, token: retrievedToken) { response in
                    .setMemberID(response.result.memberId)
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setUserName(let profile):
            newState.nameLabel = (profile.name ?? "석박지") + "님, 반가워요!"
        case .setViewSchedule(let upComing):
            if let upComing = upComing, let firstSchedule = upComing.scheduleList.first {
                let dday = firstSchedule.dday
                let content = firstSchedule.content
                let univId = firstSchedule.univId
                
                newState.upComingDate = dday < 0 ? "D+\(-dday)" : "D-\(dday)"
                switch univId {
                case 1: newState.upComingTitle = "서울대학교 \(content)"
                case 2: newState.upComingTitle = "연세대학교 \(content)"
                case 3: newState.upComingTitle = "고려대학교 \(content)"
                case 4: newState.upComingTitle = "카이스트 \(content)"
                default: newState.upComingTitle = content
                }
            } else {
                newState.upComingDate = nil
                newState.upComingTitle = "다가오는 일정이 없습니다"
            }
        case .setMemberID(let id):
            newState.memberID = id
            UserDefaults.standard.set(id, forKey: "memberID")
        case .setError(let message):
            newState.errorMessage = message
        }
        return newState
    }
}

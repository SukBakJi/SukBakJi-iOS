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
    private var viewModel = UnivViewModel()
    
    enum Action {
        case getUserName
        case getViewSchedule
        case getMemberID
    }

    enum Mutation {
        case setUserName(MyProfile)
        case setViewSchedule(UpComing?)
        case setUnivName(String)
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
        _ type: APIResponse<T>.Type,
        url: URLConvertible,
        token: String,
        mutation: @escaping (T) -> Mutation
    ) -> Observable<Mutation> {
        return apiService.getWithToken(of: APIResponse<T>.self, url: url, accessToken: token)
            .asObservable()
            .map { response in
                if response.code == "COMMON200" {
                    return mutation(response.result)
                } else {
                    return .setError(response.message)
                }
            }
    }

    func mutate(action: Action) -> Observable<Mutation> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .empty()
        }

        switch action {
        case .getUserName:
            return fetchData(APIResponse<MyProfile>.self, url: APIConstants.userMypage.path, token: token) { profile in
                    .setUserName(profile)
            }
        case .getViewSchedule:
            return fetchData(APIResponse<UpComing>.self, url: APIConstants.calendarSchedule.path, token: token) { schedule in
                return .setViewSchedule(schedule)
            }
            .flatMap { mutation -> Observable<Mutation> in
                switch mutation {
                case .setViewSchedule(let upComing):
                    guard let first = upComing?.scheduleList.first else {
                        return Observable.just(mutation)
                    }
                    return Observable.concat([
                        Observable.just(mutation),
                        self.viewModel.loadUnivName(univId: first.univId)
                            .map { .setUnivName($0) }
                    ])
                default:
                    return Observable.just(mutation)
                }
            }
        case .getMemberID:
            return fetchData(APIResponse<MemberId>.self, url: APIConstants.calendarMember.path, token: token) { response in
                    .setMemberID(response.memberId)
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setUserName(let profile):
            newState.nameLabel = (profile.name ?? "석박지") + "님, 반가워요!"
        case .setViewSchedule(let upComing):
            guard let first = upComing?.scheduleList.first else {
                newState.upComingDate = "대학교를 설정하고\n일정을 확인해 보세요!"
                newState.upComingTitle = ""
                return newState
            }
            newState.upComingDate = "D-\(first.dday)"
            newState.upComingTitle = first.content
            
        case .setUnivName(let univName):
            if let title = state.upComingTitle {
                newState.upComingTitle = "\(univName) \(title)"
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

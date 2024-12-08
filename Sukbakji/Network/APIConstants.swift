//
//  APIConstants.swift
//  Sukbakji
//
//  Created by jaegu park on 8/5/24.
//

import Foundation

enum APIConstants {
    case authLogout
    
    case userMypage
    case userPutProfile
    case userPostProfile
    case userPostPassword
    
    case board
    
    case posts
    
    case communityFavoriteBoard
    case communityHotPost
    
    case mypage
    
    case calendarSchedule
    
    case researchTopics
    
    case mentor
    
    case labsFavoriteLab
}

extension APIConstants {
    
    static let baseURL = "http://3.38.252.225:8080/api"
    
    static func makeEndPoint(_ endpoint: String) -> String {
        baseURL + endpoint
    }
    
    var path: String {
        switch self {
        case .authLogout:
            return APIConstants.makeEndPoint("/auth/logout")
            
        case .userMypage:
            return APIConstants.makeEndPoint("/user/mypage")
        case .userPutProfile:
            return APIConstants.makeEndPoint("/user/profile")
        case .userPostProfile:
            return APIConstants.makeEndPoint("/user/profile")
        case .userPostPassword:
            return APIConstants.makeEndPoint("/user/password")
            
        case .board:
            return APIConstants.makeEndPoint("/board")
            
        case .posts:
            return APIConstants.makeEndPoint("/posts")
            
        case .communityFavoriteBoard:
            return APIConstants.makeEndPoint("/community/favorite-post-list")
        case .communityHotPost:
            return APIConstants.makeEndPoint("/community/hot-boards")
            
        case .mypage:
            return APIConstants.makeEndPoint("/mypage")
            
        case .calendarSchedule:
            return APIConstants.makeEndPoint("/calendar/schedule")
            
        case .researchTopics:
            return APIConstants.makeEndPoint("/research-topics")
            
        case .mentor:
            return APIConstants.makeEndPoint("/mentor")
            
        case .labsFavoriteLab:
            return APIConstants.makeEndPoint("/labs/mypage/favorite-labs")
        }
    }
}

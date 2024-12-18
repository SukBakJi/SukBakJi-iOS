//
//  APIConstants.swift
//  Sukbakji
//
//  Created by jaegu park on 8/5/24.
//

import Foundation

enum APIConstants {
    case authSignUp
    case authRefreshToken
    case authLogout
    case authLogin
    case authKakao
    case authEmail
    
    
    case userMypage
    case userProfile
    case userPassword
    
    
    case board
    
    
    case posts
    
    
    case communitySearch
    case communityScrapList
    case communityPostList
    case communityLastestQuestions
    case communityHotPost
    case communityFavoriteBoard
    case communityCommentList
    
    
    case calendarUniv
    case calendarSchedule
    case calendarAlarm
    case calendarAlarmOn
    case calendarAlarmOff
    case calendarSearch
    case calendarScheduleDate(String)
    
    
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
        case .authSignUp:
            return APIConstants.makeEndPoint("/auth/signup")
        case .authRefreshToken:
            return APIConstants.makeEndPoint("/auth/refresh-token")
        case .authLogout:
            return APIConstants.makeEndPoint("/auth/logout")
        case .authLogin:
            return APIConstants.makeEndPoint("/auth/login")
        case .authKakao:
            return APIConstants.makeEndPoint("/auth/kakao")
        case .authEmail:
            return APIConstants.makeEndPoint("/auth/email")
            
            
        case .userMypage:
            return APIConstants.makeEndPoint("/user/mypage")
        case .userProfile:
            return APIConstants.makeEndPoint("/user/profile")
        case .userPassword:
            return APIConstants.makeEndPoint("/user/password")
            
            
        case .board:
            return APIConstants.makeEndPoint("/board")
            
            
        case .posts:
            return APIConstants.makeEndPoint("/posts")
            
            
        case .communitySearch:
            return APIConstants.makeEndPoint("/community/search")
        case .communityScrapList:
            return APIConstants.makeEndPoint("/community/scrap-list")
        case .communityPostList:
            return APIConstants.makeEndPoint("/community/post-list")
        case .communityLastestQuestions:
            return APIConstants.makeEndPoint("/community/lastest-questions")
        case .communityHotPost:
            return APIConstants.makeEndPoint("/community/hot-boards")
        case .communityFavoriteBoard:
            return APIConstants.makeEndPoint("/community/favorite-post-list")
        case .communityCommentList:
            return APIConstants.makeEndPoint("/community/comment-list")
            
            
        case .calendarUniv:
            return APIConstants.makeEndPoint("/calendar/univ")
        case .calendarSchedule:
            return APIConstants.makeEndPoint("/calendar/schedule")
        case .calendarAlarm:
            return APIConstants.makeEndPoint("/calendar/alarm")
        case .calendarAlarmOn:
            return APIConstants.makeEndPoint("/calendar/alarm/on")
        case .calendarAlarmOff:
            return APIConstants.makeEndPoint("/calendar/alarm/off")
        case .calendarSearch:
            return APIConstants.makeEndPoint("/calendar/search")
        case .calendarScheduleDate(let date):
            return APIConstants.makeEndPoint("/calendar/schedule/\(date)")
            
            
        case .researchTopics:
            return APIConstants.makeEndPoint("/research-topics")
            
            
        case .mentor:
            return APIConstants.makeEndPoint("/mentor")
            
            
        case .labsFavoriteLab:
            return APIConstants.makeEndPoint("/labs/mypage/favorite-labs")
        }
    }
}

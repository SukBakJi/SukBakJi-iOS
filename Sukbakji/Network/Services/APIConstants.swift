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
    case authOauth2Login
    case authLogout
    case authLogin
    case authEmail
    
    
    case userMypage
    case userProfile
    case userPassword
    case userEducationCertification
    
    
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
    case calendarUnivMethod
    case calendarSearch
    case calendarScheduleDate(String)
    case calendarMember
    
    
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
        case .authOauth2Login:
            return APIConstants.makeEndPoint("/auth/oauth2/login")
        case .authLogout:
            return APIConstants.makeEndPoint("/auth/logout")
        case .authLogin:
            return APIConstants.makeEndPoint("/auth/login")
        case .authEmail:
            return APIConstants.makeEndPoint("/auth/email")
            
            
        case .userMypage:
            return APIConstants.makeEndPoint("/user/mypage")
        case .userProfile:
            return APIConstants.makeEndPoint("/user/profile")
        case .userPassword:
            return APIConstants.makeEndPoint("/user/password")
        case .userEducationCertification:
            return APIConstants.makeEndPoint("/user/education-certification")
            
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
            return APIConstants.makeEndPoint("/calender/univ")
        case .calendarSchedule:
            return APIConstants.makeEndPoint("/calender/schedule")
        case .calendarAlarm:
            return APIConstants.makeEndPoint("/calender/alarm")
        case .calendarAlarmOn:
            return APIConstants.makeEndPoint("/calender/alarm/on")
        case .calendarAlarmOff:
            return APIConstants.makeEndPoint("/calender/alarm/off")
        case .calendarUnivMethod:
            return APIConstants.makeEndPoint("/calender/univ/method")
        case .calendarSearch:
            return APIConstants.makeEndPoint("/calender/search")
        case .calendarScheduleDate(let date):
            return APIConstants.makeEndPoint("/calender/schedule/\(date)")
        case .calendarMember:
            return APIConstants.makeEndPoint("/calender/member")
            
            
        case .researchTopics:
            return APIConstants.makeEndPoint("/research-topics")
            
            
        case .mentor:
            return APIConstants.makeEndPoint("/mentor")
            
            
        case .labsFavoriteLab:
            return APIConstants.makeEndPoint("/labs/mypage/favorite-labs")
        }
    }
}

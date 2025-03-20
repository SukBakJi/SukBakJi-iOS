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
    case authPassword
    case authOauth2Login
    case authMemberEmail
    case authLogout
    case authLogin
    case authEmail
    case authEmailCode
    case authPasswordReset
    
    
    case userProfile
    case userPasswordReset
    case userEducationCertification
    case userMypage
    
    
    case smsPhone
    case smsPhoneVerify
    
    
    case reportsPost
    case reportsComment
    
    
    case board
    case boardFavoriteAdd(Int)
    case boardsMenu(String)
    
    
    case posts
    
    
    case communitySearch
    case communityScrapList
    case communityPostList
    case communityLastestQuestions
    case communityHotPost
    case communityFavoriteBoard
    case communityCommentList
    
    
    case calendarUniv
    case calendarUnivId(Int)
    case calendarSchedule
    case calendarAlarm
    case calendarAlarmId(Int)
    case calendarAlarmOn
    case calendarAlarmOff
    case calendarUnivMethod
    case calendarSearch
    case calendarScheduleDate(String)
    case calendarMember
    case calendarUnivSelected
    case calendarUnivAll
    
    
    case researchTopicsSearch
    
    
    case mentor
    
    
    case labsFavoriteLab
}

extension APIConstants {
    
    static let baseURL = "https://sukbakji.shop/api"
    
    static func makeEndPoint(_ endpoint: String) -> String {
        baseURL + endpoint
    }
    
    var path: String {
        switch self {
        case .authSignUp:
            return APIConstants.makeEndPoint("/auth/signup")
        case .authRefreshToken:
            return APIConstants.makeEndPoint("/auth/refresh-token")
        case .authPassword:
            return APIConstants.makeEndPoint("/auth/password")
        case .authOauth2Login:
            return APIConstants.makeEndPoint("/auth/oauth2/login")
        case .authMemberEmail:
            return APIConstants.makeEndPoint("/auth/member-email")
        case .authLogout:
            return APIConstants.makeEndPoint("/auth/logout")
        case .authLogin:
            return APIConstants.makeEndPoint("/auth/login")
        case .authEmail:
            return APIConstants.makeEndPoint("/auth/email")
        case .authEmailCode:
            return APIConstants.makeEndPoint("/auth/email-code")
        case .authPasswordReset:
            return APIConstants.makeEndPoint("/auth/password-reset")
        
        case .userProfile:
            return APIConstants.makeEndPoint("/user/profile")
        case .userPasswordReset:
            return APIConstants.makeEndPoint("/user/password-reset")
        case .userEducationCertification:
            return APIConstants.makeEndPoint("/user/education-certification")
        case .userMypage:
            return APIConstants.makeEndPoint("/user/mypage")
            
        case .smsPhone:
            return APIConstants.makeEndPoint("/sms/phone")
        case .smsPhoneVerify:
            return APIConstants.makeEndPoint("/sms/phone/verify")
            
            
        case .reportsPost:
            return APIConstants.makeEndPoint("/reports/post")
        case .reportsComment:
            return APIConstants.makeEndPoint("/reports/comment")
            
            
        case .board:
            return APIConstants.makeEndPoint("/board")
        case .boardFavoriteAdd(let boardId):
            return APIConstants.makeEndPoint("/boards/\(boardId)/favorite/add")
        case .boardsMenu(let menu):
            return APIConstants.makeEndPoint("/boards/\(menu)")
            
            
            
        case .posts:
            return APIConstants.makeEndPoint("/posts")
            
            
        case .communitySearch:
            return APIConstants.makeEndPoint("/community/search")
        case .communityScrapList:
            return APIConstants.makeEndPoint("/community/scrap-list")
        case .communityPostList:
            return APIConstants.makeEndPoint("/community/post-list")
        case .communityLastestQuestions:
            return APIConstants.makeEndPoint("/community/latest-questions")
        case .communityHotPost:
            return APIConstants.makeEndPoint("/community/hot-boards")
        case .communityFavoriteBoard:
            return APIConstants.makeEndPoint("/community/favorite-post-list")
        case .communityCommentList:
            return APIConstants.makeEndPoint("/community/comment-list")
            
            
        case .calendarUniv:
            return APIConstants.makeEndPoint("/calender/univ")
        case .calendarUnivId(let univId):
            return APIConstants.makeEndPoint("/calender/univ/\(univId)")
        case .calendarSchedule:
            return APIConstants.makeEndPoint("/calender/schedule")
        case .calendarAlarm:
            return APIConstants.makeEndPoint("/calender/alarm")
        case .calendarAlarmId(let alarmId):
            return APIConstants.makeEndPoint("/calender/alarm/\(alarmId)")
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
        case .calendarUnivSelected:
            return APIConstants.makeEndPoint("/calender/univ/selected")
        case .calendarUnivAll:
            return APIConstants.makeEndPoint("/calender/univ/all")
            
            
        case .researchTopicsSearch:
            return APIConstants.makeEndPoint("/research-topics/search")
            
            
        case .mentor:
            return APIConstants.makeEndPoint("/mentor")
            
            
        case .labsFavoriteLab:
            return APIConstants.makeEndPoint("/labs/mypage/favorite-labs")
        }
    }
}

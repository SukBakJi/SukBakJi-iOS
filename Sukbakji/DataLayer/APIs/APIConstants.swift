//
//  APIConstants.swift
//  Sukbakji
//
//  Created by jaegu park on 8/5/24.
//

import Foundation

enum APIConstants {
    case userProfile
    case userPasswordReset
    case userFCMToken
    case userEducationCertification
    case userMypage
    
    
    case authSignUp
    case authRefreshToken
    case authPassword
    case authPasswordReset
    case authOauth2Login
    case authMemberEmail
    case authLogout
    case authLogin
    case authEmail
    case authEmailCode
    
    
    case smsPhone
    case smsPhoneVerify
    
    
    case reportsPost
    case reportsComment
    
    
    case notification
    case notificationMulticast
    
    
    case commentsUpdate
    case commentsCreate
    
    
    case boardsFavoriteAdd(Int)
    case boardsFavoriteRemove(Int)
    case boardsCreate
    case boardsMenu(String)
    case boardsFavorite
    
    
    case blockMemberId(Int)
    
    
    case scrapsToggle(Int)
    
    
    case postsUpdate(Int)
    case postsCreate
    case postsCreateJobPost
    case postsId(Int)
    case postsList
    case postsDelete(Int)
    
    
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
    case calendarAlarmUniv
    case calendar
    case calendarUnivMethod
    case calendarSearch
    case calendarScheduleDate(String)
    case calendarMember
    case calendarUnivSelected
    case calendarUnivAll
    
    
    case researchTopicsSearch
    
    
    case mentor
    
    
    case labsSearch
    case labsId(Int)
    case labsInterestTopics
    case labsFavoriteLab
    case labsReviewsId(Int)
    case labsReviews
}

extension APIConstants {
    
    static let baseURL = "https://sukbakji.shop/api"
    
    static func makeEndPoint(_ endpoint: String) -> String {
        baseURL + endpoint
    }
    
    var path: String {
        switch self {
        case .userProfile:
            return APIConstants.makeEndPoint("/user/profile")
        case .userPasswordReset:
            return APIConstants.makeEndPoint("/user/password-reset")
        case .userFCMToken:
            return APIConstants.makeEndPoint("/user/fcm-token")
        case .userEducationCertification:
            return APIConstants.makeEndPoint("/user/education-certification")
        case .userMypage:
            return APIConstants.makeEndPoint("/user/mypage")
            
            
        case .authSignUp:
            return APIConstants.makeEndPoint("/auth/signup")
        case .authRefreshToken:
            return APIConstants.makeEndPoint("/auth/refresh-token")
        case .authPassword:
            return APIConstants.makeEndPoint("/auth/password")
        case .authPasswordReset:
            return APIConstants.makeEndPoint("/auth/password-reset")
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
            
            
        case .smsPhone:
            return APIConstants.makeEndPoint("/sms/phone")
        case .smsPhoneVerify:
            return APIConstants.makeEndPoint("/sms/phone/verify")
            
            
        case .reportsPost:
            return APIConstants.makeEndPoint("/reports/post")
        case .reportsComment:
            return APIConstants.makeEndPoint("/reports/comment")
            
            
        case .notification:
            return APIConstants.makeEndPoint("/notification")
        case .notificationMulticast:
            return APIConstants.makeEndPoint("/notification/multicast")
            
            
        case .commentsUpdate:
            return APIConstants.makeEndPoint("/comments/update")
        case .commentsCreate:
            return APIConstants.makeEndPoint("/comments/create")
            
            
        case .boardsFavoriteAdd(let boardId):
            return APIConstants.makeEndPoint("/boards/\(boardId)/favorite/add")
        case .boardsFavoriteRemove(let boardId):
            return APIConstants.makeEndPoint("/boards/\(boardId)/favorite/remove")
        case .boardsCreate:
            return APIConstants.makeEndPoint("/boards/create")
        case .boardsMenu(let menu):
            return APIConstants.makeEndPoint("/boards/\(menu)")
        case .boardsFavorite:
            return APIConstants.makeEndPoint("/boards/favorite")
            
            
        case .blockMemberId(let targetMemberId):
            return APIConstants.makeEndPoint("/block/\(targetMemberId)")
            
            
        case .scrapsToggle(let postId):
            return APIConstants.makeEndPoint("/scraps/\(postId)/toggle")
            
            
        case .postsUpdate(let postId):
            return APIConstants.makeEndPoint("/posts/\(postId)/update")
        case .postsCreate:
            return APIConstants.makeEndPoint("/posts/create")
        case .postsCreateJobPost:
            return APIConstants.makeEndPoint("/posts/createJobPost")
        case .postsId(let postId):
            return APIConstants.makeEndPoint("/posts/\(postId)")
        case .postsList:
            return APIConstants.makeEndPoint("/posts/list")
        case .postsDelete(let postId):
            return APIConstants.makeEndPoint("/posts/\(postId)/delete")
            
            
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
        case .calendarAlarmUniv:
            return APIConstants.makeEndPoint("/calender/alarm/univ")
        case .calendar:
            return APIConstants.makeEndPoint("/calender")
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
            
            
        case .labsSearch:
            return APIConstants.makeEndPoint("/labs/search")
        case .labsId(let labId):
            return APIConstants.makeEndPoint("/labs/\(labId)")
        case .labsInterestTopics:
            return APIConstants.makeEndPoint("/labs/mypage/interest-topics")
        case .labsFavoriteLab:
            return APIConstants.makeEndPoint("/labs/mypage/favorite-labs")
        case .labsReviewsId(let labId):
            return APIConstants.makeEndPoint("/labs/reviews/\(labId)")
        case .labsReviews:
            return APIConstants.makeEndPoint("/labs/reviews")
        }
    }
}

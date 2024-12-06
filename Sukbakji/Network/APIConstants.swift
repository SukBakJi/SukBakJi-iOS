//
//  APIConstants.swift
//  Sukbakji
//
//  Created by jaegu park on 8/5/24.
//

import Foundation

enum APIConstants {
    case auth
    
    case user
    
    case board
    
    case posts
    
    case community
    
    case mypage
    
    case calendar
    
    case researchTopics
    
    case mentor
    
    case labs
}

extension APIConstants {
    
    static let baseURL = "http://3.38.252.225:8080/api"
    
    static func makeEndPoint(_ endpoint: String) -> String {
        baseURL + endpoint
    }
    
    var path: String {
        switch self {
        case .auth:
            return APIConstants.makeEndPoint("/auth")
            
        case .user:
            return APIConstants.makeEndPoint("/user")
            
        case .board:
            return APIConstants.makeEndPoint("/board")
            
        case .posts:
            return APIConstants.makeEndPoint("/posts")
            
        case .community:
            return APIConstants.makeEndPoint("/community")
            
        case .mypage:
            return APIConstants.makeEndPoint("/mypage")
            
        case .calendar:
            return APIConstants.makeEndPoint("/calendar")
            
        case .researchTopics:
            return APIConstants.makeEndPoint("/research-topics")
            
        case .mentor:
            return APIConstants.makeEndPoint("/mentor")
            
        case .labs:
            return APIConstants.makeEndPoint("/labs")
        }
    }
}

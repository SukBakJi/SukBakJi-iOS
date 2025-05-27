//
//  Notification+.swift
//  Sukbakji
//
//  Created by jaegu park on 1/23/25.
//

import Foundation

extension Notification.Name {
    static let isAlarmComplete = Notification.Name("isAlarmComplete")
    static let isAlarmEditComplete = Notification.Name("isAlarmEditComplete")
    static let isAlarmDeleteComplete = Notification.Name("isAlarmDeleteComplete")
    
    static let isUnivComplete = Notification.Name("isUnivComplete")
    static let isUnivEditComplete = Notification.Name("isUnivEditComplete")
    static let isUnivDeleteComplete = Notification.Name("isUnivDeleteComplete")
    static let isUnivDeleteAllComplete = Notification.Name("isUnivDeleteAllComplete")
    static let isUnivDeleteSelectedComplete = Notification.Name("isUnivDeleteSelectedComplete")
    
    static let isCommentComplete = Notification.Name("isCommentComplete")
    
    static let textFieldDidClear = Notification.Name("textFieldDidClear")
    static let forceLogout = Notification.Name("forceLogout")
}

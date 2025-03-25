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
    static let textFieldDidClear = Notification.Name("textFieldDidClear")
}

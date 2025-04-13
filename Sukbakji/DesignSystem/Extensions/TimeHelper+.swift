//
//  TimeHelper+.swift
//  Sukbakji
//
//  Created by jaegu park on 4/13/25.
//

import Foundation

class TimeHelper {
    
    // 시간을 "오전" 또는 "오후"로 변환하는 함수
    static func convertTimeToAMPM(time: String) -> String {
        let timeComponents = time.split(separator: ":")
        
        if let hour = Int(timeComponents[0]) {
            if hour < 12 {
                return "오전 \(time)"
            } else {
                let adjustedHour = hour - 12
                let adjustedTime = "\(adjustedHour):\(timeComponents[1])"
                return "오후 \(adjustedTime)"
            }
        }
        
        return time
    }
}

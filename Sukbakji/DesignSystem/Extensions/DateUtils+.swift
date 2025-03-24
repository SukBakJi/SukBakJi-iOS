//
//  DateUtils+.swift
//  Sukbakji
//
//  Created by jaegu park on 3/24/25.
//

import Foundation

struct DateUtils {
    static func formatDateString(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy/MM/dd"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy년 M월 d일"
        outputFormatter.locale = Locale(identifier: "ko_KR")

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

//
//  Report+.swift
//  Sukbakji
//
//  Created by jaegu park on 8/24/25.
//

import UIKit

enum ReportReason: String, CaseIterable {
    case abuse         = "욕설/비하"
    case leak          = "유출/사칭/사기"
    case ad            = "상업적 광고 및 판매"
    case obscene       = "음란물/불건전한 대화 및 만남"
    case offTopic      = "게시판 주제에 부적절함"
    case politics      = "정당/정치인 비하 및 선거운동"
    case spam          = "낚시/도배"
}

struct ReportActionFactory {
    static func makeReportSheet(
        title: String,
        onSelect: @escaping (ReportReason) -> Void
    ) -> UIAlertController {
        let sheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        ReportReason.allCases.forEach { reason in
            sheet.addAction(UIAlertAction(title: reason.rawValue, style: .default) { _ in
                onSelect(reason)
            })
        }
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        return sheet
    }
}


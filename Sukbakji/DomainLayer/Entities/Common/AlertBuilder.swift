//
//  AlertBuilder.swift
//  Sukbakji
//
//  Created by jaegu park on 8/16/25.
//

import Foundation

enum PostActionID {
    static let edit = "post_edit"
    static let delete = "post_delete"
    static let report = "post_report"
}

enum CommentActionID {
    static let edit = "comment_edit"
    static let delete = "comment_delete"
    static let report = "comment_report"
}

struct AlertBuilder {
    static func postOptionSheet(isOwner: Bool) -> ActionSheetModel {
        if isOwner {
            return ActionSheetModel(
                title: nil,
                actions: [
                    .init(title: "수정", style: .default, id: PostActionID.edit),
                    .init(title: "삭제", style: .destructive, id: PostActionID.delete)
                ],
                cancelTitle: "취소"
            )
        } else {
            return ActionSheetModel(
                title: nil,
                actions: [ .init(title: "신고", style: .destructive, id: PostActionID.report) ],
                cancelTitle: "취소"
            )
        }
    }
    
    static func commentOptionSheet(isOwner: Bool) -> ActionSheetModel {
        if isOwner {
            return ActionSheetModel(
                title: nil,
                actions: [
                    .init(title: "수정", style: .default, id: CommentActionID.edit),
                    .init(title: "삭제", style: .destructive, id: CommentActionID.delete)
                ],
                cancelTitle: "취소"
            )
        } else {
            return ActionSheetModel(
                title: nil,
                actions: [ .init(title: "신고", style: .destructive, id: CommentActionID.report) ],
                cancelTitle: "취소"
            )
        }
    }
    
    static func reportReasonSheet(title: String) -> ActionSheetModel {
        let items = ReportReason.allCases.map {
            ActionSheetAction(title: $0.rawValue, style: .default, id: "reason_\($0.rawValue)")
        }
        return ActionSheetModel(title: title, actions: items, cancelTitle: "취소")
    }
}

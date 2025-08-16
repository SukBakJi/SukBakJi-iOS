//
//  ActionSheet.swift
//  Sukbakji
//
//  Created by jaegu park on 8/16/25.
//

import UIKit

struct ActionSheetAction {
    enum Style { case `default`, destructive }
    let title: String
    let style: Style
    let id: String // 핸들러에서 구분용 식별자
}

struct ActionSheetModel {
    let title: String?
    let actions: [ActionSheetAction]
    let cancelTitle: String
}

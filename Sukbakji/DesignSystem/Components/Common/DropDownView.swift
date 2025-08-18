//
//  DropDownView.swift
//  Sukbakji
//
//  Created by jaegu park on 8/18/25.
//

import UIKit
import DropDown

enum DropDownFactory {
    // 앱 전체 기본 스타일 한 번만 설정
    static func configureGlobalAppearance() {
        let ap = DropDown.appearance()
        ap.textColor = .gray900
        ap.selectedTextColor = .orange700
        ap.backgroundColor = .gray50
        ap.selectionBackgroundColor = .orange50
        ap.textFont = UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 12)
        ap.setupCornerRadius(5)
        ap.setupMaskedCorners(CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner))
    }

    /// 공통 구성된 DropDown 생성
    static func make(anchor: UIView, cellHeight: CGFloat = 44) -> DropDown {
        let dd = DropDown()
        dd.dismissMode = .automatic
        dd.cellHeight = cellHeight
        dd.anchorView = anchor
        dd.bottomOffset = CGPoint(x: 0, y: 45.5 + anchor.bounds.height)

        // 셀 좌우 패딩 & 구분선 공통
        dd.cellConfiguration = { _, item in "  \(item)" } // 좌측 여백 2칸

        dd.customCellConfiguration = { [weak dd] (index, _, cell) in
            // 기존 라인 제거
            cell.subviews.forEach { if $0.tag == 9999 { $0.removeFromSuperview() } }
            // 마지막 셀 제외, 구분선 추가
            guard let dd = dd, index != dd.dataSource.count - 1 else { return }
            let line = UIView()
            line.tag = 9999
            line.backgroundColor = .gray300
            line.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(line)
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                line.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                line.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                line.heightAnchor.constraint(equalToConstant: 1.5)
            ])
        }
        return dd
    }
}

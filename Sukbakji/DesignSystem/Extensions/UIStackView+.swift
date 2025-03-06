//
//  UIStackView+.swift
//  Sukbakji
//
//  Created by 오현민 on 3/4/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubViews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}

//
//  UIView+Extension.swift
//  Sukbakji
//
//  Created by 오현민 on 2/18/25.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

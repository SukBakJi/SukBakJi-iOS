//
//  UIView+.swift
//  Sukbakji
//
//  Created by jaegu park on 3/5/25.
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

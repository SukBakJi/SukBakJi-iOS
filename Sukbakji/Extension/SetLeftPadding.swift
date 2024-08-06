//
//  SetLeftPadding.swift
//  Sukbakji
//
//  Created by jaegu park on 8/6/24.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UITextField {
    func errorfix() {
        self.autocorrectionType = .no
        self.spellCheckingType = .no
    }
}

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
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            parentResponder = responder.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    var parentVC: UIViewController? {
            var parentResponder: UIResponder? = self
            while let next = parentResponder?.next {
                if let vc = next as? UIViewController {
                    return vc
                }
                parentResponder = next
            }
            return nil
        }
}

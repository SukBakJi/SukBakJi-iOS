//
//  UITextField+.swift
//  Sukbakji
//
//  Created by jaegu park on 12/20/24.
//

import UIKit

public extension UITextField {
    
    private struct AssociatedKeys {
        static var underlineView = UnsafeRawPointer(bitPattern: "underlineView".hashValue)!
    }

    private var underlineView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.underlineView) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.underlineView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTFUnderline() {
        if underlineView == nil {
            self.borderStyle = .none
            
            let underline = UIView()
            underline.backgroundColor = .gray300
            self.superview?.addSubview(underline)
            
            underline.snp.makeConstraints { make in
                make.top.equalTo(self.snp.bottom)
                make.leading.equalTo(self.snp.leading)
                make.trailing.equalTo(self.snp.trailing)
                make.height.equalTo(1.5)
            }
            self.underlineView = underline
            
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }
    }
    
    func updateUnderlineColor(to color: UIColor) {
        underlineView?.backgroundColor = color
    }
    
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
    
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func errorfix() {
        self.autocorrectionType = .no
        self.spellCheckingType = .no
    }
}

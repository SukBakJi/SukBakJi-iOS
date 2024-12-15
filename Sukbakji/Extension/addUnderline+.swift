//
//  addUnderline+.swift
//  Sukbakji
//
//  Created by jaegu park on 8/9/24.
//

import Foundation
import UIKit

extension UITextField {
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
            underline.backgroundColor = UIColor(hexCode: "E1E1E1")
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
}

extension UITextView {
    func addTVUnderline() {
        let underline = UIView()
        underline.backgroundColor = UIColor(hexCode: "E1E1E1")
        self.superview?.addSubview(underline)
        
        underline.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom) // 텍스트 뷰 바로 아래
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(1.5) // 언더라인 높이
        }
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    func addTVRedUnderline() {
        let underline = UIView()
        underline.backgroundColor = UIColor(hexCode: "FF4A4A")
        self.superview?.addSubview(underline)
        
        underline.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom) // 텍스트 뷰 바로 아래
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(1.5) // 언더라인 높이
        }
    }
}




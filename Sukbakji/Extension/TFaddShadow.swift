//
//  TFaddShadow.swift
//  Sukbakji
//
//  Created by jaegu park on 8/9/24.
//

import Foundation
import UIKit

extension UITextField {
    func addBottomShadow() {
        self.borderStyle = .none  // 기본 테두리 없애기
        // 하단 테두리 추가
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1.5)
        bottomBorder.backgroundColor = UIColor(hexCode: "E1E1E1").cgColor  // 원하는 색상으로 변경
        self.layer.addSublayer(bottomBorder)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    func addPWBottomShadow() {
        self.borderStyle = .none  // 기본 테두리 없애기
        // 하단 테두리 추가
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1.5)
        bottomBorder.backgroundColor = UIColor(hexCode: "FF4A4A").cgColor  // 원하는 색상으로 변경
        self.layer.addSublayer(bottomBorder)
    }
}




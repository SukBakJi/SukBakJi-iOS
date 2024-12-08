//
//  TFaddShadow.swift
//  Sukbakji
//
//  Created by jaegu park on 8/9/24.
//

import Foundation
import UIKit

extension UITextField {
    func addTFUnderline() {
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
        
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    func addTFRedUnderline() {
        let underline = UIView()
        underline.backgroundColor = UIColor(hexCode: "FF4A4A")
        self.superview?.addSubview(underline)
        underline.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(1.5)
        }
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




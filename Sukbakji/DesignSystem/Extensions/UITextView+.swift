//
//  UITextView+.swift
//  Sukbakji
//
//  Created by jaegu park on 12/20/24.
//

import UIKit

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
        underline.backgroundColor = .gray300
        self.superview?.addSubview(underline)
        
        underline.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom) // 텍스트 뷰 바로 아래
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(1.5) // 언더라인 높이
        }
    }
    
    func errorfix() {
        self.autocorrectionType = .no
        self.spellCheckingType = .no
    }
}

//
//  UIColor+Extension+.swift
//  Sukbakji
//
//  Created by jaegu park on 1/24/25.
//

import UIKit

extension UIColor {
    static let shadow = UIColor(white: 242/256, alpha: 1)
    
    static let gray50 = UIColor(hexCode: "FAFAFA")
    static let gray100 = UIColor(hexCode: "F5F5F5")
    static let gray200 = UIColor(hexCode: "EFEFEF")
    static let gray300 = UIColor(hexCode: "E1E1E1")
    static let gray400 = UIColor(hexCode: "BEBEBE")
    static let gray500 = UIColor(hexCode: "9F9F9F")
    static let gray600 = UIColor(hexCode: "767676")
    static let gray700 = UIColor(hexCode: "626262")
    static let gray800 = UIColor(hexCode: "434343")
    static let gray900 = UIColor(hexCode: "222222")
    
    static let orange50 = UIColor(hexCode: "FDE9E6")
    static let orange100 = UIColor(hexCode: "FFCCBA")
    static let orange200 = UIColor(hexCode: "FFAB8E")
    static let orange300 = UIColor(hexCode: "FF8A60")
    static let orange400 = UIColor(hexCode: "FF703B")
    static let orange500 = UIColor(hexCode: "FF5614")
    static let orange600 = UIColor(hexCode: "FA500F")
    static let orange700 = UIColor(hexCode: "EC4908")
    static let orange800 = UIColor(hexCode: "DE4103")
    static let orange900 = UIColor(hexCode: "C63300")
    
    static let blue50 = UIColor(hexCode: "E9EBFF")
    static let blue400 = UIColor(hexCode: "4A72FF")
    
    static let warning50 = UIColor(hexCode: "FFEBEE")
    static let warning400 = UIColor(hexCode: "FF4A4A")
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

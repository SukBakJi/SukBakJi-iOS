//
//  UIFont+.swift
//  Sukbakji
//
//  Created by 오현민 on 3/10/25.
//

import Foundation
import UIKit

struct AppFontName {
    static let preBold = "Pretendard-Bold"
    static let preSemiBold = "Pretendard-SemiBold"
    static let preMedium = "Pretendard-Medium"
    static let preRegular = "Pretendard-Regular"
    static let inRegular = "Inter-Regular"
    static let suiteMedium = "SUITE-Medium"
    static let suiteRegular = "SUITE-Regular"
}

extension UIFont {
    // Title Fonts
    public class func title1() -> UIFont {
        return createFont(name: AppFontName.preBold, size: 26, lineHeight: 40, kerningFactor: -0.04)
    }
    
    public class func title2() -> UIFont {
        return createFont(name: AppFontName.preSemiBold, size: 22, lineHeight: nil, kerningFactor: -0.04)
    }
    
    public class func title3() -> UIFont {
        return createFont(name: AppFontName.preSemiBold, size: 20, lineHeight: nil, kerningFactor: -0.02)
    }
    
    // Head Fonts
    public class func head1() -> UIFont {
        return createFont(name: AppFontName.preSemiBold, size: 18, lineHeight: 26, kerningFactor: -0.04)
    }
    
    public class func head2() -> UIFont {
        return createFont(name: AppFontName.preSemiBold, size: 18, lineHeight: nil, kerningFactor: -0.04)
    }
    
    // Body Fonts
    public class func body1() -> UIFont {
        return createFont(name: AppFontName.preSemiBold, size: 16, lineHeight: nil, kerningFactor: -0.02)
    }
    
    public class func body2() -> UIFont {
        return createFont(name: AppFontName.preMedium, size: 16, lineHeight: nil, kerningFactor: -0.02)
    }
    
    public class func body3() -> UIFont {
        return createFont(name: AppFontName.preSemiBold, size: 14, lineHeight: nil, kerningFactor: -0.02)
    }
    
    public class func body4() -> UIFont {
        return createFont(name: AppFontName.preMedium, size: 14, lineHeight: nil, kerningFactor: -0.02)
    }
    
    // popup Fonts
    public class func popup() -> UIFont {
        return createFont(name: AppFontName.preMedium, size: 14, lineHeight: nil, kerningFactor: -0.04)
    }
    
    // Caption Fonts
    public class func caption1() -> UIFont {
        return createFont(name: AppFontName.inRegular, size: 12, lineHeight: nil, kerningFactor: 0)
    }
    
    public class func caption2() -> UIFont {
        return createFont(name: AppFontName.preMedium, size: 12, lineHeight: nil, kerningFactor: -0.04)
    }
    
    public class func caption3() -> UIFont {
        return createFont(name: AppFontName.preMedium, size: 12, lineHeight: 18, kerningFactor: -0.04)
    }
    
    public class func caption4() -> UIFont {
        return createFont(name: AppFontName.preRegular, size: 11, lineHeight: nil, kerningFactor: -0.02)
    }
    
    public class func caption5() -> UIFont {
        return createFont(name: AppFontName.preRegular, size: 10, lineHeight: nil, kerningFactor: -0.02)
    }
    
    // Sub Fonts
    public class func sub1() -> UIFont {
        return createFont(name: AppFontName.suiteMedium, size: 14, lineHeight: nil, kerningFactor: -0.02)
    }
    
    public class func sub2() -> UIFont {
        return createFont(name: AppFontName.suiteRegular, size: 14, lineHeight: nil, kerningFactor: -0.02)
    }
    
    // Create Font with letter spacing and line height
    private class func createFont(name: String, size: CGFloat, lineHeight: CGFloat?, kerningFactor: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            fatalError("Font \(name) not found")
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        if let lineHeight = lineHeight {
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: size * kerningFactor,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedFont = NSAttributedString(string: "a", attributes: attributes)
        return attributedFont.attributes(at: 0, effectiveRange: nil)[.font] as! UIFont
    }
}

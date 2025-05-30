//
//  smallTextButton.swift
//  Sukbakji
//
//  Created by 오현민 on 3/4/25.
//

import UIKit

class smallTextButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        configure(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(title: String) {
        var container = AttributeContainer()
        container.font = UIFont(name: "Pretendard-Regular", size: 12)
        
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .gray600
        config.attributedTitle = AttributedString(title, attributes: container)
        config.titleAlignment = .center
        
        self.configuration = config
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var intrinsicContentSize: CGSize {
        guard let title = self.title(for: .normal), let font = self.titleLabel?.font else {
            return super.intrinsicContentSize
        }
        
        let textSize = (title as NSString).size(withAttributes: [.font: font])
        return CGSize(width: textSize.width + 16, height: textSize.height + 16) // 좌우 +8, 위아래 +8
    }
}

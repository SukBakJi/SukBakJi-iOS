//
//  Dot+Extension.swift
//  Sukbakji
//
//  Created by jaegu park on 12/6/24.
//

import UIKit
import SnapKit

extension UILabel {
    func addImageAboveLabel(referenceView: UIView, spacing: CGFloat) {
        guard let superview = self.superview else {
            print("Error: UILabel must be added to a superview before calling this method.")
            return
        }
        
        let imageView = UIImageView(image: UIImage(named: "Sukbakji_Dot"))
        imageView.contentMode = .scaleAspectFit
        superview.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(referenceView.snp.bottom).offset(spacing) // UILabel 위에 위치
            make.leading.equalTo(self.snp.trailing).offset(4) // UILabel과 중심 정렬
            make.height.width.equalTo(4) // 이미지 크기 설정
        }
    }
}

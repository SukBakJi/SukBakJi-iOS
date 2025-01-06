//
//  AdvertiseCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/1/24.
//

import UIKit
import Then
import SnapKit

class AdvertiseCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: AdvertiseCollectionViewCell.self)
    
    private let adImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_AD")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 15
        layer.masksToBounds = false
        
        self.contentView.addSubview(adImageView)
        adImageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}

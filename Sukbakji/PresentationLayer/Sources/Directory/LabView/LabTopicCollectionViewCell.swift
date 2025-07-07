//
//  LabTopicCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 7/2/25.
//

import UIKit
import Then
import SnapKit

class LabTopicCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: LabTopicCollectionViewCell.self)
    
    private let labelView = UIView().then {
        $0.backgroundColor = UIColor.orange700
        $0.layer.cornerRadius = 15
    }
    private let labelLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
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
        contentView.addSubview(labelView)
        labelView.snp.makeConstraints { make in
           make.edges.equalToSuperview()
        }
        
        labelView.addSubview(labelLabel)
        labelLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func prepare(topics: String) {
        labelLabel.text = "#\(topics)"
    }
}

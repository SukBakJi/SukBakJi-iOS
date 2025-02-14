//
//  ResearchTopicCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 8/5/24.
//

import UIKit
import Then
import SnapKit

class ResearchTopicCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ResearchTopicCollectionViewCell.self)
    
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
        self.contentView.addSubview(labelView)
        labelView.snp.makeConstraints { make in
           make.edges.equalToSuperview().offset(18)
        }
        
        self.labelView.addSubview(labelLabel)
        labelLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func prepare(topics: String) {
        labelLabel.text = topics
    }
}

//
//  LabRecentCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 6/18/25.
//

import UIKit
import Then
import SnapKit

class LabRecentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: LabRecentCollectionViewCell.self)
    
    var onDeleteTapped: (() -> Void)?
    
    private let labelView = UIView().then {
        $0.backgroundColor = UIColor.gray50
        $0.layer.cornerRadius = 15
    }
    private let labelLabel = UILabel().then {
        $0.textColor = .gray500
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    }
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Cross"), for: .normal)
    }
    private lazy var recentStackView = UIStackView().then {
        $0.addArrangedSubview(labelLabel)
        $0.addArrangedSubview(deleteButton)
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
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
        
        labelView.addSubview(recentStackView)
        recentStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(17)
        }
        deleteButton.addTarget(self, action: #selector(delete_Tapped), for: .touchUpInside)
    }
    
    @objc private func delete_Tapped() {
        onDeleteTapped?()
    }
    
    func configure(keyword: String) {
        labelLabel.text = keyword
    }
}

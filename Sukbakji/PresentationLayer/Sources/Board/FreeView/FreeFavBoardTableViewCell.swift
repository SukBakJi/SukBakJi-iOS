//
//  FreeFavBoardTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 5/21/25.
//

import UIKit
import Then
import SnapKit

class FreeFavBoardTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: FreeFavBoardTableViewCell.self)
    
    let favButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_FavButton"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    let labelView = UIView().then {
        $0.backgroundColor = .orange50
        $0.layer.cornerRadius = 4
    }
    let labelLabel = UILabel().then {
        $0.textColor = .orange400
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    let nameLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        self.contentView.addSubview(favButton)
        favButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(40)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(24)
        }
        
        self.contentView.addSubview(labelView)
        labelView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(favButton.snp.trailing).offset(16)
            $0.height.equalTo(20)
        }
        
        self.labelView.addSubview(labelLabel)
        labelLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(labelView.snp.trailing).offset(10)
            $0.height.equalTo(21)
        }
    }
}

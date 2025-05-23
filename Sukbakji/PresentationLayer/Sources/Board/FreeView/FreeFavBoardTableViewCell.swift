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
        favButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        self.contentView.addSubview(labelView)
        labelView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(favButton.snp.trailing).offset(16)
            make.height.equalTo(20)
        }
        
        self.labelView.addSubview(labelLabel)
        labelLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(7)
            make.centerY.equalToSuperview()
            make.height.equalTo(14)
        }
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(labelView.snp.trailing).offset(10)
            make.height.equalTo(21)
        }
    }
}

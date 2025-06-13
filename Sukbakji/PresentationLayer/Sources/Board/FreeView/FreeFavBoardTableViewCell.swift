//
//  FreeFavBoardTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 5/21/25.
//

import UIKit
import Then
import SnapKit

protocol FavBoardCellDelegate: AnyObject {
    func fav_Tapped(cell: FreeFavBoardTableViewCell)
    func more_Tapped(cell: FreeFavBoardTableViewCell)
}

class FreeFavBoardTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: FreeFavBoardTableViewCell.self)
    
    weak var delegate: FavBoardCellDelegate?
    
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
    let goButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_More"), for: .normal)
        $0.contentMode = .scaleAspectFit
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
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(40)
        }
        favButton.addTarget(self, action: #selector(fav_Tapped), for: .touchUpInside)
        
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
        
        self.contentView.addSubview(goButton)
        goButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(40)
        }
        goButton.addTarget(self, action: #selector(more_Tapped), for: .touchUpInside)
    }
    
    @objc private func fav_Tapped() {
        delegate?.fav_Tapped(cell: self)
    }
    
    @objc private func more_Tapped() {
        delegate?.more_Tapped(cell: self)
    }
    
    func prepare(favorite: Favorite) {
        labelLabel.text = favorite.label
        nameLabel.text = favorite.boardName
    }
}

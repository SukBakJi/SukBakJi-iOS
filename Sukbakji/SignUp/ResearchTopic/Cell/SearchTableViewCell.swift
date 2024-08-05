//
//  SearchTableViewCell.swift
//  Sukbakji
//
//  Created by 오현민 on 8/3/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    let checkButton = UIButton().then {
        $0.setImage(UIImage(named: "check=off"), for: .normal)
        $0.setImage(UIImage(named: "check=on"), for: .selected)
        $0.adjustsImageWhenHighlighted = false
    }
    
    let topicLabel = UILabel().then {
        $0.text = "HCI"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Medium", size: 18)
        $0.numberOfLines = 1
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(checkButton)
        contentView.addSubview(topicLabel)
        
        checkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(41)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
        
        topicLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

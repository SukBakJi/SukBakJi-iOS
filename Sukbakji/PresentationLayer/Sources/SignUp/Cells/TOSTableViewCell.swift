//
//  TOSTableViewCell.swift
//  Sukbakji
//
//  Created by 오현민 on 8/5/24.
//

import UIKit
import SnapKit

class TOSTableViewCell: UITableViewCell {
    weak var delegate: TOSCellDelegate?
    
    let checkButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_check=off"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_check=on"), for: .selected)
    }
    let readMoreButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_arrow-right"), for: .normal)
    }
    let consentLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textAlignment = .left
    }
    let requiredView = UIView().then {
        $0.backgroundColor = .orange50
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    let requiredLabel = UILabel().then {
        $0.text = "필수"
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .orange600
    }
    
    @objc
    private func didTapReadMoreButton() {
        delegate?.didTapReadMore(in: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        readMoreButton.addTarget(self, action: #selector(didTapReadMoreButton), for: .touchUpInside)


        requiredView.addSubview(requiredLabel)
        contentView.addSubviews([checkButton, requiredView, consentLabel, readMoreButton])
        
        checkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(40)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        requiredView.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(37) 
        }
        
        requiredLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
        
        consentLabel.snp.makeConstraints { make in
            make.leading.equalTo(requiredView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        readMoreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

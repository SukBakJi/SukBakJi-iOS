//
//  NotificationTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 4/1/25.
//

import UIKit
import Then
import SnapKit

class NotificationTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: NotificationTableViewCell.self)
    
    private let titleLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    private let bodyLabel = UILabel().then {
        $0.textColor = .gray300
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
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
        self.contentView.backgroundColor = .white
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(17)
        }
        
        self.contentView.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(36)
        }
    }
}

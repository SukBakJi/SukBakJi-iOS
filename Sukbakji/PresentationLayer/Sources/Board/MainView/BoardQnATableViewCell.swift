//
//  BoardQnATableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import Then
import SnapKit

class BoardQnATableViewCell: UITableViewCell {
    
    static let identifier = String(describing: BoardQnATableViewCell.self)
    
    private let labelView = UIView().then {
        $0.backgroundColor = .blue50
        $0.layer.cornerRadius = 4
    }
    private let labelLabel = UILabel().then {
        $0.textColor = .blue400
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let contentLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    private let separatorView = UIView().then {
        $0.backgroundColor = .gray100
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
        
        self.contentView.addSubview(labelView)
        labelView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        self.labelView.addSubview(labelLabel)
        labelLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(labelView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        self.contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.2)
        }
    }
    
    func prepare(qna: QnA) {
        self.labelLabel.text = qna.menu
        self.contentLabel.text = qna.title
    }
}

//
//  CalendarDetailTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/12/24.
//

import UIKit
import Then
import SnapKit

class CalendarDetailTableViewCell: UITableViewCell {

    static let identifier = String(describing: CalendarDetailTableViewCell.self)
    
    private let mainImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_RecruitType")
    }
    private let univLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    private let contentLabel = UILabel().then {
        $0.textColor = UIColor(named: "Coquelicot")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
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
        self.contentView.backgroundColor = UIColor(named: "ViewBackground")
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.gray200.cgColor
        self.contentView.clipsToBounds = true
        
        self.contentView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        self.contentView.addSubview(univLabel)
        univLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(mainImageView.snp.trailing).offset(8)
            make.height.equalTo(19)
        }
        
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(univLabel.snp.trailing).offset(8)
            make.height.equalTo(19)
        }
    }
    
    func prepare(dateSelectList: DateSelectList) {
        if dateSelectList.univId == 1 {
            univLabel.text = "서울대학교"
        } else if dateSelectList.univId == 2 {
            univLabel.text = "연세대학교"
        } else if dateSelectList.univId == 3 {
            univLabel.text = "고려대학교"
        } else {
            univLabel.text = "카이스트"
        }
        self.contentLabel.text = dateSelectList.content
    }
}

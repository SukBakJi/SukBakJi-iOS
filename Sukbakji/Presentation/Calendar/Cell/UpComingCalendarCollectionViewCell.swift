//
//  UpComingCalendarCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/12/24.
//

import UIKit
import Then
import SnapKit

class UpComingCalendarCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: UpComingCalendarCollectionViewCell.self)
    
    private let layerImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Layer")
    }
    private let dDayLabel = UILabel().then {
        $0.textColor = UIColor(named: "Coquelicot")
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let univLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let contentLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
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
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        self.contentView.addSubview(layerImageView)
        layerImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(6)
        }
        
        self.contentView.addSubview(dDayLabel)
        dDayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(layerImageView.snp.trailing).offset(10)
            make.height.equalTo(15)
        }
        
        self.contentView.addSubview(univLabel)
        univLabel.snp.makeConstraints { make in
            make.top.equalTo(dDayLabel.snp.bottom).offset(4)
            make.leading.equalTo(layerImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }
        
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(univLabel.snp.bottom).offset(4)
            make.leading.equalTo(layerImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }
    }
    
    func prepare(upComingList: UpComingList) {
        dDayLabel.text = String(upComingList.dday)
        if upComingList.univId == 1 {
            univLabel.text = "서울대학교"
        } else if upComingList.univId == 2 {
            univLabel.text = "연세대학교"
        } else if upComingList.univId == 3 {
            univLabel.text = "고려대학교"
        } else {
            univLabel.text = "카이스트"
        }
        contentLabel.text = upComingList.content
    }
}

//
//  CalendarMainCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/12/24.
//

import UIKit
import Then
import SnapKit

class CalendarMainCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CalendarMainCollectionViewCell.self)
    
    private let dayView = UIView().then {
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
    }
    private let dayLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "SUITE-Medium", size: 14)
    }
    let dotImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Dot")
    }
    private let circleImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Circle")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUI()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                if dayLabel.text != "" {
                    self.dayView.layer.cornerRadius = self.dayView.frame.size.width / 2
                    self.dayView.backgroundColor = .orange700
                    self.dayLabel.textColor = .white
                }
            } else {
                self.dayView.backgroundColor = .clear
                self.dayLabel.textColor = .gray900
            }
        }
    }
    
    private func setUI() {
        self.contentView.addSubview(dayView)
        dayView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(5)
        }
        
        self.dayView.addSubview(circleImageView)
        circleImageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.dayView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.dayView.addSubview(dotImageView)
        dotImageView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(1)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(4)
        }
    }
    
    func updateDay(day: String, isToday: Bool = false, isCurrentMonth: Bool = true) {
        self.dayLabel.text = day
        self.dayLabel.textColor = isCurrentMonth ? .gray900 : .gray300
        self.circleImageView.isHidden = !(isToday && isCurrentMonth)
    }
}

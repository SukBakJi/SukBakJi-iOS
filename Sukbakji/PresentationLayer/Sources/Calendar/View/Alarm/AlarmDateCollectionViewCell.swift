//
//  AlarmDateCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 1/5/25.
//

import UIKit
import Then
import SnapKit

class AlarmDateCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: AlarmDateCollectionViewCell.self)
    
    private let dayView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let dayLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "SUITE-Medium", size: 14)
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
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                if dayLabel.text != "" {
                    self.dayView.layer.cornerRadius = self.dayView.frame.size.width / 2
                    self.dayView.clipsToBounds = true
                    self.dayView.backgroundColor = UIColor(named: "Coquelicot")
                    self.dayLabel.textColor = .white
                }
            } else {
                self.dayView.backgroundColor = .gray50
                self.dayView.backgroundColor = UIColor.orange50
                self.dayLabel.textColor = .black
            }
        }
    }
    
    private func setUI() {
        self.contentView.addSubview(dayView)
        dayView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        self.dayView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func updateDay(day: String) {
        self.dayLabel.text = day
    }
}

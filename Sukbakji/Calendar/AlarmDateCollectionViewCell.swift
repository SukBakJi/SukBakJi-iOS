//
//  AlarmDateCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 7/31/24.
//

import UIKit

class AlarmDateCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlarmDateCollectionViewCell"
    
    private lazy var dayLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureDay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureDay()
    }
    
    override func prepareForReuse() {
        self.dayLabel.text = nil
    }
    
    private func configureDay() {
        self.addSubview(self.dayLabel)
        self.dayLabel.textColor = .black
        self.dayLabel.font = UIFont(name: "SUITE-Medium", size: 14)
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func updateDay(day: String) {
        self.dayLabel.text = day
    }
}

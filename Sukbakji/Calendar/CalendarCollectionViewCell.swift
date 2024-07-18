//
//  CalendarCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 7/18/24.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalendarCollectionViewCell"
    
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
        self.dayLabel.font = .monospacedSystemFont(ofSize: 14, weight: .medium)
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

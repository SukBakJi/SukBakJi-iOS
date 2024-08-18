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
    private lazy var dayView = UIView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureDay()
        self.configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureDay()
        self.configureView()
    }
    
    override func prepareForReuse() {
        self.dayLabel.text = nil
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
                self.dayView.backgroundColor = UIColor(named: "ViewBackground")
                self.dayLabel.textColor = .black
            }
        }
    }
    
    private func configureView() {
        self.addSubview(self.dayView)
        self.dayView.backgroundColor = UIColor(named: "ViewBackground")
        self.dayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dayView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            self.dayView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2.5),
            self.dayView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2.5),
            self.dayView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 6)
        ])
    }
    
    private func configureDay() {
        self.dayView.addSubview(self.dayLabel)
        self.dayLabel.textColor = .black
        self.dayLabel.font = UIFont(name: "SUITE-Medium", size: 14)
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dayLabel.centerYAnchor.constraint(equalTo: self.dayView.centerYAnchor),
            self.dayLabel.centerXAnchor.constraint(equalTo: self.dayView.centerXAnchor)
        ])
    }
    
    func updateDay(day: String) {
        self.dayLabel.text = day
    }
}

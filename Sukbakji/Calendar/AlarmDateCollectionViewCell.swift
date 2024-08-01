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
    
    private func configureView() {
        self.addSubview(self.dayView)
        self.dayView.backgroundColor = .white
        self.dayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dayView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.dayView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.dayView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.dayView.bottomAnchor.constraint(equalTo: self.bottomAnchor,  constant: 0)
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

//
//  CalendarMainCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/12/24.
//

import UIKit

class CalendarMainCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CalendarMainCollectionViewCell.self)
    
    private let dayView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let dayLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "SUITE-Medium", size: 14)
    }
    let dotImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Dot")
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
                self.dayView.backgroundColor = UIColor(named: "ViewBackground")
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
        self.dayView.addSubview(dotImageView)
        dotImageView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(4)
        }
    }
    
    func updateDay(day: String) {
        self.dayLabel.text = day
    }
}

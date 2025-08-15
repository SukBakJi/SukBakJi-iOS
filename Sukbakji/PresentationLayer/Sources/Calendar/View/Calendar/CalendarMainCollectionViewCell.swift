//
//  CalendarMainCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/12/24.
//

import UIKit
import Then
import SnapKit

final class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let r = min(bounds.width, bounds.height) / 2
        if layer.cornerRadius != r {
            layer.cornerRadius = r
        }
        layer.masksToBounds = true
    }
}

class CalendarMainCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CalendarMainCollectionViewCell.self)
    
    private let dayView = CircleView().then {
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
    
    private var isTodayCell: Bool = false
    private var isInCurrentMonth: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUI()
        applyAppearance()
    }
    
    override var isSelected: Bool {
        didSet {
            applyAppearance()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isTodayCell = false
        isInCurrentMonth = true
        // 선택 상태는 UICollectionView가 관리하지만, 외형은 다시 맞춰줌
        applyAppearance()
    }
    
    private func setUI() {
        if dayView.superview == nil {
            contentView.addSubview(dayView)
            dayView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(5)
            }
            
            dayView.addSubview(dayLabel)
            dayLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
            
            dayView.addSubview(dotImageView)
            dotImageView.snp.makeConstraints { make in
                make.top.equalTo(dayLabel.snp.bottom).offset(1)
                make.centerX.equalToSuperview()
                make.height.width.equalTo(4)
            }
        }
    }
    
    private func applyAppearance() {
        // 선택 > 오늘 > 기본 순서로 우선순위 적용
        if isSelected, dayLabel.text != "" {
            dayView.backgroundColor = .orange700
            dayLabel.textColor = .white
        } else if isTodayCell && isInCurrentMonth {
            dayView.backgroundColor = .orange50
            dayLabel.textColor = .gray900
        } else {
            dayView.backgroundColor = .clear
            dayLabel.textColor = isInCurrentMonth ? .gray900 : .gray300
        }
    }
    
    func updateDay(day: String, isToday: Bool = false, isCurrentMonth: Bool = true) {
        self.dayLabel.text = day
        isTodayCell = isToday
        isInCurrentMonth = isCurrentMonth
        applyAppearance()
    }
}

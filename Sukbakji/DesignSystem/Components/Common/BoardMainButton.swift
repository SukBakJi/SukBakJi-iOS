//
//  BoardMainButton.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit

class BoardMainButton: UIButton {
    
    private let titleLabelView = UILabel()
    private let iconImageView = UIImageView()
    
    init(title: String, icon: UIImage?) {
        super.init(frame: .zero)
        setUI(title: title, icon: icon)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI(title: "", icon: nil)
    }
    
    private func setUI(title: String, icon: UIImage?) {
        backgroundColor = .gray50
        layer.cornerRadius = 4
        clipsToBounds = true
        
        titleLabelView.text = title
        titleLabelView.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        titleLabelView.textColor = .gray900
        titleLabelView.isUserInteractionEnabled = false
        
        iconImageView.image = icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iconImageView.isUserInteractionEnabled = false
        
        let stackView = UIStackView(arrangedSubviews: [titleLabelView, iconImageView])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }
}

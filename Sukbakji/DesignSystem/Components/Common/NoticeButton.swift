//
//  NoticeButton.swift
//  Sukbakji
//
//  Created by jaegu park on 5/14/25.
//

import UIKit
import SnapKit
import Then

class NoticeButton: UIButton {
    
    var messageLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        messageLabel.text = title
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.orange700.cgColor
        layer.cornerRadius = 8
        clipsToBounds = true
        
        let speakerIcon = UIImageView(image: UIImage(named: "Sukbakji_Notice"))
        speakerIcon.translatesAutoresizingMaskIntoConstraints = false
        speakerIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        speakerIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        speakerIcon.isUserInteractionEnabled = false

        let noticeLabel = UILabel()
        noticeLabel.text = "공지"
        noticeLabel.textColor = .orange700
        noticeLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        noticeLabel.isUserInteractionEnabled = false

        let divider = UIView()
        divider.backgroundColor = UIColor.lightGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        divider.isUserInteractionEnabled = false
        
        messageLabel.isUserInteractionEnabled = false

        let stackView = UIStackView(arrangedSubviews: [speakerIcon, noticeLabel, divider, messageLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

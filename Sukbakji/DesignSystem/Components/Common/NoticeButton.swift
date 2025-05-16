//
//  NoticeButton.swift
//  Sukbakji
//
//  Created by jaegu park on 5/14/25.
//

import UIKit

class NoticeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.orange700.cgColor
        layer.cornerRadius = 8
        clipsToBounds = true
        
        let speakerIcon = UIImageView(image: UIImage(named: "Sukbakji_Notice"))
        speakerIcon.translatesAutoresizingMaskIntoConstraints = false
        speakerIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        speakerIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let noticeLabel = UILabel()
        noticeLabel.text = "공지"
        noticeLabel.textColor = .orange700
        noticeLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)

        let divider = UIView()
        divider.backgroundColor = UIColor.lightGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let messageLabel = UILabel()
        messageLabel.text = "게시판 내 개인정보 유추 금지와 관련하여 안내드립니다"
        messageLabel.textColor = .gray900
        messageLabel.font = UIFont(name: "Pretendard-Medium", size: 12)

        let stackView = UIStackView(arrangedSubviews: [speakerIcon, noticeLabel, divider, messageLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

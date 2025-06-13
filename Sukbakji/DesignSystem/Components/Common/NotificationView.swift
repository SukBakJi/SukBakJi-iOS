//
//  NotificationView.swift
//  Sukbakji
//
//  Created by jaegu park on 4/1/25.
//

import UIKit
import SnapKit
import Then

class NotificationView: UIView {
    
    let navigationbarView = NavigationBarView(title: "알림")
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let notificationTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .singleLine
        $0.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identifier)
        $0.allowsSelection = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        addSubview(navigationbarView)
        addSubview(backgroundLabel)
        addSubview(notificationTableView)
    }
    
    private func setConstraints() {
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        notificationTableView.snp.makeConstraints {
            $0.top.equalTo(backgroundLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

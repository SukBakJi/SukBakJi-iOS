//
//  MyPostView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/23/25.
//

import UIKit
import Then
import SnapKit

class MyPostView: UIView {
    
    var navigationbarView = NavigationBarView(title: "")
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let myPostTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(MyPostTableViewCell.self, forCellReuseIdentifier: MyPostTableViewCell.identifier)
        $0.allowsSelection = false
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.navigationbarView = NavigationBarView(title: title)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(navigationbarView)
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        addSubview(myPostTableView)
        myPostTableView.snp.makeConstraints {
            $0.top.equalTo(backgroundLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

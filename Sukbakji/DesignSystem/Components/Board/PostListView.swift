//
//  PostListView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/14/25.
//

import UIKit
import Then
import SnapKit

class PostListView: UIView {
    
    var optionNavigationbarView = OptionNavigationBarView(title: "질문 게시판")
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let noticeButton = NoticeButton()
    let postListTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    $0.register(QnAListTableViewCell.self, forCellReuseIdentifier: QnAListTableViewCell.identifier)
        $0.allowsSelection = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white

        addSubview(optionNavigationbarView)
        addSubview(backgroundLabel)
        addSubview(noticeButton)
        addSubview(postListTableView)
    }
    
    private func setupConstraints() {
        optionNavigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.top.equalTo(optionNavigationbarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        noticeButton.snp.makeConstraints {
            $0.top.equalTo(backgroundLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        
        postListTableView.snp.makeConstraints {
            $0.top.equalTo(noticeButton.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

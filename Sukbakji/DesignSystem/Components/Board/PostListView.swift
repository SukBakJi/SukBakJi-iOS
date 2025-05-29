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
    
    var optionNavigationbarView = OptionNavigationBarView(title: "", buttonHidden: true)
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    var noticeButton = NoticeButton(title: "")
    let postListTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(PostListTableViewCell.self, forCellReuseIdentifier: PostListTableViewCell.identifier)
        $0.allowsSelection = true
    }
    let writingButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Write"), for: .normal)
    }
    
    
    init(title: String, buttonTitle: String, buttonHidden: Bool) {
        super.init(frame: .zero)
        self.optionNavigationbarView = OptionNavigationBarView(title: title, buttonHidden: buttonHidden)
        self.noticeButton = NoticeButton(title: buttonTitle)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white

        addSubview(optionNavigationbarView)
        addSubview(backgroundLabel)
        addSubview(noticeButton)
        addSubview(postListTableView)
        addSubview(writingButton)
    }
    
    private func setConstraints() {
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
        
        writingButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(48)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(60)
        }
    }
}

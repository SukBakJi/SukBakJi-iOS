//
//  PostDetailView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/24/25.
//

import UIKit
import Then
import SnapKit

class PostDetailView: UIView {
    
    var optionNavigationbarView = OptionNavigationBarView(title: "", buttonHidden: false)
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    let labelView = UIView().then {
        $0.backgroundColor = .blue50
        $0.layer.cornerRadius = 4
    }
    let labelLabel = UILabel().then {
        $0.textColor = .blue400
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    let scrapButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Bookmark"), for: .normal)
    }
    let titleLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    let contentLabel = UILabel().then {
        $0.textColor = .gray900
        $0.numberOfLines = 4
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    let commentImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Comment")
    }
    let commentLabel = UILabel().then {
        $0.textColor = .blue400
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    let viewImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_View")
    }
    let viewLabel = UILabel().then {
        $0.textColor = .orange700
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    let layerView = UIView().then {
        $0.backgroundColor = .gray100
    }
    let commentListTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(CommentListTableViewCell.self, forCellReuseIdentifier: CommentListTableViewCell.identifier)
        $0.allowsSelection = false
    }
    let commentInputView = CommentInputView()
    
    init(title: String) {
        super.init(frame: .zero)
        self.optionNavigationbarView = OptionNavigationBarView(title: title, buttonHidden: false)
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
        
        addSubview(contentView)
        contentView.addSubview(labelView)
        labelView.addSubview(labelLabel)
        contentView.addSubview(scrapButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(viewLabel)
        contentView.addSubview(viewImageView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(commentImageView)
        
        addSubview(layerView)
        addSubview(commentListTableView)
        addSubview(commentInputView)
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
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(backgroundLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(200)
        }
        
        labelView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        labelLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        scrapButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.height.width.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(labelView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        viewLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        viewImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalTo(viewLabel.snp.leading).offset(-4)
            $0.width.height.equalTo(14)
        }
        
        commentLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalTo(viewImageView.snp.leading).offset(-16)
            $0.height.equalTo(14)
        }
        
        commentImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalTo(commentLabel.snp.leading).offset(-4)
            $0.width.height.equalTo(14)
        }
        
        layerView.snp.makeConstraints {
            $0.top.equalTo(commentImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        commentListTableView.snp.makeConstraints {
            $0.top.equalTo(layerView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        commentInputView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
}

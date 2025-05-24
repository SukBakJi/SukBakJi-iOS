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
        $0.separatorStyle = .singleLine
        $0.backgroundColor = .clear
        $0.register(CommentListTableViewCell.self, forCellReuseIdentifier: CommentListTableViewCell.identifier)
        $0.allowsSelection = false
    }
    
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
    }
    
    private func setConstraints() {
    }
}

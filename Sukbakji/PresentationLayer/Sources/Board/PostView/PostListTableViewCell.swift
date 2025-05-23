//
//  PostListTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 5/15/25.
//

import UIKit
import Then
import SnapKit

class PostListTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: PostListTableViewCell.self)
    
    private let titleLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    private let contentLabel = UILabel().then {
        $0.textColor = .gray900
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let commentImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Comment")
    }
    private let commentLabel = UILabel().then {
        $0.textColor = .blue400
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let viewImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_View")
    }
    private let viewLabel = UILabel().then {
        $0.textColor = .orange700
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.gray100.cgColor
        self.contentView.clipsToBounds = false
        self.contentView.backgroundColor = .white
        
        self.contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(18)
            make.height.equalTo(17)
        }
        
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(18)
            make.height.equalTo(36)
        }
        
        self.contentView.addSubview(viewLabel)
        viewLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(18)
            make.height.equalTo(14)
        }
        
        self.contentView.addSubview(viewImageView)
        viewImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(17)
            make.trailing.equalTo(viewLabel.snp.leading).offset(-3)
            make.width.height.equalTo(12)
        }
        
        self.contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(viewImageView.snp.leading).offset(-12)
            make.height.equalTo(14)
        }
        
        self.contentView.addSubview(commentImageView)
        commentImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(17)
            make.trailing.equalTo(commentLabel.snp.leading).offset(-3)
            make.width.height.equalTo(12)
        }
    }
    
    func postPrepare(post: Post) {
        titleLabel.text = post.title
        contentLabel.text = post.previewContent
        commentLabel.text = String(post.commentCount)
        viewLabel.text = String(post.views)
    }
    
    func hotPrepare(hotPost: HotPost) {
        titleLabel.text = hotPost.title
        contentLabel.text = hotPost.content
        commentLabel.text = String(hotPost.commentCount)
        viewLabel.text = String(hotPost.views)
    }
}

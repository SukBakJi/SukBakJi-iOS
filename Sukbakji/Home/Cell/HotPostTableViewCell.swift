//
//  HotPostTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/1/24.
//

import UIKit

class HotPostTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: HotPostTableViewCell.self)

    private let labelView = UIView().then {
        $0.backgroundColor = UIColor(red: 253/255, green: 233/255, blue: 230/255, alpha: 1.0)
    }
    private let labelLabel = UILabel().then {
        $0.text = "조회수 TOP"
        $0.textColor = UIColor(named: "Coquelicot")
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let labelView2 = UIView().then {
        $0.backgroundColor = .gray100
    }
    private let labelLabel2 = UILabel().then {
        $0.textColor = .gray200
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let titleLabel = UILabel().then {
       $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    private let contentLabel = UILabel().then {
       $0.textColor = .black
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let commentImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Comment")
    }
    private let commentLabel = UILabel().then {
        $0.textColor = UIColor(red: 74/255, green: 114/255, blue: 255/255, alpha: 1.0)
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let viewImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_View")
    }
    private let viewLabel = UILabel().then {
        $0.textColor = UIColor(named: "Coquelicot")
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
        
        self.contentView.addSubview(labelView)
        labelView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
           make.leading.equalToSuperview().offset(18)
           make.height.equalTo(20)
        }
        
        self.labelView.addSubview(labelLabel)
        labelLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(7)
           make.centerY.equalToSuperview()
           make.height.equalTo(26)
        }
        
        self.contentView.addSubview(labelView2)
        labelView2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(labelView.snp.trailing).offset(6)
           make.height.equalTo(20)
        }
        
        self.labelView2.addSubview(labelLabel2)
        labelLabel2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(7)
           make.centerY.equalToSuperview()
           make.height.equalTo(26)
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(18)
           make.height.equalTo(17)
        }
        
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.leading.equalToSuperview().offset(18)
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
            make.trailing.equalTo(viewLabel.snp.leading).inset(3)
            make.width.height.equalTo(12)
        }
        
        self.contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(viewImageView.snp.leading).inset(12)
           make.height.equalTo(14)
        }
        
        self.contentView.addSubview(commentImageView)
        commentImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(17)
            make.trailing.equalTo(commentLabel.snp.leading).inset(3)
            make.width.height.equalTo(12)
        }
    }

    func prepare(hotPost: HotPost) {
        labelLabel2.text = hotPost.boardName
        titleLabel.text = hotPost.title
        contentLabel.text = hotPost.content
        commentLabel.text = String(hotPost.commentCount)
        viewLabel.text = String(hotPost.views)
    }
}

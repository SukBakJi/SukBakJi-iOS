//
//  FavoriteBoardCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import Then
import SnapKit

class FavoriteBoardCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: FavoriteBoardCollectionViewCell.self)
    
    private let labelView = UIView().then {
        $0.backgroundColor = .orange50
        $0.layer.cornerRadius = 4
    }
    private let labelLabel = UILabel().then {
        $0.textColor = UIColor.orange600
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let labelView2 = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 4
    }
    private let labelLabel2 = UILabel().then {
        $0.textColor = .gray500
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray100.cgColor
        contentView.clipsToBounds = false
        contentView.backgroundColor = .white
        
        layer.cornerRadius = 15
        layer.masksToBounds = false
        
        self.contentView.addSubview(labelView)
        labelView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(18)
            $0.height.equalTo(20)
        }
        
        self.labelView.addSubview(labelLabel)
        labelLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        self.contentView.addSubview(labelView2)
        labelView2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(labelView.snp.trailing).offset(6)
            $0.height.equalTo(20)
        }
        
        self.labelView2.addSubview(labelLabel2)
        labelLabel2.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(labelView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(18)
            $0.height.equalTo(17)
        }
        
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(36)
        }
        
        self.contentView.addSubview(viewLabel)
        viewLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(14)
        }
        
        self.contentView.addSubview(viewImageView)
        viewImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(17)
            $0.trailing.equalTo(viewLabel.snp.leading).offset(-3)
            $0.width.height.equalTo(12)
        }
        
        self.contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.trailing.equalTo(viewImageView.snp.leading).offset(-12)
            $0.height.equalTo(14)
        }
        
        self.contentView.addSubview(commentImageView)
        commentImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(17)
            $0.trailing.equalTo(commentLabel.snp.leading).offset(-3)
            $0.width.height.equalTo(12)
        }
    }
    
    func prepare(favoriteBoard: FavoriteBoard) {
        self.labelLabel.text = favoriteBoard.menu
        self.labelLabel2.text = favoriteBoard.boardName
        self.titleLabel.text = favoriteBoard.title
        self.contentLabel.text = favoriteBoard.content
        self.commentLabel.text = String(favoriteBoard.commentCount)
        self.viewLabel.text = String(favoriteBoard.views)
    }
}

//
//  PostCommentTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 5/24/25.
//

import UIKit
import Then
import SnapKit

protocol CommentCellDelegate: AnyObject {
    func didTapMoreButton(cell: CommentListTableViewCell)
}

class CommentListTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: CommentListTableViewCell.self)
    
    weak var delegate: CommentCellDelegate?
    
    private let nameLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    }
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray400
    }
    private let degreeLabel = UILabel().then {
        $0.textColor = .orange700
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    private let optionButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_CommentMore"), for: .normal)
    }
    private let dateLabel = UILabel().then {
        $0.textColor = .gray500
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
    }
    private let contentLabel = UILabel().then {
        $0.textColor = .gray900
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let separatorView = UIView().then {
        $0.backgroundColor = .gray300
    }
    private let likeLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .gray300
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
    }
    private let likeButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Like"), for: .normal)
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
        self.contentView.backgroundColor = .white
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(17)
        }
        
        self.contentView.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(6)
            $0.height.equalTo(13)
            $0.width.equalTo(1)
        }
        
        self.contentView.addSubview(degreeLabel)
        degreeLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.leading.equalTo(dividerView.snp.trailing).offset(6)
            $0.height.equalTo(17)
        }
        
        self.contentView.addSubview(optionButton)
        optionButton.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(18)
            $0.height.width.equalTo(24)
        }
        optionButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        self.contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(12)
        }
        
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(36)
        }
        
        self.contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(1)
        }
        
        self.contentView.addSubview(likeLabel)
        likeLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(12)
        }
        
        self.contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints {
            $0.centerY.equalTo(likeLabel)
            $0.trailing.equalTo(likeLabel.snp.leading)
            $0.height.width.equalTo(20)
        }
    }
    
    @objc private func moreButtonTapped() {
        delegate?.didTapMoreButton(cell: self)
    }
    
    func prepare(comment: Comment, isLast: Bool) {
        nameLabel.text = comment.anonymousName
        degreeLabel.text = DegreeLevel.from(comment.degreeLevel)?.korean
        dateLabel.text = "\(comment.createdDate.prefix(10)) 작성"
        contentLabel.text = comment.content
        
        separatorView.isHidden = isLast
    }
}

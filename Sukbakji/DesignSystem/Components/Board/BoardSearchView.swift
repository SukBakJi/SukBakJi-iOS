//
//  BoardSearchView.swift
//  Sukbakji
//
//  Created by jaegu park on 6/2/25.
//

import UIKit
import FlexLayout
import PinLayout

class BoardSearchView: UIView {
    
    private let rootFlexContainer = UIView()
    
    let boardSearchTextField = UITextField()
    let searchImageView = UIImageView()
    let cancelButton = UIButton()
    let boardSearchTableView = UITableView()
    let searchImage = UIImageView()
    let searchLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        boardSearchTextField.backgroundColor = .gray50
        boardSearchTextField.placeholder = "제목과 내용을 자유롭게 검색해 보세요"
        boardSearchTextField.setPlaceholderColor(.gray300)
        boardSearchTextField.font = UIFont(name: "Pretendard-Medium", size: 14)
        boardSearchTextField.textColor = .gray900
        boardSearchTextField.layer.cornerRadius = 12
        boardSearchTextField.setLeftPadding(52)
        boardSearchTextField.errorfix()
        
        searchImageView.image = UIImage(named: "Sukbakji_SearchImage")
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.gray900, for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        
        searchImage.image = UIImage(named: "Sukbakji_MentorProgress")
        searchLabel.textColor = .gray900
        searchLabel.numberOfLines = 2
        searchLabel.textAlignment = .center
        searchLabel.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        
        boardSearchTableView.backgroundColor = .clear
        boardSearchTableView.separatorStyle = .none
        boardSearchTableView.register(BoardSearchTableViewCell.self, forCellReuseIdentifier: BoardSearchTableViewCell.identifier)
        boardSearchTableView.allowsSelection = false
        boardSearchTableView.isHidden = true
        
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.column).paddingTop(55).define { flex in
            flex.addItem().direction(.row).marginHorizontal(24).height(48).define { row in
                row.addItem().direction(.column).grow(1).height(48).define { inputContainer in
                    inputContainer.addItem(boardSearchTextField).width(100%).height(48)
                    inputContainer.addItem(searchImageView).position(.absolute).left(16).top(12).size(24)
                }
                row.addItem(cancelButton).width(60).alignSelf(.center)
            }
            flex.addItem(searchImage).width(32).height(32).alignSelf(.center).marginTop(140)
            flex.addItem(searchLabel).width(150).height(52).alignSelf(.center).marginTop(17)
        }
        
        addSubview(boardSearchTableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
        
        boardSearchTableView.pin
            .top(to: rootFlexContainer.edge.bottom).marginTop(8)
            .left()
            .right()
            .bottom()
    }
    
    func changeColor(_ boardName: String) {
        searchLabel.text = "\(boardName) 글을\n검색해 보세요"
        let fullText = searchLabel.text ?? ""
        let changeText = boardName
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        searchLabel.attributedText = attributedString
    }
}

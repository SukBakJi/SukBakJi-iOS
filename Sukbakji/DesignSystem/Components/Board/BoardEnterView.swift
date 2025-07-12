//
//  BoardEnterView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import FlexLayout
import PinLayout

class BoardEnterView: UIView {
    
    private let rootFlexContainer = UIView()
    
    let boardSearchTextField = UITextField()
    let tapOverlayButton = UIButton()
    let searchImageView = UIImageView()
    let enterMenuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EnterMenuCollectionViewCell.self, forCellWithReuseIdentifier: EnterMenuCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let titleLabel = UILabel()
    let enterPostTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        changeColor("질문 게시판")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        boardSearchTextField.backgroundColor = .gray50
        boardSearchTextField.placeholder = "게시판에서 궁금한 내용을 검색해 보세요!"
        boardSearchTextField.setPlaceholderColor(.gray300)
        boardSearchTextField.font = UIFont(name: "Pretendard-Medium", size: 14)
        boardSearchTextField.textColor = .gray900
        boardSearchTextField.layer.cornerRadius = 12
        boardSearchTextField.isUserInteractionEnabled = false
        boardSearchTextField.setLeftPadding(52)
        boardSearchTextField.errorfix()
        
        tapOverlayButton.backgroundColor = .clear
        tapOverlayButton.setTitle("", for: .normal)
        
        searchImageView.image = UIImage(named: "Sukbakji_SearchImage")
        
        titleLabel.textColor = .gray900
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        
        enterPostTableView.backgroundColor = .clear
        enterPostTableView.separatorStyle = .none
        enterPostTableView.register(EnterPostTableViewCell.self, forCellReuseIdentifier: EnterPostTableViewCell.identifier)
        enterPostTableView.allowsSelection = false
        
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.column).paddingTop(55).define { flex in
            flex.addItem().marginHorizontal(24).height(48).define { inputContainer in
                inputContainer.addItem(boardSearchTextField).width(100%).height(48)
                inputContainer.addItem(searchImageView).position(.absolute).left(16).top(12).size(24)
                inputContainer.addItem(tapOverlayButton).position(.absolute).top(0).left(0).right(0).bottom(0)
            }
            flex.addItem(enterMenuCollectionView).height(52).marginTop(0)
            flex.addItem(titleLabel).marginTop(4).marginHorizontal(24).height(52)
            flex.addItem(enterPostTableView).marginTop(12).grow(1)
        }
        
        tapOverlayButton.addTarget(self, action: #selector(textFieldTapped), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    func changeColor(_ boardName: String) {
        titleLabel.text = "\(boardName)에서\n이야기를 나눠 보세요"
        let fullText = titleLabel.text ?? ""
        let changeText = boardName
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        titleLabel.attributedText = attributedString
    }
    
    @objc private func textFieldTapped() {
        let nextVC = BoardSearchViewController(title: "입학 예정 게시판", menu: "진학예정")
        nextVC.modalPresentationStyle = .fullScreen
        parentVC?.present(nextVC, animated: true, completion: nil)
    }
}

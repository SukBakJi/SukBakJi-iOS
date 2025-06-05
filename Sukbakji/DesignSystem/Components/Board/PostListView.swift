//
//  PostListView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/14/25.
//

import UIKit
import FlexLayout
import PinLayout

class PostListView: UIView {
    
    private let rootFlexContainer = UIView()
    
    var optionNavigationbarView = OptionNavigationBarView(title: "", buttonHidden: true)
    var noticeButton = NoticeButton(title: "")
    let backgroundLabel = UILabel()
    let postListTableView = UITableView()
    let writingButton = UIButton()
    
    init(title: String, buttonTitle: String, buttonHidden: Bool) {
        super.init(frame: .zero)
        self.optionNavigationbarView = OptionNavigationBarView(title: title, buttonHidden: buttonHidden)
        self.noticeButton = NoticeButton(title: buttonTitle)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        backgroundLabel.backgroundColor = .gray100
        
        postListTableView.separatorStyle = .none
        postListTableView.backgroundColor = .clear
        postListTableView.register(PostListTableViewCell.self, forCellReuseIdentifier: PostListTableViewCell.identifier)
        postListTableView.allowsSelection = true
        
        writingButton.setImage(UIImage(named: "Sukbakji_Write"), for: .normal)
        
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.column).define { flex in
            flex.addItem(optionNavigationbarView).height(95)
            flex.addItem(backgroundLabel).height(1)
            flex.addItem(noticeButton).marginHorizontal(24).height(40).marginTop(16)
            flex.addItem(postListTableView).grow(1).marginTop(8)
        }
        
        addSubview(writingButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
        
        writingButton.pin
            .bottom(48)
            .right(24)
            .width(60)
            .height(60)
    }
}

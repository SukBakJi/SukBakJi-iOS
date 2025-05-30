//
//  MyPostView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/23/25.
//

import UIKit
import FlexLayout
import PinLayout

class MyPostView: UIView {
    
    private let rootFlexContainer = UIView()
    
    var navigationbarView = NavigationBarView(title: "")
    let backgroundLabel = UILabel()
    let myPostTableView = UITableView()
    
    init(title: String) {
        super.init(frame: .zero)
        self.navigationbarView = NavigationBarView(title: title)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        backgroundLabel.backgroundColor = .gray100
        
        myPostTableView.separatorStyle = .none
        myPostTableView.backgroundColor = .clear
        myPostTableView.register(MyPostTableViewCell.self, forCellReuseIdentifier: MyPostTableViewCell.identifier)
        myPostTableView.allowsSelection = true
        
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.column).define { flex in
            flex.addItem(navigationbarView).height(95)
            flex.addItem(backgroundLabel).height(1)
            flex.addItem(myPostTableView).grow(1).marginTop(8)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

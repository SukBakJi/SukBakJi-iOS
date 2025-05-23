//
//  BoardFreeViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import SnapKit

class BoardFreeViewController: UIViewController {
    
    private let boardFreeView = BoardFreeView()
    
    private var favBoardHeightConstraint: Constraint?
    
    override func loadView() {
        self.view = boardFreeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        boardFreeView.favBoardView.snp.makeConstraints { make in
            favBoardHeightConstraint = make.height.equalTo(121).constraint
        }
    }
}

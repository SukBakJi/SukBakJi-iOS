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
        boardFreeView.makeBoardButton.addTarget(self, action: #selector(create_Tapped), for: .touchUpInside)
        boardFreeView.writingButton.addTarget(self, action: #selector(writing_Tapped), for: .touchUpInside)
    }
    
    @objc private func create_Tapped() {
        let viewController = BoardCreateViewController()
        let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 520, bottomSheetPanMinTopConstant: 230, isPannedable: true)
        self.present(bottomSheetVC, animated: true)
    }
    
    @objc private func writing_Tapped() {
        let postWritingViewController = PostWritingViewController()
        self.navigationController?.pushViewController(postWritingViewController, animated: true)
    }
}

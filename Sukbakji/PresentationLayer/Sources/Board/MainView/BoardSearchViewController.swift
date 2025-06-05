//
//  BoardSearchViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 6/2/25.
//

import UIKit

class BoardSearchViewController: UIViewController {
    
    private let boardSearchView = BoardSearchView()
    private var menu: String = ""
    
    init(title: String, menu: String) {
        super.init(nibName: nil, bundle: nil)
        
        boardSearchView.changeColor(title)
        self.menu = menu
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = boardSearchView
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
        
        boardSearchView.cancelButton.addTarget(self, action: #selector(backButton_Tapped), for: .touchUpInside)
    }
    
    @objc private func backButton_Tapped() {
        dismiss(animated: true, completion: nil)
    }
}

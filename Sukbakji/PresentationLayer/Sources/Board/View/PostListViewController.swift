//
//  PostListViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/14/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PostListViewController: UIViewController {

    private let postListView = PostListView()
    private var disposeBag = DisposeBag()

    override func loadView() {
        self.view = postListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        postListView.optionNavigationbarView.delegate = self
    }
}

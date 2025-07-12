//
//  ReviewWritingViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/11/25.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewWritingViewController: UIViewController {
    
    private let reviewWritingView = ReviewWritingView()
    private let disposeBag = DisposeBag()
    var labId: Int = 0
    
    init(labId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.labId = labId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = reviewWritingView
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
        reviewWritingView.navigationbarView.delegate = self
    }
}

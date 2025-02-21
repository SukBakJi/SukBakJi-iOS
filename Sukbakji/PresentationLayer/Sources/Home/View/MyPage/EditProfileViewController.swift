//
//  EditProfileViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit
import SnapKit
import Alamofire
import Then
import RxSwift
import RxCocoa

class EditProfileViewController: UIViewController {
    
    private let navigationbarView = NavigationBarView(title: "프로필 수정")
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let classifyView = UIView().then {
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 탭 바 숨기기
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(900)
        }
        
        navigationbarView.delegate = self
        self.contentView.addSubview(navigationbarView)
        navigationbarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
           make.height.equalTo(95)
        }
        
        self.contentView.addSubview(classifyView)
        classifyView.snp.makeConstraints { make in
            make.top.equalTo(navigationbarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        let childVC = ProfileTabViewController()
        addChild(childVC)
        classifyView.addSubview(childVC.view)
        childVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        childVC.didMove(toParent: self)
    }
}

//
//  ChattingViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import UIKit
import SnapKit
import Alamofire
import Then
import RxSwift
import RxCocoa

class ChattingViewController: UIViewController {
    
    private let titleView = UIView().then {
        $0.backgroundColor = .white
    }
    private let titleLabel = UILabel().then {
        $0.text = "채팅"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 22)
    }
    private let notificationButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Notification"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    private let classifyView = UIView().then {
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(95)
        }
        
        self.titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(11)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(26)
        }
        
        self.titleView.addSubview(notificationButton)
        notificationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalTo(titleLabel)
            make.height.width.equalTo(48)
        }
        
        self.view.addSubview(classifyView)
        classifyView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        let childVC = ChattingTabViewController()
        addChild(childVC)
        classifyView.addSubview(childVC.view)
        childVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        childVC.didMove(toParent: self)
    }
}

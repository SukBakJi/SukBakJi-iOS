//
//  BoardViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/16/25.
//

import UIKit
import SnapKit
import Then

class BoardViewController: UIViewController {

    let titleView = UIView().then {
        $0.backgroundColor = .white
    }
    let titleLabel = UILabel().then {
        $0.text = "게시판"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 22)
        $0.textColor = .gray900
    }
    let notificationButton = UIButton().then {
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
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }

    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        self.titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(26)
        }
        
        self.titleView.addSubview(notificationButton)
        notificationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(titleLabel)
            $0.height.width.equalTo(48)
        }
        
        self.view.addSubview(classifyView)
        classifyView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(95)
            make.leading.trailing.bottom.equalToSuperview()
        }
        let childVC = BoardTabViewController()
        addChild(childVC)
        classifyView.addSubview(childVC.view)
        childVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        childVC.didMove(toParent: self)
        
        notificationButton.addTarget(self, action: #selector(notification_Tapped), for: .touchUpInside)
    }
    
    @objc private func notification_Tapped() {
        let notificationViewController = NotificationViewController()
        self.navigationController?.pushViewController(notificationViewController, animated: true)
    }
}

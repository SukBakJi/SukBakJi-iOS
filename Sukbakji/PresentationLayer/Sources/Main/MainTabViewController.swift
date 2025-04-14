//
//  MainTabViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/14/24.
//

import UIKit
import SwiftUI

class CustomTabBarItemView: UIView {

    let imageView = UIImageView()
    let titleLabel = UILabel()

    init(image: UIImage?, title: String) {
        super.init(frame: .zero)
        setupUI(image: image, title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(image: UIImage?, title: String) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .orange700

        titleLabel.text = title
        titleLabel.font = UIFont(name: "Pretendard-Regular", size: 11)
        titleLabel.textColor = .gray400
        titleLabel.textAlignment = .center

        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 35),
            imageView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    func setSelected(_ selected: Bool) {
        imageView.tintColor = selected ? .orange700 : .gray400
        titleLabel.textColor = selected ? .gray900 : .gray400
    }
}

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    let customTabBarView = UIView()
    
    private let items: [CustomTabBarItemView] = [
        CustomTabBarItemView(image: UIImage(named: "Sukbakji_Home")?.withRenderingMode(.alwaysTemplate), title: "홈"),
        CustomTabBarItemView(image: UIImage(named: "Sukbakji_Calendar")?.withRenderingMode(.alwaysTemplate), title: "캘린더"),
        CustomTabBarItemView(image: UIImage(named: "Sukbakji_Board")?.withRenderingMode(.alwaysTemplate), title: "게시판"),
        CustomTabBarItemView(image: UIImage(named: "Sukbakji_Chatting")?.withRenderingMode(.alwaysTemplate), title: "채팅"),
        CustomTabBarItemView(image: UIImage(named: "Sukbakji_Book")?.withRenderingMode(.alwaysTemplate), title: "디렉토리")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupCustomTabBar()
        selectedIndex = 0
        updateSelectedState(index: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupCustomTabBar() {
        tabBar.isHidden = true
        customTabBarView.backgroundColor = .white
        
        customTabBarView.layer.shadowColor = UIColor.black.cgColor
        customTabBarView.layer.shadowOpacity = 0.1
        customTabBarView.layer.shadowOffset = CGSize(width: 0, height: -4)
        customTabBarView.layer.shadowRadius = 8
        customTabBarView.layer.masksToBounds = false
        
        view.addSubview(customTabBarView)
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBarView.heightAnchor.constraint(equalToConstant: 92)
        ])
        
        let stackView = UIStackView(arrangedSubviews: items)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        customTabBarView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: customTabBarView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: customTabBarView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: customTabBarView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: customTabBarView.trailingAnchor)
        ])
        
        for (index, item) in items.enumerated() {
            item.tag = index
            item.isUserInteractionEnabled = true
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabItemTapped(_:))))
        }
    }
    
    @objc private func tabItemTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        
        // 4번째(인덱스 3) 탭은 알림만 표시
        if index == 3 {
            let alert = UIAlertController(title: nil, message: "서비스 준비 중입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        selectedIndex = index
        updateSelectedState(index: index)
    }
    
    private func updateSelectedState(index: Int) {
        for (i, item) in items.enumerated() {
            item.setSelected(i == index)
        }
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let calendarVC = CalendarViewController()
        let swiftUIBoardView = BoardViewController()
        let chattingVC = ChattingViewController()
        let swiftUIDirectoryView = DirectoryMainViewController()
        
        let boardVC = UIHostingController(rootView: swiftUIBoardView)
        boardVC.additionalSafeAreaInsets.bottom = 92
        let directoryVC = UIHostingController(rootView: swiftUIDirectoryView)
        directoryVC.additionalSafeAreaInsets.bottom = 92
        
        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationCalendar = UINavigationController(rootViewController: calendarVC)
        let navigationBoard = UINavigationController(rootViewController: boardVC)
        let navigationChatting = UINavigationController(rootViewController: chattingVC)
        let navigationDirectory = UINavigationController(rootViewController: directoryVC)

        self.viewControllers = [navigationHome, navigationCalendar, navigationBoard, navigationChatting, navigationDirectory]
    }
}

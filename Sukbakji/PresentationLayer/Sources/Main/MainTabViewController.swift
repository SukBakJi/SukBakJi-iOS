//
//  MainTabViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/14/24.
//

import UIKit
import SwiftUI

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {

    let homeVC = HomeViewController()
    let calendarVC = CalendarViewController()
    let swiftUIBoardView = BoardViewController()
    let chattingVC = ChattingViewController()
    let swiftUIDirectoryView = DirectoryMainViewController()
    
    let customTabBar = CustomTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setup() {
        self.delegate = self
        self.setValue(customTabBar, forKey: "tabBar")

        tabBar.backgroundColor = .white
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)

        let boardVC = UIHostingController(rootView: swiftUIBoardView)
        let directoryVC = UIHostingController(rootView: swiftUIDirectoryView)
        
        homeVC.title = "홈"
        calendarVC.title = "캘린더"
        boardVC.title = "게시판"
        chattingVC.title = "채팅"
        directoryVC.title = "디렉토리"
        
        homeVC.navigationItem.title = ""
        calendarVC.navigationItem.title = ""
        boardVC.navigationItem.title = ""
        chattingVC.navigationItem.title = ""
        directoryVC.navigationItem.title = ""
        
        let homeImage = UIImage(named: "Sukbakji_Home")?.withRenderingMode(.alwaysOriginal)
        let calendarImage = UIImage(named: "Sukbakji_Calendar")?.withRenderingMode(.alwaysOriginal)
        let boardImage = UIImage(named: "Sukbakji_Board")?.withRenderingMode(.alwaysOriginal)
        let chatImage = UIImage(named: "Sukbakji_Chatting")?.withRenderingMode(.alwaysOriginal)
        let directoryImage = UIImage(named: "Sukbakji_Book")?.withRenderingMode(.alwaysOriginal)
        
        let resizedHomeImage = UIGraphicsImageRenderer(size: CGSize(width: 32, height: 32)).image { _ in
            homeImage?.draw(in: CGRect(origin: .zero, size: CGSize(width: 32, height: 32)))
        }
        let resizedCalendarImage = UIGraphicsImageRenderer(size: CGSize(width: 32, height: 32)).image { _ in
            calendarImage?.draw(in: CGRect(origin: .zero, size: CGSize(width: 32, height: 32)))
        }
        let resizedBoardImage = UIGraphicsImageRenderer(size: CGSize(width: 32, height: 32)).image { _ in
            boardImage?.draw(in: CGRect(origin: .zero, size: CGSize(width: 32, height: 32)))
        }
        let resizedChatImage = UIGraphicsImageRenderer(size: CGSize(width: 32, height: 32)).image { _ in
            chatImage?.draw(in: CGRect(origin: .zero, size: CGSize(width: 32, height: 32)))
        }
        let resizedDirectoryImage = UIGraphicsImageRenderer(size: CGSize(width: 32, height: 32)).image { _ in
            directoryImage?.draw(in: CGRect(origin: .zero, size: CGSize(width: 32, height: 32)))
        }
        
        homeVC.tabBarItem.image = resizedHomeImage
        homeVC.tabBarItem.selectedImage = resizedHomeImage
        calendarVC.tabBarItem.image = resizedCalendarImage
        calendarVC.tabBarItem.selectedImage = resizedCalendarImage
        boardVC.tabBarItem.image = resizedBoardImage
        boardVC.tabBarItem.selectedImage = resizedBoardImage
        chattingVC.tabBarItem.image = resizedChatImage
        chattingVC.tabBarItem.selectedImage = resizedChatImage
        directoryVC.tabBarItem.image = resizedDirectoryImage
        directoryVC.tabBarItem.selectedImage = resizedDirectoryImage
        
        homeVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray900], for: .normal)
        homeVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray900], for: .selected)
        homeVC.tabBarItem.image = resizedHomeImage.withTintColor(.gray400, renderingMode: .alwaysOriginal)
        homeVC.tabBarItem.selectedImage = resizedHomeImage.withTintColor(UIColor.orange700, renderingMode: .alwaysOriginal)
        
        calendarVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray900], for: .normal)
        calendarVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray900], for: .selected)
        calendarVC.tabBarItem.image = resizedCalendarImage.withTintColor(.gray400, renderingMode: .alwaysOriginal)
        calendarVC.tabBarItem.selectedImage = resizedCalendarImage.withTintColor(UIColor.orange700, renderingMode: .alwaysOriginal)
        
        boardVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray900], for: .normal)
        boardVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray900], for: .selected)
        boardVC.tabBarItem.image = resizedBoardImage.withTintColor(.gray400, renderingMode: .alwaysOriginal)
        boardVC.tabBarItem.selectedImage = resizedBoardImage.withTintColor(UIColor.orange700, renderingMode: .alwaysOriginal)
        
        chattingVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray900], for: .normal)
        chattingVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray900], for: .selected)
        chattingVC.tabBarItem.image = resizedChatImage.withTintColor(.gray400, renderingMode: .alwaysOriginal)
        chattingVC.tabBarItem.selectedImage = resizedChatImage.withTintColor(UIColor.orange700, renderingMode: .alwaysOriginal)
        
        directoryVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray900], for: .normal)
        directoryVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray900], for: .selected)
        directoryVC.tabBarItem.image = resizedDirectoryImage.withTintColor(.gray400, renderingMode: .alwaysOriginal)
        directoryVC.tabBarItem.selectedImage = resizedDirectoryImage.withTintColor(UIColor.orange700, renderingMode: .alwaysOriginal)
        
        homeVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        calendarVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        boardVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        chattingVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        directoryVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -10, right: 0)
        calendarVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -10, right: 0)
        boardVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -10, right: 0)
        chattingVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -10, right: 0)
        directoryVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -10, right: 0)
        
        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationCalendar = UINavigationController(rootViewController: calendarVC)
        let navigationBoard = UINavigationController(rootViewController: boardVC)
        let navigationChatting = UINavigationController(rootViewController: chattingVC)
        let navigationDirectory = UINavigationController(rootViewController: directoryVC)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationHome.navigationBar.standardAppearance = appearance
        navigationHome.navigationBar.scrollEdgeAppearance = appearance
        
        navigationCalendar.navigationBar.standardAppearance = appearance
        navigationCalendar.navigationBar.scrollEdgeAppearance = appearance
        
        navigationBoard.navigationBar.standardAppearance = appearance
        navigationBoard.navigationBar.scrollEdgeAppearance = appearance
        
        navigationChatting.navigationBar.standardAppearance = appearance
        navigationChatting.navigationBar.scrollEdgeAppearance = appearance
        
        navigationDirectory.navigationBar.standardAppearance = appearance
        navigationDirectory.navigationBar.scrollEdgeAppearance = appearance
        
        setViewControllers([navigationHome, navigationCalendar, navigationBoard, navigationChatting, navigationDirectory], animated: false)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let viewControllers = tabBarController.viewControllers,
              let index = viewControllers.firstIndex(of: viewController) else {
            return true
        }
        
        if index == 3 {
            let alert = UIAlertController(title: nil, message: "준비 중인 서비스입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            tabBarController.present(alert, animated: true)

            return false
        }
    
        return true
    }
}

class CustomTabBar: UITabBar {
    private var customHeight: CGFloat = 90 // 원하는 높이 설정
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = customHeight
        return sizeThatFits
    }
}

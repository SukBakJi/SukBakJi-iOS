//
//  MainTabViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/14/24.
//

import UIKit
import SwiftUI

class MainTabViewController: UITabBarController {

    let homeVC = HomeViewController()
    let calendarVC = CalendarViewController()
    let swiftUIBoardView = BoardViewController()
    let Chattingstoryboard = UIStoryboard(name: "Chatting", bundle: nil)
    let swiftUIDirectoryView = DirectoryMainViewController()
    
    let customTabBar = CustomTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.setValue(customTabBar, forKey: "tabBar")
        
//        tabBar.tintColor = UIColor(named: "Coquelicot")
//        tabBar.unselectedItemTintColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0)
        tabBar.backgroundColor = .white
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)

        let boardVC = UIHostingController(rootView: swiftUIBoardView)
        let chatVC = Chattingstoryboard.instantiateViewController(withIdentifier: "ChattingVC")
        let directoryVC = UIHostingController(rootView: swiftUIDirectoryView)
        
        homeVC.title = "홈"
        calendarVC.title = "캘린더"
        boardVC.title = "게시판"
        chatVC.title = "채팅"
        directoryVC.title = "디렉토리"
        
        homeVC.navigationItem.title = ""
        calendarVC.navigationItem.title = ""
        boardVC.navigationItem.title = ""
        chatVC.navigationItem.title = ""
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
        chatVC.tabBarItem.image = resizedChatImage
        chatVC.tabBarItem.selectedImage = resizedChatImage
        directoryVC.tabBarItem.image = resizedDirectoryImage
        directoryVC.tabBarItem.selectedImage = resizedDirectoryImage
        
        homeVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray300], for: .normal)
        homeVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor(named: "Coquelicot")!], for: .selected)
        homeVC.tabBarItem.image = resizedHomeImage.withTintColor(.gray300, renderingMode: .alwaysOriginal)
        homeVC.tabBarItem.selectedImage = resizedHomeImage.withTintColor(UIColor(named: "Coquelicot")!, renderingMode: .alwaysOriginal)
        
        calendarVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray300], for: .normal)
        calendarVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor(named: "Coquelicot")!], for: .selected)
        calendarVC.tabBarItem.image = resizedCalendarImage.withTintColor(.gray300, renderingMode: .alwaysOriginal)
        calendarVC.tabBarItem.selectedImage = resizedCalendarImage.withTintColor(UIColor(named: "Coquelicot")!, renderingMode: .alwaysOriginal)
        
        boardVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray300], for: .normal)
        boardVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor(named: "Coquelicot")!], for: .selected)
        boardVC.tabBarItem.image = resizedBoardImage.withTintColor(.gray300, renderingMode: .alwaysOriginal)
        boardVC.tabBarItem.selectedImage = resizedBoardImage.withTintColor(UIColor(named: "Coquelicot")!, renderingMode: .alwaysOriginal)
        
        chatVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray300], for: .normal)
        chatVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor(named: "Coquelicot")!], for: .selected)
        chatVC.tabBarItem.image = resizedChatImage.withTintColor(.gray300, renderingMode: .alwaysOriginal)
        chatVC.tabBarItem.selectedImage = resizedChatImage.withTintColor(UIColor(named: "Coquelicot")!, renderingMode: .alwaysOriginal)
        
        directoryVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.gray300], for: .normal)
        directoryVC.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor(named: "Coquelicot")!], for: .selected)
        directoryVC.tabBarItem.image = resizedDirectoryImage.withTintColor(.gray300, renderingMode: .alwaysOriginal)
        directoryVC.tabBarItem.selectedImage = resizedDirectoryImage.withTintColor(UIColor(named: "Coquelicot")!, renderingMode: .alwaysOriginal)
        
        homeVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        calendarVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        boardVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        chatVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        directoryVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -10, right: 0)
        calendarVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -10, right: 0)
        boardVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -10, right: 0)
        chatVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -10, right: 0)
        directoryVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -10, right: 0)
        
        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationCalendar = UINavigationController(rootViewController: calendarVC)
        let navigationBoard = UINavigationController(rootViewController: boardVC)
        let navigationChat = UINavigationController(rootViewController: chatVC)
        let navigationDirectory = UINavigationController(rootViewController: directoryVC)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationHome.navigationBar.standardAppearance = appearance
        navigationHome.navigationBar.scrollEdgeAppearance = appearance
        
        navigationCalendar.navigationBar.standardAppearance = appearance
        navigationCalendar.navigationBar.scrollEdgeAppearance = appearance
        
        navigationBoard.navigationBar.standardAppearance = appearance
        navigationBoard.navigationBar.scrollEdgeAppearance = appearance
        
        navigationChat.navigationBar.standardAppearance = appearance
        navigationChat.navigationBar.scrollEdgeAppearance = appearance
        
        navigationDirectory.navigationBar.standardAppearance = appearance
        navigationDirectory.navigationBar.scrollEdgeAppearance = appearance
        
        setViewControllers([navigationHome, navigationCalendar, navigationBoard, navigationChat, navigationDirectory], animated: false)
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

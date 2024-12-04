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
    let Calendarstoryboard = UIStoryboard(name: "Calendar", bundle: nil)
    let swiftUIBoardView = BoardViewController()
    let Chattingstoryboard = UIStoryboard(name: "Chatting", bundle: nil)
    let swiftUIDirectoryView = DirectoryMainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        changeHeightOfTabbar()
    }
    
    func setup() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        tabBar.tintColor = UIColor(named: "Coquelicot")
        tabBar.unselectedItemTintColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0)
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = false
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
        
        let calendarVC = Calendarstoryboard.instantiateViewController(withIdentifier: "CalendarVC")
        let boardVC = UIHostingController(rootView: swiftUIBoardView)
        let chatVC = Chattingstoryboard.instantiateViewController(withIdentifier: "ChattingVC")
        let directoryVC = UIHostingController(rootView: swiftUIDirectoryView)
        
        homeVC.title = "홈"
        calendarVC.title = "캘린더"
        boardVC.title = "게시판"
        chatVC.title = "채팅"
        directoryVC.title = "디렉토리"
        
        let homeImage = UIImage(named: "Sukbakji_Home")
        let calendarImage = UIImage(named: "Sukbakji_Calendar")
        let boardImage = UIImage(named: "Sukbakji_Board")
        let chatImage = UIImage(named: "Sukbakji_Chatting")
        let directoryImage = UIImage(named: "Sukbakji_Book")
        
        homeVC.tabBarItem.image = homeImage
        homeVC.tabBarItem.selectedImage = homeImage
        calendarVC.tabBarItem.image = calendarImage
        calendarVC.tabBarItem.selectedImage = calendarImage
        boardVC.tabBarItem.image = boardImage
        boardVC.tabBarItem.selectedImage = boardImage
        chatVC.tabBarItem.image = chatImage
        chatVC.tabBarItem.selectedImage = chatImage
        directoryVC.tabBarItem.image = directoryImage
        directoryVC.tabBarItem.selectedImage = directoryImage
        
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -2, right: 0)
        calendarVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -2, right: 0)
        boardVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -2, right: 0)
        chatVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -2, right: 0)
        directoryVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -2, right: 0)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationCalendar = UINavigationController(rootViewController: calendarVC)
        let navigationBoard = UINavigationController(rootViewController: boardVC)
        let navigationChat = UINavigationController(rootViewController: chatVC)
        let navigationDirectory = UINavigationController(rootViewController: directoryVC)
        
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
    
    func changeHeightOfTabbar() {
        if UIDevice().userInterfaceIdiom == .phone {
            var tabFrame = tabBar.frame
            tabFrame.size.height = 95
            tabFrame.origin.y = view.frame.size.height - 90
            tabBar.frame = tabFrame
        }
    }
}

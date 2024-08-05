//
//  MainTabViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/14/24.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor(named: "Coquelicot")
        tabBar.unselectedItemTintColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0)
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = false
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .clear
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.setupStyle()
    }
    
    override func viewDidLayoutSubviews() {
        self.changeHeightOfTabbar()
    }
    
    func setupStyle() {
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
    
    func changeHeightOfTabbar() {
        if UIDevice().userInterfaceIdiom == .phone {
            var tabFrame = tabBar.frame
            tabFrame.size.height = 95
            tabFrame.origin.y = view.frame.size.height - 80
            tabBar.frame = tabFrame
        }
    }
}

//
//  BoardTabViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/16/25.
//

import UIKit
import Tabman
import Pageboy
import Then
import SnapKit

class BoardTabViewController: TabmanViewController {
    
    private var viewControllers: Array<UIViewController> = []
    
    private let tabView = UIView().then {
        $0.backgroundColor = .white
    }
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setupTabMan()
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
        
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(40)
        }
        
        self.tabView.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1.5)
        }
    }
    
    private func setupTabMan() {
        let vc1 = BoardMainViewController()
        let vc2 = BoardDoctorViewController()
        let vc3 = BoardMasterViewController()
        let vc4 = BoardEnterViewController()
        let vc5 = BoardFreeViewController()
        
        viewControllers.append(vc1)
        viewControllers.append(vc2)
        viewControllers.append(vc3)
        viewControllers.append(vc4)
        viewControllers.append(vc5)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        bar.buttons.customize { (button) in
            button.tintColor = .gray600
            button.selectedTintColor = .orange700
            button.font = UIFont(name: "Pretendard-SemiBold", size: 16)!
            button.selectedFont = UIFont(name: "Pretendard-SemiBold", size: 16)!
        }

        bar.layout.contentMode = .intrinsic
        
        bar.indicator.weight = .custom(value: 2.5)
        bar.indicator.tintColor = .orange700
        addBar(bar, dataSource: self, at: .custom(view: tabView, layout: nil))
    }
}

extension BoardTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "메인    ")
        case 1:
            return TMBarItem(title: "박사    ")
        case 2:
            return TMBarItem(title: "석사    ")
        case 3:
            return TMBarItem(title: "입학 예정    ")
        case 4:
            return TMBarItem(title: "자유    ")
        default:
            let title = "Page \(index)"
           return TMBarItem(title: title)
        }
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

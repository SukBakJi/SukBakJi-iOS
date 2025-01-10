//
//  ChattingTabViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import UIKit
import Tabman
import Pageboy
import Then
import SnapKit

class ChattingTabViewController: TabmanViewController {
    
    private var viewControllers: Array<UIViewController> = []
    
    private let tabView = UIView().then {
       $0.backgroundColor = .white
    }
    private let backgroundLabel = UILabel().then {
       $0.backgroundColor = .gray200
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setupTabMan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
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
    
    private func setupTabMan(){
        let vc1 = MessageViewController()
        let vc2 = MentoringViewController()
        
        viewControllers.append(vc1)
        viewControllers.append(vc2)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        // 배경 회색으로 나옴 -> 하얀색으로 바뀜
        bar.backgroundView.style = .clear
        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        // 버튼 글씨 커스텀
        bar.buttons.customize { (button) in
            button.tintColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1)
            button.selectedTintColor = UIColor(named: "Coquelicot")
            button.font = UIFont(name: "Pretendard-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
            button.selectedFont = UIFont(name: "Pretendard-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        }

        bar.layout.contentMode = .intrinsic
        
        // 밑줄 쳐지는 부분
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = UIColor(named: "Coquelicot")
        addBar(bar, dataSource: self, at: .custom(view: tabView, layout: nil))
    }
}

extension ChattingTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "메세지    ")
        case 1:
            return TMBarItem(title: "멘토링    ")
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

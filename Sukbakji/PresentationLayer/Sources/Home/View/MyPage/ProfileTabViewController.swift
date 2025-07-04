//
//  ProfileTabViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit
import Tabman
import Pageboy
import Then
import SnapKit
import RxSwift

class ProfileTabViewController: TabmanViewController {
    
    private let viewModel = MyProfileViewModel()
    private let disposeBag = DisposeBag()
    
    private var provider: String = ""
    private var userPW: String = ""
    
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
        setAPI()
        getUserPW()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissNotification(_:)), name: NSNotification.Name("CannotChangePW"),
            object: nil)
        
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
        let vc1 = EditInfoViewController()
        let vc2 = EditPWViewController()
        
        viewControllers.append(vc1)
        viewControllers.append(vc2)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        bar.buttons.customize { (button) in
            button.tintColor = .gray600
            button.selectedTintColor = .orange700
            button.font = UIFont(name: "Pretendard-Medium", size: 16)!
            button.selectedFont = UIFont(name: "Pretendard-SemiBold", size: 16)!
        }

        bar.layout.contentMode = .intrinsic
        
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = .orange700
        addBar(bar, dataSource: self, at: .custom(view: tabView, layout: nil))
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: NavigationDirection, animated: Bool) {
        if (index == 1) && (userPW == "") { // 두 번째 탭이 선택된 경우
            var moveStopView = PWAlertView(title: "")
            if provider == "KAKAO" {
                moveStopView = PWAlertView(title: "카카오 로그인을 이용한 경우 앱 내 비밀번호 변경이 불가합니다")
            } else if provider == "APPLE" {
                moveStopView = PWAlertView(title: "Apple 로그인을 이용한 경우 앱 내 비밀번호 변경이 불가합니다")
            }
                
            self.view.addSubview(moveStopView)
            moveStopView.alpha = 0
            moveStopView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
                
            UIView.animate(withDuration: 0.3) {
                moveStopView.alpha = 1
            }
        }
    }
}
    
extension ProfileTabViewController {
    
    private func getUserPW() {
        if let retrievedPW = KeychainHelper.standard.read(service: "password", account: "user") {
            userPW = retrievedPW
            print(userPW)
        } else {
            print("Failed to retrieve password.")
        }
    }
    
    private func setAPI() {
        setProfileAPI()
        viewModel.loadMyProfile()
    }
    
    private func setProfileAPI() {
        viewModel.myProfile
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] profile in
                self?.provider = profile.provider
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func didDismissNotification(_ notification: Notification) {
        self.scrollToPage(.at(index: 0), animated: true)
    }
}

extension ProfileTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "회원정보 수정    ")
        case 1:
            return TMBarItem(title: "비밀번호 변경    ")
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

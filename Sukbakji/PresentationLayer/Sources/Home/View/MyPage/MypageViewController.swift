//
//  MypageViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MypageViewController: UIViewController {
    
    private let mypageView = MyPageView()
    private let viewModel = MyProfileViewModel()
    private var disposeBag = DisposeBag()
    
    private var myInfoViewheightConstraint: Constraint?
    
    override func loadView() {
        self.view = mypageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
}
    
extension MypageViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        mypageView.navigationbarView.delegate = self
        mypageView.myInfoEditButton.addTarget(self, action: #selector(edit_Tapped), for: .touchUpInside)
        mypageView.resignButton.addTarget(self, action: #selector(resign_Tapped), for: .touchUpInside)
        mypageView.myInfoView.snp.makeConstraints { make in
            myInfoViewheightConstraint = make.height.equalTo(180).constraint
        }
    }
    
    private func setAPI() {
        bindViewModel()
        viewModel.loadMyProfile()
    }
    
    private func bindViewModel() {
        mypageView.logOutButton.rx.tap
            .bind { [weak self] in
                self?.showLogoutAlert()
            }
            .disposed(by: disposeBag)
        
        viewModel.logoutResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isSuccess in
                if isSuccess {
                    self?.navigateToLogin()
                } else {
                    AlertController(message: "로그아웃에 실패했습니다. 다시 시도해주세요.").show()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.myProfile
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] profile in
                self?.mypageView.nameLabel.text = profile.name
                self?.mypageView.degreeLabel.text = DegreeLevel.from(profile.degreeLevel)?.korean ?? "학위 정보 없음"
                if self?.mypageView.degreeLabel.text == "학위 정보 없음" {
                    self?.myInfoViewheightConstraint?.update(offset: 198)
                    self?.mypageView.warningImageView.isHidden = false
                    self?.mypageView.warningLabel.isHidden = false
                    self?.mypageView.certificateLabel.text = "아직 학적 인증이 완료되지 않은 상태입니다"
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    private func showLogoutAlert() {
        AlertController(message: "로그아웃 하시겠어요?", isCancel: true) { [weak self] in
            self?.viewModel.loadLogOut()  // ✅ 로그아웃 API 호출
        }.show()
    }
    
    private func navigateToLogin() {
        //  자동 로그인 OFF
        UserDefaults.standard.set(false, forKey: "isAutoLogin")
        
        let loginVC = UINavigationController(rootViewController: LoginViewController())
        SceneDelegate().setRootViewController(loginVC)
    }
    
    @objc private func edit_Tapped() {
        let editProfileViewController = EditProfileViewController()
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    
    @objc private func resign_Tapped() {
        let alert = UIAlertController(title: nil, message: "준비 중인 서비스입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
}

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
        print(UserDefaults.standard.integer(forKey: "memberID"))
//        setAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}
    
extension MypageViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        mypageView.navigationbarView.delegate = self
        mypageView.myInfoEditButton.addTarget(self, action: #selector(edit_Tapped), for: .touchUpInside)
        mypageView.myInfoView.snp.makeConstraints { make in
            myInfoViewheightConstraint = make.height.equalTo(180).constraint
        }
    }
    
    private func setAPI() {
        bindViewModel()
        viewModel.loadMyProfile()
    }
    
    private func bindViewModel() {
        // 로그아웃 버튼 클릭 이벤트 처리
        mypageView.logOutButton.rx.tap
            .bind { [weak self] in
                self?.showLogoutAlert()
            }
            .disposed(by: disposeBag)
        
        // 로그아웃 결과 처리
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
        
        // 데이터 변경 시 UI 자동 업데이트
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
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let pointNumber = String(numberFormatter.string(from: NSNumber(value: profile.point ?? 0)) ?? "")
                self?.mypageView.pointLabel.text = pointNumber
            })
            .disposed(by: disposeBag)
        
        // 에러 메시지 바인딩
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    // 로그아웃 확인 Alert 띄우기
    private func showLogoutAlert() {
        AlertController(message: "로그아웃 하시겠어요?", isCancel: true) { [weak self] in
            self?.viewModel.loadLogOut()  // ✅ 로그아웃 API 호출
        }.show()
    }
    
    // 로그인 화면으로 이동
    private func navigateToLogin() {
        let loginVC = UINavigationController(rootViewController: LoginViewController())
        SceneDelegate().setRootViewController(loginVC)
    }
    
    @objc private func edit_Tapped() {
        let editProfileViewController = EditProfileViewController()
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
}

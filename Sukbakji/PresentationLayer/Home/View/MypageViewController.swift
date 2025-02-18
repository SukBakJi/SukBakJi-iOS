//
//  MypageViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit
import SnapKit
import Alamofire
import Then
import RxSwift
import RxCocoa

class MypageViewController: UIViewController {
    
    private let navigationbarView = NavigationBarView(title: "마이페이지")
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    private let myInfoView = UIView().then {
        $0.backgroundColor = .white
    }
    private let myInfoLabel = UILabel().then {
        $0.text = "내 정보"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let myInfoImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Myinfo")
    }
    private let myInfoEditButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_More"), for: .normal)
        $0.setTitle("수정하기 ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setTitleColor(.gray500, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    private let nameLabel = UILabel().then {
        $0.text = "석박지"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let degreeLabel = UILabel().then {
        $0.text = "학위 정보 없음"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.textColor = .gray900
    }
    private let certificateView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = false
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    private let certificateImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Pick")
    }
    private let certificateLabel = UILabel().then {
        $0.text = "현재 학적 인증이 완료된 상태입니다"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    private let warningImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    private let warningLabel = UILabel().then {
        $0.text = "학적 인증 후에 앱 기능 사용이 가능합니다."
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .orange700
    }
    private let pointView = UIView().then {
        $0.backgroundColor = .gray50
    }
    private let pointLabel = UILabel().then {
        $0.text = "내 포인트"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let pointImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Point")
    }
    private let myPointLabel = UILabel().then {
        $0.text = "현재 모인 포인트"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.textColor = .gray600
    }
    private let pointNumberLabel = UILabel().then {
        $0.text = "1,000"
        $0.font = UIFont(name: "Pretendard-Bold", size: 26)
        $0.textColor = .orange700
    }
    private let pLabel = UILabel().then {
        $0.text = "P"
        $0.font = UIFont(name: "Pretendard-Bold", size: 26)
        $0.textColor = .gray900
    }
    private let chargeButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("충전하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(.orange700, for: .normal)
    }
    private let logOutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.gray500, for: .normal)
    }
    private let resignButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.gray500, for: .normal)
    }
    
    private var disposeBag = DisposeBag()
    private var reactor = HomeReactor()
    
    private var myInfoViewheightConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 탭 바 숨기기
        self.tabBarController?.tabBar.isHidden = true
        //        setMyProfile()
    }
}
    
extension MypageViewController {
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationbarView.delegate = self
        self.view.addSubview(navigationbarView)
        navigationbarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(95)
        }
        
        self.view.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationbarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.view.addSubview(myInfoView)
        myInfoView.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            myInfoViewheightConstraint = make.height.equalTo(180).constraint
        }
        
        self.myInfoView.addSubview(myInfoLabel)
        myInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.myInfoView.addSubview(myInfoImageView)
        myInfoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(myInfoLabel)
            make.leading.equalTo(myInfoLabel.snp.trailing).offset(4)
            make.height.width.equalTo(20)
        }
        
        self.myInfoView.addSubview(myInfoEditButton)
        myInfoEditButton.snp.makeConstraints { make in
            make.centerY.equalTo(myInfoLabel)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(21)
            make.width.equalTo(64)
        }
        myInfoEditButton.addTarget(self, action: #selector(edit_Tapped), for: .touchUpInside)
        
        self.myInfoView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(myInfoLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.myInfoView.addSubview(degreeLabel)
        degreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
            make.height.equalTo(19)
        }
        
        self.myInfoView.addSubview(certificateView)
        certificateView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        self.certificateView.addSubview(certificateImageView)
        certificateImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(20)
        }
        
        self.certificateView.addSubview(certificateLabel)
        certificateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(certificateImageView)
            make.leading.equalTo(certificateImageView.snp.trailing).offset(8)
            make.height.equalTo(19)
        }
        let fullText = certificateLabel.text ?? ""
        let changeText = "완료된 상태"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        certificateLabel.attributedText = attributedString
        
        self.myInfoView.addSubview(warningImageView)
        warningImageView.snp.makeConstraints { make in
            make.top.equalTo(certificateView.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(28)
            make.width.height.equalTo(12)
        }
        warningImageView.isHidden = true
        
        self.myInfoView.addSubview(warningLabel)
        warningLabel.snp.makeConstraints { make in
            make.centerY.equalTo(warningImageView)
            make.leading.equalTo(warningImageView.snp.trailing).offset(4)
            make.height.equalTo(12)
        }
        warningLabel.isHidden = true
        
        self.view.addSubview(pointView)
        pointView.snp.makeConstraints { make in
            make.top.equalTo(myInfoView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(164)
        }
        
        self.pointView.addSubview(pointLabel)
        pointLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.pointView.addSubview(pointImageView)
        pointImageView.snp.makeConstraints { make in
            make.centerY.equalTo(pointLabel)
            make.leading.equalTo(pointLabel.snp.trailing).offset(4)
            make.height.width.equalTo(20)
        }
        
        self.pointView.addSubview(myPointLabel)
        myPointLabel.snp.makeConstraints { make in
            make.top.equalTo(pointLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(19)
        }
        
        self.pointView.addSubview(pointNumberLabel)
        pointNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(myPointLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(40)
        }
        
        self.pointView.addSubview(pLabel)
        pLabel.snp.makeConstraints { make in
            make.centerY.equalTo(pointNumberLabel)
            make.leading.equalTo(pointNumberLabel.snp.trailing).offset(5)
            make.height.equalTo(40)
        }
        
        self.pointView.addSubview(chargeButton)
        chargeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(92)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.width.equalTo(120)
        }
        
        self.view.addSubview(resignButton)
        resignButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(80)
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(48)
            make.width.equalTo(72)
        }
        
        self.view.addSubview(logOutButton)
        logOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(resignButton.snp.top)
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(48)
            make.width.equalTo(72)
        }
        logOutButton.addTarget(self, action: #selector(logOutAPI), for: .touchUpInside)
    }
}

extension MypageViewController {
    
    private func setMyProfile() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.userMypage.path
        
        APIService.shared.getWithToken(of: APIResponse<MyProfile>.self, url: url, accessToken: retrievedToken)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.nameLabel.text = response.result.name
                self.degreeLabel.text = DegreeLevel.from(response.result.degreeLevel)?.korean ?? "학위 정보 없음"
                if self.degreeLabel.text == "학위 정보 없음" {
                    self.myInfoViewheightConstraint?.update(offset: 198)
                    self.warningImageView.isHidden = false
                    self.warningLabel.isHidden = false
                    self.certificateLabel.text = "아직 학적 인증이 완료되지 않은 상태입니다"
                }
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let pointNumber = String(numberFormatter.string(from: NSNumber(value: response.result.point ?? 0)) ?? "")
                self.pointLabel.text = pointNumber
                self.view.layoutIfNeeded()
            }, onFailure: { error in
                print("❌ 오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func logOutAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.authLogout.path
        
        APIService.shared.postWithToken(of: APIResponse<String>.self, url: url, parameters: nil, accessToken: retrievedToken)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                AlertController(message: "로그아웃 하시겠어요?", isCancel: true) {
                    let LoginVC = UINavigationController(rootViewController: LoginViewController())
                    SceneDelegate().setRootViewController(LoginVC)
                    self.navigationController?.popToRootViewController(animated: true)
                }.show()
            }, onFailure: { error in
                print("❌ 오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func edit_Tapped() {
        let editProfileViewController = EditProfileViewController()
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
}

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
        $0.backgroundColor = .gray200
    }
    private let myInfoLabel = UILabel().then {
        $0.text = "내 정보"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let myInfoImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Myinfo")
    }
    private let myInfoEditButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_More"), for: .normal)
        $0.setTitle("수정하기 ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setTitleColor(.gray400, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    private let nameLabel = UILabel().then {
        $0.text = "석박지"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let degreeLabel = UILabel().then {
        $0.text = "학사 재학 중"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.textColor = .black
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
        $0.textColor = .black
    }
    private let warningImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    private let warningLabel = UILabel().then {
        $0.text = "학적 인증 후에 앱 기능 사용이 가능합니다."
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = UIColor(named: "Coquelicot")
    }
    private let pointView = UIView().then {
        $0.backgroundColor = .gray50
    }
    private let pointLabel = UILabel().then {
        $0.text = "내 포인트"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let pointImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Point")
    }
    private let myPointLabel = UILabel().then {
        $0.text = "현재 모인 포인트"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.textColor = .gray500
    }
    private let pointNumberLabel = UILabel().then {
        $0.text = "1,000"
        $0.font = UIFont(name: "Pretendard-Bold", size: 26)
        $0.textColor = UIColor(named: "Coquelicot")
    }
    private let pLabel = UILabel().then {
        $0.text = "P"
        $0.font = UIFont(name: "Pretendard-Bold", size: 26)
        $0.textColor = .black
    }
    private let chargeButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8

        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("충전하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(UIColor(named: "Coquelicot")!, for: .normal)
    }
    private let logOutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.gray400, for: .normal)
    }
    private let resignButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.gray400, for: .normal)
    }

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
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationbarView.delegate = self
        self.view.addSubview(navigationbarView)
        navigationbarView.snp.makeConstraints { make in
           make.top.equalToSuperview().inset(47)
           make.leading.trailing.equalToSuperview()
           make.height.equalTo(48)
        }
        
        self.view.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationbarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.view.addSubview(myInfoLabel)
        myInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.view.addSubview(myInfoImageView)
        myInfoImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(28.5)
            make.leading.equalTo(myInfoLabel.snp.trailing).offset(4)
            make.height.width.equalTo(20)
        }
        
        self.view.addSubview(myInfoEditButton)
        myInfoEditButton.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(28)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(21)
            make.width.equalTo(64)
        }
        myInfoEditButton.addTarget(self, action: #selector(edit_Tapped), for: .touchUpInside)
        
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(myInfoLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.view.addSubview(degreeLabel)
        degreeLabel.snp.makeConstraints { make in
            make.top.equalTo(myInfoLabel.snp.bottom).offset(25)
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
            make.height.equalTo(19)
        }
        
        self.view.addSubview(certificateView)
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
            make.centerY.equalToSuperview()
            make.leading.equalTo(certificateImageView.snp.trailing).offset(8)
            make.height.equalTo(19)
        }
        
        self.view.addSubview(warningImageView)
        warningImageView.snp.makeConstraints { make in
            make.top.equalTo(certificateView.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(28)
            make.height.width.equalTo(12)
        }
        
        self.view.addSubview(warningLabel)
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(certificateView.snp.bottom).offset(6)
            make.leading.equalTo(warningImageView.snp.trailing).offset(4)
            make.height.equalTo(12)
        }
        
        self.view.addSubview(pointView)
        pointView.snp.makeConstraints { make in
            make.top.equalTo(warningImageView.snp.bottom).offset(20)
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
            make.top.equalToSuperview().offset(28.5)
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
            make.top.equalTo(myPointLabel.snp.bottom).offset(8)
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
    
    private func setMyProfile() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.mypage.path
        
        APIService().getWithAccessToken(of: APIResponse<MyProfile>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                self.nameLabel.text = response.result.name
                switch response.result.degreeLevel {
                case "BACHELORS_STUDYING":
                    self.degreeLabel.text = "학사 재학 중"
                case "BACHELORS_GRADUATED":
                    self.degreeLabel.text = "학사 졸업"
                case "MASTERS_STUDYING":
                    self.degreeLabel.text = "석사 재학 중"
                case "MASTERS_GRADUATED":
                    self.degreeLabel.text = "석사 졸업"
                case "DOCTORAL_STUDYING":
                    self.degreeLabel.text = "박사 재학 중"
                case "DOCTORAL_GRADUATED":
                    self.degreeLabel.text = "박사 졸업"
                default:
                    self.warningImageView.isHidden = false
                    self.warningImageView.snp.makeConstraints { make in
                        make.height.width.equalTo(1)
                    }
                    self.warningLabel.isHidden = false
                    self.certificateLabel.text = "아직 학적 인증이 완료되지 않은 상태입니다"
                }
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let pointNumber = String(numberFormatter.string(from: NSNumber(value: response.result.point ?? 0)) ?? "")
                self.pointLabel.text = pointNumber
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    @objc private func logOutAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.auth.path
        
        APIService().postWithAccessToken(of: APIResponse<String>.self, url: url, parameters: nil, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                print("로그아웃이 정상적으로 처리되었습니다.")
                AlertController(message: "로그아웃 하시겠어요?", isCancel: true) {
                    let LoginVC = UINavigationController(rootViewController: LoginViewController())
                    SceneDelegate().setRootViewController(LoginVC)
                    self.navigationController?.popToRootViewController(animated: true)
                }.show()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    @objc private func edit_Tapped() {
        let editProfileViewController = EditProfileViewController()
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
}

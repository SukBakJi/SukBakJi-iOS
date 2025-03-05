//
//  ViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/16/24.
//

import UIKit
import Then
import SnapKit
import KakaoSDKUser
import AuthenticationServices

class LoginViewController: UIViewController {
    
    // MARK: - ImageView
    private let symbolImageView = UIImageView().then {
        $0.image = UIImage(named: "SBJ_symbol")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Label
    private let titleLabel = UILabel().then {
        let fullText = "로그인 한 번으로\n대학원 생활 시작하기"
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let rangeText = (fullText as NSString).range(of: "로그인")
        attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: rangeText)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        $0.attributedText = attributedString
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Bold", size: 26)
        $0.numberOfLines = 0
    }
    private let signUpLabel = UILabel().then {
        $0.text = "아직 석박지 계정이 없다면?"
        $0.textAlignment = .center
        $0.textColor = .gray500
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.numberOfLines = 0
    }
    
    // MARK: - Button
    private let kakaoLoginButton = UIButton().then {
        $0.setTitle("카카오톡으로 로그인", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.setImage(UIImage(named: "SBJ_Kakao"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -150, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        $0.backgroundColor = .kakao
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.25
        $0.layer.borderColor = UIColor.kakaoBorder.cgColor
        $0.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
    }
    private let appleLoginButton = UIButton().then {
        $0.setTitle("Apple로 로그인", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.setImage(UIImage(named: "SBJ_Apple"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -185, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.25
        $0.layer.borderColor = UIColor.black.cgColor
        $0.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    }
    private let emailLoginButton = UIButton().then {
        $0.setTitle("이메일로 로그인", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.setImage(UIImage(named: "SBJ_Mail"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -180, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        $0.backgroundColor = .white
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.25
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.addTarget(self, action: #selector(emailLoginButtonTapped), for: .touchUpInside)
    }
    private let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.setTitleColor(.gray600, for: .normal)
        $0.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    private let findAccountButton = UIButton().then {
        $0.setTitle("계정 찾기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.setTitleColor(.gray600, for: .normal)
    }
    
    private let isAutoLoginEnabled = UserDefaults.standard.bool(forKey: "isAutoLogin")
    
    // MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        KeychainHelper.standard.delete(service: "access-token", account: "user")
        KeychainHelper.standard.delete(service: "refresh-token", account: "user")
        
        setupViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() 
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    
    // MARK: - Screen transition
    // 회원가입
    @objc private func signUpButtonTapped() {
        let SignUpVC = SignUpViewController()
        self.navigationController?.pushViewController(SignUpVC, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    @objc private func emailLoginButtonTapped() {
        let EmailLoginVC = EmailLoginViewController()
        self.navigationController?.pushViewController(EmailLoginVC, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    // 카카오톡 로그인
    @objc private func kakaoLoginButtonTapped() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            
            //카톡 설치되어있으면 -> 카톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오톡 회원가입 성공")
                    
                    // 토큰 저장 후 네트워크에 넣기
                    guard let accessToken = oauthToken?.accessToken else { return }
                    self.postOAuth2Login(
                        provider: "KAKAO",
                        accessToken: accessToken
                    )
                }
            }
        }
        else {
            // 카톡 없으면 -> 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("카카오 계정으로 회원가입 성공")
                    
                    // 토큰 저장 후 네트워크에 넣기
                    guard let accessToken = oauthToken?.accessToken else { return }
                    self.postOAuth2Login(
                        provider: "KAKAO",
                        accessToken: accessToken
                    )
                }
            }
        }
    }
    @objc private func appleLoginButtonTapped() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
    }
    
    private func navigateToHomeScreen() {
        let tabBarVC = MainTabViewController()
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
    private func navigateToTOSScreen(isKakaoSignUp: Bool = false) {
        let TOSVC = TOSViewController()
        TOSVC.isKakaoSignUp = isKakaoSignUp
        self.navigationController?.pushViewController(TOSVC, animated: true)
        //self.dismiss(animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    // MARK: - Functional
    private func postOAuth2Login(provider: String, accessToken: String) {
        UserApi.shared.me {(user, error) in
            if let error = error {
                print(error)
            } else {
                let authDataManager = AuthDataManager()
                
                let requestBody = Oauth2RequestDTO(
                    provider: provider,
                    accessToken: accessToken
                )
                
                authDataManager.oauth2LoginDataManager(requestBody) {
                    [weak self] data in
                    guard let self = self else { return }
                    
                    
                    // 응답
                    if let model = data, model.code == "COMMON200" {
                        self.navigateToTOSScreen(isKakaoSignUp: true)
                        checkIsSignUp()
                    } else {
                        print("OAuth2 로그인 실패")
                    }
                }
            }
        }
    }
    private func checkIsSignUp() {
        let userDataManager = UserDataManager()
        
        userDataManager.GetMypageDataManager() {
            [weak self] profileModel in
            guard let self = self else { return }
            
            // 응답
            if let model = profileModel, model.result?.name == nil {
                print("프로필 설정 진행 안 함 -> 회원가입으로 이동")
                navigateToTOSScreen(isKakaoSignUp: true)
            }
            else if let model = profileModel, model.result?.name != nil {
                print("프로필 설정 진행 되어있음 -> 홈화면으로 이동")
                self.navigateToHomeScreen()
            }
            else {
                print("프로필 불러오기 실패")
            }
        }
    }
    
    private func showMessage(message: String) {
        print("메시지 : \(message)")
    }
    
    // MARK: - addView
    func setupViews() {
        
        if isAutoLoginEnabled, let accessToken = KeychainHelper.standard.read(service: "access-token", account: "user") {
            print("자동 로그인 활성화: \(accessToken)")
            let tabBarVC = MainTabViewController()
            self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
        
        view.addSubview(symbolImageView)
        view.addSubview(titleLabel)
        view.addSubview(kakaoLoginButton)
        view.addSubview(appleLoginButton)
        view.addSubview(emailLoginButton)
        view.addSubview(signUpLabel)
        view.addSubview(signUpButton)
        view.addSubview(findAccountButton)
    }
    
    // MARK: - setLayout
    func setupLayout() {
        
        symbolImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(87)
            make.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(symbolImageView.snp.bottom).offset(12)
            make.height.equalTo(80)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-8)
            make.width.equalTo(342)
            make.height.equalTo(54)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(emailLoginButton.snp.top).offset(-8)
            make.width.equalTo(342)
            make.height.equalTo(54)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(193)
            make.width.equalTo(342)
            make.height.equalTo(54)
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLoginButton.snp.bottom).offset(71)
            make.leading.equalToSuperview().inset(101)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.centerY.equalTo(signUpLabel)
            make.trailing.equalToSuperview().inset(101)
        }
        
        findAccountButton.snp.makeConstraints { make in
            make.centerX.equalTo(emailLoginButton)
            make.top.equalTo(emailLoginButton.snp.bottom).offset(24)
        }
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    // 인증창을 보여주기 위한 메서드 (인증창을 보여 줄 화면을 설정)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    // 로그인 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("로그인 실패", error.localizedDescription)
    }
    
    // Apple ID 로그인에 성공한 경우, 사용자의 인증 정보를 확인하고 필요한 작업을 수행합니다
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            
            guard let authorizationCodeData = appleIdCredential.authorizationCode,
                  let authorizationCodeString = String(data: authorizationCodeData, encoding: .utf8) else {
                print("Authorization Code 변환 실패")
                return
            }
            
            print("Apple ID 로그인에 성공하였습니다.")
            print("authorizationCode: \(authorizationCodeString)")
            
            // 여기에 로그인 성공 후 수행할 작업을 추가하세요.
            postOAuth2Login(provider: "APPLE", accessToken: authorizationCodeString)
            
        default: break
            
        }
    }
}


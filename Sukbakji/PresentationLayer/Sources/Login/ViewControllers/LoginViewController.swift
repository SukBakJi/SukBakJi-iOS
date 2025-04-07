//
//  ViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/16/24.
//
import UIKit
import KakaoSDKUser
import AuthenticationServices

class LoginViewController: UIViewController {
    // MARK: - Properties
    private let isAutoLoginEnabled = UserDefaults.standard.bool(forKey: "isAutoLogin")
    
    // MARK: - Views
    private lazy var loginView = LoginView().then {
        $0.kakaoButton.addTarget(self, action: #selector(didTapKakaoLogin), for: .touchUpInside)
        $0.appleButton.addTarget(self, action: #selector(didTapAppleLogin), for: .touchUpInside)
        $0.emailButton.addTarget(self, action: #selector(didTapEmailLogin), for: .touchUpInside)
        $0.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        $0.findAccountButton.addTarget(self, action: #selector(didTapfindAccount), for: .touchUpInside)
    }
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        
        if isAutoLoginEnabled, let accessToken = KeychainHelper.standard.read(service: "access-token", account: "user") {
            print("자동 로그인 활성화: \(accessToken)")
            let tabBarVC = MainTabViewController()
            self.navigationController?.setViewControllers([tabBarVC], animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true // 뷰 컨트롤러가 나타날 때 숨기기
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false // 뷰 컨트롤러가 사라질 때 나타내기
    }
    
    //MARK: - Functional
    private func navigateToHomeScreen() {
        let tabBarVC = MainTabViewController()
        self.navigationController?.setViewControllers([tabBarVC], animated: true)
    }
    
    private func navigateToTOSScreen(isOAuth2: Bool = false) {
        let TOSVC = TOSViewController()
        TOSVC.isOAuth2 = isOAuth2
        self.navigationController?.pushViewController(TOSVC, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil).then {
            $0.tintColor = .black
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
                navigateToTOSScreen(isOAuth2: true)
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
    
    //MARK: Event
    @objc func didTapKakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            //카톡 설치되어있으면 -> 카톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
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
                    guard let accessToken = oauthToken?.accessToken else { return }
                    self.postOAuth2Login(
                        provider: "KAKAO",
                        accessToken: accessToken
                    )
                }
            }
        }
    }
    
    @objc func didTapAppleLogin() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        
        // 사용자에게 제공받을 정보
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @objc func didTapEmailLogin() {
        let EmailLoginVC = EmailLoginViewController()
        self.navigationController?.pushViewController(EmailLoginVC, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil).then {
            $0.tintColor = .black
        }
    }
    
    @objc func didTapSignUp() {
        let SignUpVC = SignupViewController()
        self.navigationController?.pushViewController(SignUpVC, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil).then {
            $0.tintColor = .black
        }
    }
    
    @objc func didTapfindAccount() {
        
    }
    
    // MARK: - Network
    private func postOAuth2Login(provider: String, accessToken: String) {
        let authDataManager = AuthDataManager()
        
        let requestBody = Oauth2RequestDTO(
            provider: provider,
            accessToken: accessToken
        )
        print("requestBody: \(requestBody)")
        authDataManager.oauth2LoginDataManager(requestBody) {
            [weak self] data in
            guard let self = self else { return }
            
            // 응답
            if let model = data, model.code == "COMMON200" {
                checkIsSignUp()
            } else {
                print("OAuth2 로그인 실패")
                let alert = UIAlertController(title: nil, message: "소셜 로그인에 실패하였습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    private func postAppleEmail(email: String) {
        let userDatamanager = UserDataManager()
    
        userDatamanager.PostAppleEmailDataManager(email) {
            [weak self] data in
            guard let self = self else { return }
            
            if let model = data, model.code == "COMMON200" {
                print("애플 이메일 설정 성공")
            }
        }
    }
}

// MARK: - extension
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
            
            // 애플 이메일 저장용
            var userAppleEmail: String?
            
            if let email = appleIdCredential.email {
                userAppleEmail = email
                print("애플 이메일: \(userAppleEmail ?? "애플 이메일 저장 실패")")
            }
            
            guard let authorizationCodeData = appleIdCredential.authorizationCode,
                  let authorizationCodeString = String(data: authorizationCodeData, encoding: .utf8) else {
                print("Authorization Code 변환 실패")
                return
            }
            
            // 여기에 로그인 성공 후 수행할 작업을 추가하세요.
            print("Apple ID 로그인에 성공하였습니다.")
            postOAuth2Login(provider: "APPLE", accessToken: authorizationCodeString)

            if let userAppleEmail = userAppleEmail {
                postAppleEmail(email: userAppleEmail)
            }
            
        default: break
            
        }
    }
}

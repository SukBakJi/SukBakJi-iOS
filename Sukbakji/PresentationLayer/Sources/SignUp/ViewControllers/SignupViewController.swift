//
//  SelectSignUpViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/16/24.
//

import UIKit
import Then
import SnapKit
import KakaoSDKUser
import AuthenticationServices

class SignupViewController: UIViewController {
    // MARK: - Views
    private lazy var signupView = SignupView().then {
        $0.kakaoButton.addTarget(self, action: #selector(didTapKakao), for: .touchUpInside)
        $0.appleButton.addTarget(self, action: #selector(didTapApple), for: .touchUpInside)
        $0.emailButton.addTarget(self, action: #selector(didTapEmail), for: .touchUpInside)
        $0.findAccountButton.addTarget(self, action: #selector(didTapfindAccount), for: .touchUpInside)
    }
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = signupView
        self.title = "회원가입"
    }
    
    // MARK: - Functional
    private func navigateToHomeScreen() {
        let tabBarVC = MainTabViewController()
        self.navigationController?.setViewControllers([tabBarVC], animated: true)
    }
    
    private func navigateToTOSScreen(isKakaoSignUp: Bool = false) {
        let TOSVC = TOSViewController()
        TOSVC.isKakaoSignUp = isKakaoSignUp
        self.navigationController?.pushViewController(TOSVC, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil).then {
            $0.tintColor = .black
        }
    }
    
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
    
    //MARK: Event
    @objc
    func didTapKakao() {
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
    
    @objc
    func didTapApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @objc
    func didTapEmail() {
        navigateToTOSScreen()
    }
    
    @objc
    func didTapfindAccount() {
        
    }
}

// MARK: - extension
extension SignupViewController: ASAuthorizationControllerPresentationContextProviding {
    // 인증창을 보여주기 위한 메서드 (인증창을 보여 줄 화면을 설정)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
}

extension SignupViewController: ASAuthorizationControllerDelegate {
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

//
//  SceneDelegate.swift
//  Sukbakji
//
//  Created by jaegu park on 7/7/24.
//

import UIKit
import SwiftUI
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var LoginVC = UINavigationController(rootViewController: MainTabViewController())
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let isAutoLoginEnabled = UserDefaults.standard.bool(forKey: "isAutoLogin")
        
        if isAutoLoginEnabled {
            print("자동 로그인 활성화됨")

            // Step 1: accessToken 유효성 확인은 서버 요청으로도 가능하지만
            // 여기선 그냥 refreshToken으로 무조건 갱신 시도
            AuthInterceptor().performInitialTokenRefresh { [weak self] success in
                guard let self = self else { return }

                if success {
                    print("✅ 초기 토큰 갱신 성공 → 메인 화면 진입")
                    self.window?.rootViewController = UINavigationController(rootViewController: MainTabViewController())
                } else {
                    print("❌ 초기 토큰 갱신 실패 → 로그인 화면 이동")
                    self.disableAutoLoginAndReturnToLoginScreen()
                }

                self.window?.makeKeyAndVisible()
            }
        } else {
            print("🚪 자동 로그인 꺼져 있음 → 로그인 화면 진입")
            window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
            window?.makeKeyAndVisible()
        }
    }

    func disableAutoLoginAndReturnToLoginScreen() {
        // 자동 로그인 비활성화
        UserDefaults.standard.set(false, forKey: "isAutoLogin")
        
        // 로그인 화면으로 돌아가기
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            return
        }
        
        let mainViewController = UINavigationController(rootViewController: LoginViewController())
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
        
        print("자동 로그인이 비활성화되었고, 로그인 화면으로 돌아갔습니다.")
    }
    
    func setRootViewController(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .first(where: { $0 is UIWindowScene }) as? UIWindowScene else {
            return
        }

        window.windows.first?.rootViewController = viewController
        window.windows.first?.makeKeyAndVisible()
    }
    
    // MARK: - 카카오 연결
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
//        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
//        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
//    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        //disableAutoLoginAndReturnToLoginScreen()

    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


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
    // SiwftUI로 BoardViewController 실행하기

//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: windowScene)
//        
//        let mainViewController = UINavigationController(rootViewController: LoginViewController())
//        //let mainViewController = UINavigationController(rootViewController: TOSViewController())
//        
//        window?.rootViewController = mainViewController
//        window?.makeKeyAndVisible()
//    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window!.makeKeyAndVisible()
        window!.windowScene = windowScene
        window!.rootViewController = LoginVC
//        let isAutoLoginEnabled = UserDefaults.standard.bool(forKey: "isAutoLogin")
//
//        if isAutoLoginEnabled, let accessToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) {
//            print("자동 로그인 활성화: \(accessToken)")
//            let mainViewController = UINavigationController(rootViewController: LoginViewController())
//            window?.rootViewController = mainViewController
//        } else {
//        }
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
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//      if let windowScene = scene as? UIWindowScene {
//        let window = UIWindow(windowScene: windowScene)
//        window.rootViewController = UIHostingController(
//          rootView: BoardViewController()
//        )
//        self.window = window
//        window.makeKeyAndVisible()
//      }
//    }
    
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
//        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
//        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
//    }
    
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


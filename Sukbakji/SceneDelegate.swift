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
    // SiwftUI로 BoardViewController 실행하기

//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: windowScene)
//        
//        let mainViewController = UINavigationController(rootViewController: LoginViewController())
//        //let mainViewController = UINavigationController(rootViewController: successSignUpViewController())
//        
//        window?.rootViewController = mainViewController
//        window?.makeKeyAndVisible()
//    }

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

        let isAutoLoginEnabled = UserDefaults.standard.bool(forKey: "isAutoLogin")

        if isAutoLoginEnabled, let accessToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) {
//            print("자동 로그인 활성화: \(accessToken)")
//            switchToTabBarController() // 자동 로그인 후 홈 화면으로 전환
            let mainViewController = UINavigationController(rootViewController: MainTabViewController())
            window?.rootViewController = mainViewController
        } else {
            let mainViewController = UINavigationController(rootViewController: LoginViewController())
            window?.rootViewController = mainViewController
        }

        window?.makeKeyAndVisible()
    }

    
    func switchToTabBarController() {
        let tabBarController = MainTabViewController()

        let firstViewController = UINavigationController(rootViewController: HomeViewController())
        firstViewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "Sukbakji_Home"), tag: 0)

        let Calendarstoryboard = UIStoryboard(name: "Calendar", bundle: nil)
        let secondViewController = Calendarstoryboard.instantiateViewController(withIdentifier: "CalendarVC")
        secondViewController.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(named: "Sukbakji_Calendar"), tag: 1)

        let swiftUIBoardView = BoardViewController()
        let thirdViewController = UIHostingController(rootView: swiftUIBoardView)
        thirdViewController.tabBarItem = UITabBarItem(title: "게시판", image: UIImage(named: "Sukbakji_Board"), tag: 2)

        let Chattingstoryboard = UIStoryboard(name: "Chatting", bundle: nil)
        let fourthViewController = Chattingstoryboard.instantiateViewController(withIdentifier: "ChattingVC")
        fourthViewController.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(named: "Sukbakji_Chatting"), tag: 3)

        let swiftUIDirectoryView = DirectoryMainViewController()
        let fifthViewController = UIHostingController(rootView: swiftUIDirectoryView)
        fifthViewController.tabBarItem = UITabBarItem(title: "디렉토리", image: UIImage(named: "Sukbakji_Board"), tag: 4)

        tabBarController.viewControllers = [firstViewController, secondViewController, thirdViewController, fourthViewController, fifthViewController]

        // UIWindow의 rootViewController를 탭 바 컨트롤러로 설정
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
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


//
//  AppDelegate.swift
//  Sukbakji
//
//  Created by jaegu park on 7/7/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        UNUserNotificationCenter.current().delegate = self
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: {_, _ in}
//        )
//        application.registerForRemoteNotifications()
        
        KakaoSDK.initSDK(appKey: "0cf7886895af19a6dcd4ec656890f126")
        
        // Override point for customization after application launch.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
                
        return true
    }
    
    // MARK: - 카카오 연결
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: MessagingDelegate {
    // FCM Token 업데이트 시
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🥳", #function, fcmToken ?? "nil")
    }
    
    // error 발생 시
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("😭", error)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 앱 화면을 보고있는 중(포그라운드)에 푸시 올 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        print("😎", #function)
        
        // 푸시 알림 데이터가 userInfo에 담겨있다.
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        if #available(iOS 14.0, *) {
            return [.sound, .banner, .list]
        } else {
            return []
        }
    }
}

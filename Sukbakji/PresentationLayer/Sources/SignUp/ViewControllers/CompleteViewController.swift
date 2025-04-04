//
//  CompleteViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 3/13/25.
//

import UIKit
import FirebaseMessaging

class CompleteViewController: UIViewController {
    
    private let myProfileViewModel = MyProfileViewModel()

    private lazy var completeView = CompleteView().then {
        $0.nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = completeView
        getFCMToken()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 나타내기
    }
    
    private func getFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("FCM 토큰 가져오기 실패: \(error.localizedDescription)")
            } else if let token = token {
                print("현재 FCM 토큰: \(token)")
                // 서버에 토큰 업로드
                TokenManager.shared.saveFCMToken(token)
                self.myProfileViewModel.uploadFCMTokenToServer(fcmToken: token)
            }
        }
    }
    
    @objc
    private func didTapNext() {
        let tabBarVC = MainTabViewController()
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }

}

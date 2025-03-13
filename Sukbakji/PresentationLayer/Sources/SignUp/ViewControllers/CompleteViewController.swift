//
//  CompleteViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 3/13/25.
//

import UIKit

class CompleteViewController: UIViewController {

    private lazy var completeView = CompleteView().then {
        $0.nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = completeView
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 나타내기
    }
    
    @objc
    private func didTapNext() {
        let tabBarVC = MainTabViewController()
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }

}

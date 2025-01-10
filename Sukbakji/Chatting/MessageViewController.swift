//
//  MessageViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import UIKit
import SnapKit
import Alamofire
import Then
import RxSwift
import RxCocoa

class MessageViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.text = "게시판에서 궁금했던 내용, 채팅에서 더 나눠 보세요"
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 22)
    }
    private let noChatLabel = UILabel().then {
        $0.text = "아직 채팅방이 없어요!"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 22)
    }
    private let noChatLabel2 = UILabel().then {
        $0.text = "게시판을 탐색하고 채팅을 나눠 보세요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

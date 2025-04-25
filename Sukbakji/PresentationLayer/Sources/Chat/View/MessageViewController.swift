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
    
    private let noChatLabel = UILabel().then {
        $0.text = "아직 채팅방이 없어요!"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let noChatLabel2 = UILabel().then {
        $0.text = "게시판을 탐색하고 채팅을 나눠 보세요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    private let messageImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Message")
    }
    private let goBoardButton = UIButton().then {
        $0.clipsToBounds = true
        $0.setTitle("게시판 바로가기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.orange700, for:.normal)
        $0.layer.cornerRadius = 8
    }
    private let ChatLabel = UILabel().then {
        $0.text = "게시판에서 궁금했던 내용, \n채팅에서 더 나눠 보세요"
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private var messageRoomTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(MessageRoomTableViewCell.self, forCellReuseIdentifier: MessageRoomTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(noChatLabel)
        noChatLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(66)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.view.addSubview(noChatLabel2)
        noChatLabel2.snp.makeConstraints { make in
            make.top.equalTo(noChatLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(17)
        }
        
        self.view.addSubview(messageImageView)
        messageImageView.snp.makeConstraints { make in
            make.top.equalTo(noChatLabel2.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(180)
        }
        
        self.view.addSubview(goBoardButton)
        goBoardButton.snp.makeConstraints { make in
            make.top.equalTo(messageImageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        self.view.addSubview(ChatLabel)
        ChatLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(66)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
        ChatLabel.isHidden = true
        
        self.view.addSubview(messageRoomTableView)
        messageRoomTableView.snp.makeConstraints { make in
            make.top.equalTo(ChatLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        messageRoomTableView.isHidden = true
    }
}

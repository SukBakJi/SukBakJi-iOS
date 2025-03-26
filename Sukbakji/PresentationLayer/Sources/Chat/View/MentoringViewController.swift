//
//  MentoringViewController.swift
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

class MentoringViewController: UIViewController {
    
    private let noMentorLabel = UILabel().then {
        $0.text = "아직 멘토가 없어요!"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let noMentorLabel2 = UILabel().then {
        $0.text = "가고 싶은 연구실 선배와 함께 대화해봐요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    private let mentoringImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Mentoring")
    }
    private let goMentoringButton = UIButton().then {
        $0.clipsToBounds = true
        $0.setTitle("멘토링 신청하러 가기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.orange700, for:.normal)
        $0.layer.cornerRadius = 8
    }
    private let mentoringLabel = UILabel().then {
        $0.text = "멘토링 어떻게 진행되나요?"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let searchingImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_MentorProgress")
    }
    private let howToMentoringLabel = UILabel().then {
        $0.text = "석박지 멘토링, 이렇게 진행되고 있어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    private let howToMentoringLabel2 = UILabel().then {
        $0.text = "멘토 매칭 후 앱 채팅 기능을 통해 멘토링을 진행해요"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray500
    }
    private let goMentorButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_MentorButton"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    private let MentorLabel = UILabel().then {
        $0.text = "궁금한 점을 멘토에게 물어 보세요!"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let MentorLabel2 = UILabel().then {
        $0.text = "가고 싶은 연구실 선배와 함께 대화해봐요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    private var mentoringRoomTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(MentoringRoomTableViewCell.self, forCellReuseIdentifier: MentoringRoomTableViewCell.identifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(noMentorLabel)
        noMentorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(66)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.view.addSubview(noMentorLabel2)
        noMentorLabel2.snp.makeConstraints { make in
            make.top.equalTo(noMentorLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(17)
        }
        
        self.view.addSubview(mentoringImageView)
        mentoringImageView.snp.makeConstraints { make in
            make.top.equalTo(noMentorLabel2.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(180)
        }
        
        self.view.addSubview(goMentoringButton)
        goMentoringButton.snp.makeConstraints { make in
            make.top.equalTo(mentoringImageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        self.view.addSubview(mentoringLabel)
        mentoringLabel.snp.makeConstraints { make in
            make.top.equalTo(goMentoringButton.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(21)
        }
        
        self.view.addSubview(searchingImageView)
        searchingImageView.snp.makeConstraints { make in
            make.centerY.equalTo(mentoringLabel)
            make.leading.equalTo(mentoringLabel.snp.trailing).offset(4)
            make.height.width.equalTo(20)
        }
        
        self.view.addSubview(howToMentoringLabel)
        howToMentoringLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mentoringLabel.snp.bottom).offset(30)
            make.height.equalTo(19)
        }
        let fullText = howToMentoringLabel.text ?? ""
        let changeText = "석박지 멘토링"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        howToMentoringLabel.attributedText = attributedString
        
        self.view.addSubview(howToMentoringLabel2)
        howToMentoringLabel2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(howToMentoringLabel.snp.bottom).offset(12)
            make.height.equalTo(17)
        }
        
        self.view.addSubview(goMentorButton)
        goMentorButton.snp.makeConstraints { make in
            make.top.equalTo(howToMentoringLabel2.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(92)
        }
        
        self.view.addSubview(MentorLabel)
        MentorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(66)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        MentorLabel.isHidden = true
        
        self.view.addSubview(MentorLabel2)
        MentorLabel2.snp.makeConstraints { make in
            make.top.equalTo(MentorLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(17)
        }
        MentorLabel2.isHidden = true
        
        self.view.addSubview(mentoringRoomTableView)
        mentoringRoomTableView.snp.makeConstraints { make in
            make.top.equalTo(MentorLabel2.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview()
        }
        mentoringRoomTableView.isHidden = true
    }
}

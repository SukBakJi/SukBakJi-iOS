//
//  SelectSignUpViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/16/24.
//

import UIKit
import Then
import SnapKit

class SelectSignUpViewController: UIViewController {
    
    // MARK: - Label
    private let titleLabel = UILabel().then {
        $0.text = "석박지 회원가입"
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-Bold", size: 26)
        $0.numberOfLines = 0
    }
    
    // MARK: - Button
    private let kakaoSignUpButton = UIButton().then {
        $0.setTitle("카카오톡으로 회원가입", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        
        $0.setImage(UIImage(named: "Kakao"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -135, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        $0.backgroundColor = .kakao
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.25
        $0.layer.borderColor = UIColor.kakaoBorder.cgColor
    }
    
    private let googleSignUpButton = UIButton().then {
        $0.setTitle("Apple로 회원가입", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        
        $0.setImage(UIImage(named: "Apple"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -165, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.25
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    private let emailSignUpButton = UIButton().then {
        $0.setTitle("이메일로 회원가입", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        
        $0.setImage(UIImage(named: "Mail"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -165, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        $0.backgroundColor = .white
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.25
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.addTarget(self, action: #selector(EmailSignUpButtonTapped), for: .touchUpInside)
    }

    // MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupLayout()
    }
    

    // MARK: - Functional
    @objc private func EmailSignUpButtonTapped() {
        print("이메일로 회원가입")
        
        let EmailSignUpVC = EmailLoginViewController()
        self.navigationController?.pushViewController(EmailSignUpVC, animated: true)
        self.dismiss(animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    // MARK: - addView
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(kakaoSignUpButton)
        view.addSubview(googleSignUpButton)
        view.addSubview(emailSignUpButton)
    }
    // MARK: - setLayout
    func setupLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(56)
            make.centerX.equalToSuperview()
        }
        
        kakaoSignUpButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(342)
            make.height.equalTo(54)
        }
        
        googleSignUpButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoSignUpButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(342)
            make.height.equalTo(54)
        }
        
        emailSignUpButton.snp.makeConstraints { make in
            make.top.equalTo(googleSignUpButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(342)
            make.height.equalTo(54)
        }
        
        
    }
    
}

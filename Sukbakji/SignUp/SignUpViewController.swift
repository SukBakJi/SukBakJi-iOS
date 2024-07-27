//
//  SelectSignUpViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/16/24.
//

import UIKit
import Then
import SnapKit

class SignUpViewController: UIViewController {
    
    // MARK: - ImageView
    private let symbolImageView = UIImageView().then {
        $0.image = UIImage(named: "symbol")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: - Label
    private let titleLabel = UILabel().then {
        let fullText = "로그인 한 번으로\n대학원 생활 시작하기"
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let rangeText = (fullText as NSString).range(of: "로그인")
        attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: rangeText)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        $0.attributedText = attributedString
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
        $0.adjustsImageWhenHighlighted = false
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -135, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        $0.backgroundColor = .kakao
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.25
        $0.layer.borderColor = UIColor.kakaoBorder.cgColor
    }
    private let appleSignUpButton = UIButton().then {
        $0.setTitle("Apple로 회원가입", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.setImage(UIImage(named: "Apple"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
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
        $0.adjustsImageWhenHighlighted = false
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -165, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        $0.backgroundColor = .white
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.25
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.addTarget(self, action: #selector(EmailSignUpButtonTapped), for: .touchUpInside)
    }
    private let findAccountButton = UIButton().then {
        $0.setTitle("계정 찾기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.setTitleColor(.gray600, for: .normal)
        //$0.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpNavigationBar()
        setupViews()
        setupLayout()
    }
    
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "회원가입"
    }
    
    // MARK: - Screen transition
    @objc private func EmailSignUpButtonTapped() {
        let EmailSignUpVC = EmailSignUpViewController()
        self.navigationController?.pushViewController(EmailSignUpVC, animated: true)
        self.dismiss(animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    // MARK: - Functional
    
    // MARK: - addView
    func setupViews() {
        view.addSubview(symbolImageView)
        view.addSubview(titleLabel)
        view.addSubview(kakaoSignUpButton)
        view.addSubview(appleSignUpButton)
        view.addSubview(emailSignUpButton)
        view.addSubview(findAccountButton)
    }
    // MARK: - setLayout
    func setupLayout() {
        
        symbolImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(72)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(symbolImageView.snp.bottom).offset(12)
        }
        
        kakaoSignUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(appleSignUpButton.snp.top).offset(-8)
            make.width.equalTo(342)
            make.height.equalTo(54)
        }
        
        appleSignUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(emailSignUpButton.snp.top).offset(-8)
            make.width.equalTo(342)
            make.height.equalTo(54)
        }
        
        emailSignUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(193)
            make.width.equalTo(342)
            make.height.equalTo(54)
        }
        
        findAccountButton.snp.makeConstraints { make in
            make.centerX.equalTo(emailSignUpButton)
            make.top.equalTo(emailSignUpButton.snp.bottom).offset(24)
        }
        
        
    }
    
}

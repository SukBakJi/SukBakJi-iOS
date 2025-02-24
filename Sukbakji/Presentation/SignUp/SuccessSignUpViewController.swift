//
//  successSignUpViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/20/24.
//

import UIKit

class successSignUpViewController: UIViewController {
    
    // MARK: - ImageView
    private let RocketImage = UIImageView().then {
        $0.image = UIImage(named: "SBJ_Rocket")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Label
    private let successLabel = UILabel().then {
        let fullText = "석박지의 새로운 회원이\n되신 걸 환영합니다!"
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let rangeText = (fullText as NSString).range(of: "석박지")
        attributedString.addAttribute(.foregroundColor, 
                                      value: UIColor.orange700, range: rangeText)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, 
                                      value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        $0.attributedText = attributedString
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-Bold", size: 26)
        $0.numberOfLines = 0
    }
    
    // MARK: - Button
    private let nextButton = UIButton().then {
        $0.setTitle("석박지 시작하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
        
        $0.backgroundColor = .orange700
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 나타내기
    }
    
    // MARK: - Screen transition
    @objc private func nextButtonTapped() {
        navigateToHomeScreen()
    }
    private func navigateToHomeScreen() {
        let tabBarVC = MainTabViewController()
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }
    // MARK: - addView
    func setupViews() {
        view.addSubview(RocketImage)
        view.addSubview(successLabel)
        view.addSubview(nextButton)
    }
    
    // MARK: - setLayout
    func setupLayout() {
        
        RocketImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(133)
            make.height.width.equalTo(170)
        }
        
        successLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(RocketImage.snp.bottom).offset(48)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(successLabel.snp.bottom).offset(218)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
    }
}

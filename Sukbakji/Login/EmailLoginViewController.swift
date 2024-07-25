//
//  processLoginViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/16/24.
//

import Foundation
import SnapKit
import Then
import UIKit


class EmailLoginViewController: UIViewController {
    
    // MARK: - ImageView
    private let emailDot = UIImageView().then {
        $0.image = UIImage(named: "dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let passwordDot = UIImageView().then {
        $0.image = UIImage(named: "dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let emailWarningIcon = UIImageView().then {
        $0.image = UIImage(named: "warningCircle")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let passwordWarningIcon = UIImageView().then {
        $0.image = UIImage(named: "warningCircle")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
///     회원가입에서 쓸 거
///    private let correctIcon = UIImageView().then {
///        $0.image = UIImage(named: "correctCircle")
///        $0.contentMode = .scaleAspectFit
///        $0.clipsToBounds = true
///        $0.translatesAutoresizingMaskIntoConstraints = false
///    }
    
    
    // MARK: - Label
    private let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    
    private let emailWarningLabel = UILabel().then {
        $0.text = "이메일을 입력해 주세요"
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let passwordWarningLabel = UILabel().then {
        $0.text = "비밀번호를 입력해 주세요"
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    
    private let signUpLabel = UILabel().then {
        $0.text = "아직 석박지 계정이 없다면?"
        $0.textAlignment = .center
        $0.textColor = .gray500
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.numberOfLines = 0
    }
    
    // MARK: - TextField
    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해 주세요"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.clearButtonMode = .whileEditing
        
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .none
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.frame.size.width = 342
        $0.frame.size.height = 44
        
        // 일반
        $0.backgroundColor = .gray50
        $0.textColor = .gray500
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
    
        /// 틀렸을 때
        ///$0.backgroundColor = .warning50
        ///$0.textColor = .warning400
        ///$0.layer.addBorder([.bottom], color: .warning400, width: 0.5)
        
        /// 입력 시
        ///$0.layer.addBorder([.bottom], color: .informative400 , width: 0.5)
    }
    
    private let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해 주세요"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.clearButtonMode = .whileEditing
        $0.isSecureTextEntry = true
        
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        $0.leftViewMode = .always
        $0.borderStyle = .none
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.frame.size.width = 342
        $0.frame.size.height = 44
        
        // 일반
        $0.backgroundColor = .gray50
        $0.textColor = .gray500
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        
        /// 틀렸을 때
        ///$0.backgroundColor = .warning50
        ///$0.textColor = .warning400
        ///$0.layer.addBorder([.bottom], color: .warning400, width: 0.5)
        
        /// 입력 시
        ///$0.layer.addBorder([.bottom], color: .informative400 , width: 0.5)
    }
    
    // MARK: - Button
    private let autoLoginCheckBox = UIButton().then {
        $0.setImage(UIImage(named: "state=off"), for: .normal)
        $0.setImage(UIImage(named: "state=on"), for: .selected)
        $0.setTitle("자동 로그인", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.setTitleColor(.gray600, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }
    
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
        
        // 일반
        $0.backgroundColor = .gray200
        $0.setTitleColor(.gray500, for: .normal)
        
        /// 입력 완료 시
        ///$0.backgroundColor = .orange700
        ///$0.setTitleColor(.white, for: .normal)
        
       
    }
    
    private let emailFindButton = UIButton().then {
        $0.setTitle("이메일 찾기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.titleLabel?.textAlignment = .center
        $0.setTitleColor(.gray600, for: .normal)
    }
    
    private let passwordFindButton = UIButton().then {
        $0.setTitle("비밀번호 재설정", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.titleLabel?.textAlignment = .center
        $0.setTitleColor(.gray600, for: .normal)
    }
    
    private let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.titleLabel?.textAlignment = .center
        $0.setTitleColor(.gray600, for: .normal)
    }
    
    private var eyeButton = UIButton(type: .custom)
    
    // MARK: - View
    
    private let verticalSeparator = UIView().then {
        $0.backgroundColor = .gray500
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpNavigationBar()
        setPasswordShownButtonImage()
        setupViews()
        setupLayout()
    }
    
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "이메일로 로그인"
    }
    
    // MARK: - Functional
    @objc private func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    private func setPasswordShownButtonImage() {
        eyeButton = UIButton.init(primaryAction: UIAction(handler: { [self]_ in passwordTextField.isSecureTextEntry.toggle()
            self.eyeButton.isSelected.toggle()
        }))
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.baseBackgroundColor = .clear
        buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 35)
        
        eyeButton.setImage((UIImage(named: "Password-hidden")), for: .normal)
        self.eyeButton.setImage(UIImage(named: "Password-shown"), for: .selected)
        self.eyeButton.configuration = buttonConfiguration
        
        self.passwordTextField.rightView = eyeButton
        self.passwordTextField.rightViewMode = .whileEditing
    }
    
   
    
    // MARK: - addView
    func setupViews() {
        view.addSubview(emailDot)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        
        view.addSubview(passwordDot)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        
        view.addSubview(autoLoginCheckBox)
        view.addSubview(loginButton)
        
        view.addSubview(emailFindButton)
        view.addSubview(verticalSeparator)
        view.addSubview(passwordFindButton)
        view.addSubview(signUpLabel)
        view.addSubview(signUpButton)
        
///        view.addSubview(emailWarningIcon)
///        view.addSubview(emailWarningLabel)
///        view.addSubview(passwordWarningIcon)
///        view.addSubview(passwordWarningLabel)
    }
    
    // MARK: - setLayout
    func setupLayout() {
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(24)
        }
        
        emailDot.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.top)
            make.leading.equalTo(emailLabel.snp.trailing).offset(4)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(24)
        }
        
        passwordDot.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.top)
            make.leading.equalTo(passwordLabel.snp.trailing).offset(4)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        autoLoginCheckBox.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(310)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(autoLoginCheckBox.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        emailFindButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.trailing.equalTo(verticalSeparator.snp.leading).offset(-8)
            make.height.equalTo(14)
        }
        
        verticalSeparator.snp.makeConstraints { make in
            make.centerX.equalTo(loginButton.snp.centerX)
            make.centerY.equalTo(emailFindButton)
            make.width.equalTo(0.5)
            make.height.equalTo(14)
        }
        
        passwordFindButton.snp.makeConstraints { make in
            make.leading.equalTo(verticalSeparator.snp.trailing).offset(8)
            make.centerY.equalTo(emailFindButton)
            make.height.equalTo(14)
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(emailFindButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(103)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(101)
            make.centerY.equalTo(signUpLabel)
        }
        
        /// warning part
///        emailWarningIcon.snp.makeConstraints { make in
///            make.top.equalTo(emailTextField.snp.bottom).offset(4)
///            make.leading.equalTo(emailTextField.snp.leading).offset(4)
///        }
///
///        emailWarningLabel.snp.makeConstraints { make in
///            make.centerY.equalTo(emailWarningIcon)
///            make.leading.equalTo(emailWarningIcon.snp.trailing).offset(4)
///        }
///
///        passwordWarningIcon.snp.makeConstraints { make in
///            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
///            make.leading.equalTo(passwordTextField.snp.leading).offset(4)
///        }
///
///        passwordWarningLabel.snp.makeConstraints { make in
///            make.centerY.equalTo(passwordWarningIcon)
///            make.leading.equalTo(passwordWarningIcon.snp.trailing).offset(4)
///        }
        
    }
}
// MARK: - extension
extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}

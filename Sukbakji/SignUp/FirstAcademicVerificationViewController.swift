//
//  AcademicVerificationViewController.swift
//  SeokBakJi
//
//  Created by 오현민 on 7/20/24.
//

import UIKit
import DropDown

class FirstAcademicVerificationViewController: UIViewController {
    
    private let dropDown = DropDown()
    private let itemList = [" 학사 졸업 또는 재학", " 석사 재학", " 석사 졸업", " 박사 재학", " 박사 졸업", " 석박사 통합 재학"]
    
    // MARK: - ImageView
    private let progressBar = UIImageView().then {
        $0.image = UIImage(named: "ProgressBar")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let nameDot = UIImageView().then {
        $0.image = UIImage(named: "dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let belongDot = UIImageView().then {
        $0.image = UIImage(named: "dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let VerificationDot = UIImageView().then {
        $0.image = UIImage(named: "dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let arrowView = UIImageView().then {
        $0.image = UIImage(named: "down-arrow")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Label
    private let titleLabel = UILabel().then {
        $0.text = "먼저 학력 인증을 진행할게요"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let subtitlelabel = UILabel().then {
        $0.text = "현재 소속을 선택하고 인증으로 넘어가 주세요"
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.numberOfLines = 0
    }
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let belongLabel = UILabel().then {
        $0.text = "현재 소속"
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let VerificationLabel = UILabel().then {
        $0.text = "학력 인증"
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    
    // MARK: - TextField
    private let nameTextField = UITextField().then {
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
        
        $0.backgroundColor = .gray50
        $0.textColor = .gray500
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
    }
    
    // MARK: - Button
    private let belongSelectButton = UIButton().then {
        $0.setTitle("현재 소속을 선택해 주세요", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.contentHorizontalAlignment = .left
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        $0.backgroundColor = .gray50
        $0.setTitleColor(.gray500, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.frame.size.width = 342
        $0.frame.size.height = 44
        $0.layer.addBorder([.bottom], color: .gray300, width: 0.5)
        $0.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
        
    }
    private let VerificationButton = UIButton().then {
        $0.setImage(UIImage(named: "Verification-off"), for: .normal)
        $0.addTarget(self, action: #selector(VerificationButtonTapped), for: .touchUpInside)
        $0.isEnabled = false
    }
    
    // MARK: - view
    private let containerView = UIView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpNavigationBar()
        setDropDown()
        setDropDownUI()
        setupViews()
        setupLayout()
    }
    
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "회원가입"
    }
    
    // MARK: - Screen transition
    @objc private func VerificationButtonTapped() {
        let SecondAcademicVerificationVC = SecondAcademicVerificationViewController()
        self.navigationController?.pushViewController(SecondAcademicVerificationVC, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    // MARK: - functional
    
    // MARK: - DropDown
    @objc func showDropDown() {
        dropDown.show()
    }
    
    private func setDropDownUI() {
        DropDown.appearance().backgroundColor = .gray50
        DropDown.appearance().selectedTextColor = .orange700
        DropDown.appearance().selectionBackgroundColor = .orange50
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 14)!
        DropDown.appearance().shadowColor = UIColor.clear
        DropDown.appearance().shadowOffset = CGSize(width: 0, height: 0)
        DropDown.appearance().shadowRadius = 0
        DropDown.appearance().separatorColor = .gray300
    }
    
    private func setDropDown() {
        dropDown.dataSource = itemList
        dropDown.anchorView = belongSelectButton
        dropDown.bottomOffset = CGPointMake(0, belongSelectButton.bounds.height)
        
        dropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            self.belongSelectButton.setTitle(item, for: .normal)
            self.VerificationButton.setImage(UIImage(named: "Verification-on"), for: .normal)
            self.VerificationButton.isEnabled = true
            self.arrowView.image = UIImage(named: "down-arrow")
        }
        
        dropDown.willShowAction = {
            self.arrowView.image = UIImage(named: "up-arrow")
        }
        dropDown.cancelAction = {
            self.arrowView.image = UIImage(named: "down-arrow")
        }
        
    }
    // MARK: - addView
    func setupViews() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitlelabel)
        
        view.addSubview(containerView)
        view.addSubview(progressBar)
        
        view.addSubview(nameLabel)
        view.addSubview(nameDot)
        view.addSubview(nameTextField)
        view.addSubview(belongLabel)
        view.addSubview(belongDot)
        view.addSubview(belongSelectButton)
        view.addSubview(arrowView)
        
        view.addSubview(VerificationLabel)
        view.addSubview(VerificationDot)
        view.addSubview(VerificationButton)
    }
    
    // MARK: - setLayout
    func setupLayout() {
        let leftPadding = 24
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(82)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalToSuperview().inset(20)
        }
        
        subtitlelabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        progressBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(containerView.snp.bottom).offset(8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(progressBar.snp.bottom).offset(40)
        }
        
        nameDot.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top)
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(leftPadding)
            make.height.equalTo(44)
        }
        
        belongLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
        }
        
        belongDot.snp.makeConstraints { make in
            make.top.equalTo(belongLabel.snp.top)
            make.leading.equalTo(belongLabel.snp.trailing).offset(4)
        }
        
        belongSelectButton.snp.makeConstraints { make in
            make.top.equalTo(belongLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        arrowView.snp.makeConstraints { make in
            make.centerY.equalTo(belongSelectButton)
            make.trailing.equalTo(belongSelectButton.snp.trailing).offset(-12)
        }
        VerificationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(belongSelectButton.snp.bottom).offset(20)
        }
        
        VerificationDot.snp.makeConstraints { make in
            make.top.equalTo(VerificationLabel.snp.top)
            make.leading.equalTo(VerificationLabel.snp.trailing).offset(4)
        }
        
        VerificationButton.snp.makeConstraints { make in
            make.top.equalTo(VerificationLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(leftPadding)
            make.height.equalTo(92)
        }
        
    }
    
}

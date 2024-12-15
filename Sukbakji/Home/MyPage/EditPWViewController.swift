//
//  EditPWViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit
import Then
import SnapKit

class EditPWViewController: UIViewController {
    
    private let currentPWLabel = UILabel().then {
        $0.text = "현재 비밀번호"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let dotImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Dot")
    }
    private let currentPWTextField = UITextField().then {
       $0.backgroundColor = .gray100
        $0.placeholder = "현재 비밀번호를 입력해 주세요"
        $0.setPlaceholderColor(UIColor(hexCode: "9F9F9F"))
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .black
    }
    private let eyeButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
    }
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
    }
    private let warningImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    private let warningPWLabel = UILabel().then {
        $0.text = "현재 비밀번호와 일치하지 않습니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = UIColor(hexCode: "FF4A4A")
    }
    private let newPWLabel = UILabel().then {
        $0.text = "새로운 비밀번호"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let newPWTextField = UITextField().then {
       $0.backgroundColor = .gray100
        $0.placeholder = "새로운 비밀번호를 입력해 주세요"
        $0.setPlaceholderColor(UIColor(hexCode: "9F9F9F"))
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .black
    }
    private let eyeButton2 = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
    }
    private let deleteButton2 = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
    }
    private let warningImageView2 = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    private let warningPWLabel2 = UILabel().then {
        $0.text = "비밀번호는 6자리 이상 입력해야 합니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = UIColor(hexCode: "FF4A4A")
    }
    private let newPWAgainLabel = UILabel().then {
        $0.text = "새로운 비밀번호 확인"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let newPWAgainTextField = UITextField().then {
       $0.backgroundColor = .gray100
        $0.placeholder = "새로운 비밀번호를 입력해 주세요"
        $0.setPlaceholderColor(UIColor(hexCode: "9F9F9F"))
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .black
    }
    private let eyeButton3 = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
    }
    private let deleteButton3 = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
    }
    private let warningImageView3 = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    private let warningPWLabel3 = UILabel().then {
        $0.text = "입력한 비밀번호와 일치하지 않습니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = UIColor(hexCode: "FF4A4A")
    }
    private lazy var forgetPWLabel = UILabel().then {
        $0.text = "비밀번호가 기억나지 않는다면?"
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .gray500
    }
    private lazy var findPWButton = UIButton().then {
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setTitleColor(.gray600, for: .normal)
    }
    private lazy var pwStackView = UIStackView().then {
        $0.addArrangedSubview(forgetPWLabel)
        $0.addArrangedSubview(findPWButton)
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    private let changeButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8

        $0.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
        $0.setTitle("비밀번호 변경하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(UIColor(hexCode: "EFEFEF"), for: .normal)
    }
    
    private var userPW: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        hideKeyboardWhenTappedAround()
        getUserPW()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    func getUserPW() {
        if let retrievedData = KeychainHelper.standard.read(service: "password", account: "user", type: String.self) {
            userPW = retrievedData
        } else {
            print("Failed to retrieve password.")
        }
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(currentPWLabel)
        currentPWLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(66)
            make.leading.equalToSuperview().offset(24)
           make.height.equalTo(21)
        }
        
        self.view.addSubview(dotImageView)
        dotImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(66)
            make.leading.equalTo(currentPWLabel.snp.trailing).offset(4)
            make.height.width.equalTo(4)
        }
        
        self.view.addSubview(currentPWTextField)
        currentPWTextField.snp.makeConstraints { make in
            make.top.equalTo(currentPWLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        currentPWTextField.isSecureTextEntry = true
        currentPWTextField.addTFUnderline()
        currentPWTextField.setLeftPadding(10)
        currentPWTextField.errorfix()
        currentPWTextField.addTarget(self, action: #selector(currentPWRegex), for: .editingChanged)
        currentPWTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        
        self.view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(currentPWTextField)
            make.trailing.equalToSuperview().inset(28)
            make.height.width.equalTo(25)
        }
        deleteButton.isHidden = true
        deleteButton.addTarget(self, action: #selector(delete_CurrentPW), for: .touchUpInside)
        
        self.view.addSubview(eyeButton)
        eyeButton.snp.makeConstraints { make in
            make.centerY.equalTo(currentPWTextField)
            make.trailing.equalTo(deleteButton.snp.leading)
            make.height.width.equalTo(25)
        }
        eyeButton.isHidden = true
        eyeButton.addTarget(self, action: #selector(show_currentPW), for: .touchUpInside)
        
        self.view.addSubview(warningImageView)
        warningImageView.snp.makeConstraints { make in
            make.top.equalTo(currentPWTextField.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(24)
            make.height.width.equalTo(12)
        }
        warningImageView.isHidden = true
        
        self.view.addSubview(warningPWLabel)
        warningPWLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPWTextField.snp.bottom).offset(5)
            make.leading.equalTo(warningImageView.snp.trailing).offset(4)
            make.height.equalTo(12)
        }
        warningPWLabel.isHidden = true
        
        self.view.addSubview(newPWLabel)
        newPWLabel.snp.makeConstraints { make in
            make.top.equalTo(warningImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
           make.height.equalTo(21)
        }
        newPWLabel.addImageAboveLabel(referenceView: warningImageView, spacing: 20)
        
        self.view.addSubview(newPWTextField)
        newPWTextField.snp.makeConstraints { make in
            make.top.equalTo(newPWLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        newPWTextField.isSecureTextEntry = true
        newPWTextField.addTFUnderline()
        newPWTextField.setLeftPadding(10)
        newPWTextField.errorfix()
        newPWTextField.addTarget(self, action: #selector(newPWRegex(_:)), for: .editingChanged)
        newPWTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        
        self.view.addSubview(deleteButton2)
        deleteButton2.snp.makeConstraints { make in
            make.centerY.equalTo(newPWTextField)
            make.trailing.equalToSuperview().inset(28)
            make.height.width.equalTo(25)
        }
        deleteButton2.isHidden = true
        deleteButton2.addTarget(self, action: #selector(delete_NewPW), for: .touchUpInside)
        
        self.view.addSubview(eyeButton2)
        eyeButton2.snp.makeConstraints { make in
            make.centerY.equalTo(newPWTextField)
            make.trailing.equalTo(deleteButton2.snp.leading)
            make.height.width.equalTo(25)
        }
        eyeButton2.isHidden = true
        eyeButton2.addTarget(self, action: #selector(show_newPW), for: .touchUpInside)
        
        self.view.addSubview(warningImageView2)
        warningImageView2.snp.makeConstraints { make in
            make.top.equalTo(newPWTextField.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(24)
            make.height.width.equalTo(12)
        }
        warningImageView2.isHidden = true
        
        self.view.addSubview(warningPWLabel2)
        warningPWLabel2.snp.makeConstraints { make in
            make.top.equalTo(newPWTextField.snp.bottom).offset(5)
            make.leading.equalTo(warningImageView2.snp.trailing).offset(4)
            make.height.equalTo(12)
        }
        warningPWLabel2.isHidden = true
        
        self.view.addSubview(newPWAgainLabel)
        newPWAgainLabel.snp.makeConstraints { make in
            make.top.equalTo(warningImageView2.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
           make.height.equalTo(21)
        }
        newPWAgainLabel.addImageAboveLabel(referenceView: warningImageView2, spacing: 20)
        
        self.view.addSubview(newPWAgainTextField)
        newPWAgainTextField.snp.makeConstraints { make in
            make.top.equalTo(newPWAgainLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        newPWAgainTextField.isSecureTextEntry = true
        newPWAgainTextField.addTFUnderline()
        newPWAgainTextField.setLeftPadding(10)
        newPWAgainTextField.errorfix()
        newPWAgainTextField.addTarget(self, action: #selector(newPWAgainRegex), for: .editingChanged)
        newPWAgainTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        
        self.view.addSubview(deleteButton3)
        deleteButton3.snp.makeConstraints { make in
            make.centerY.equalTo(newPWAgainTextField)
            make.trailing.equalToSuperview().inset(28)
            make.height.width.equalTo(25)
        }
        deleteButton3.isHidden = true
        deleteButton3.addTarget(self, action: #selector(delete_NewAgainPW), for: .touchUpInside)
        
        self.view.addSubview(eyeButton3)
        eyeButton3.snp.makeConstraints { make in
            make.centerY.equalTo(newPWAgainTextField)
            make.trailing.equalTo(deleteButton3.snp.leading)
            make.height.width.equalTo(25)
        }
        eyeButton3.isHidden = true
        eyeButton3.addTarget(self, action: #selector(show_newAgainPW), for: .touchUpInside)
        
        self.view.addSubview(warningImageView3)
        warningImageView3.snp.makeConstraints { make in
            make.top.equalTo(newPWAgainTextField.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(24)
            make.height.width.equalTo(12)
        }
        warningImageView3.isHidden = true
        
        self.view.addSubview(warningPWLabel3)
        warningPWLabel3.snp.makeConstraints { make in
            make.top.equalTo(newPWAgainTextField.snp.bottom).offset(5)
            make.leading.equalTo(warningImageView3.snp.trailing).offset(4)
            make.height.equalTo(12)
        }
        warningPWLabel3.isHidden = true
        
        self.view.addSubview(pwStackView)
        pwStackView.snp.makeConstraints { make in
            make.top.equalTo(warningImageView3.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        self.view.addSubview(changeButton)
        changeButton.snp.makeConstraints { make in
            make.top.equalTo(pwStackView.snp.bottom).offset(120)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        changeButton.addTarget(self, action: #selector(change_Tapped), for: .touchUpInside)
    }
    
    @objc func textFieldEdited(_ textField: UITextField) {
        updateButtonColor()
    }
        
    private func updateButtonColor() {
        if (currentPWTextField.text == userPW) && (isValidPW(testStr: newPWTextField.text)) && (newPWAgainTextField.text == newPWTextField.text) {
            changeButton.isEnabled = true
            changeButton.setBackgroundColor(UIColor(named: "Coquelicot")!, for:.normal)
            changeButton.setTitleColor(.white, for: .normal)
        } else {
            changeButton.isEnabled = false
            changeButton.setBackgroundColor(UIColor(hexCode: "EFEFEF"), for: .normal)
            changeButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
        }
    }
    
    private func isValidPW(testStr: String?) -> Bool{
        let regex = "^.{6,}$"
        let pwTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return pwTest.evaluate(with: testStr)
    }
    
    @objc func currentPWRegex(_ textField: UITextField) {
        if (currentPWTextField.text == "\(userPW ?? "")") {
            eyeButton.isHidden = true
            deleteButton.isHidden = true
            warningImageView.isHidden = true
            warningPWLabel.isHidden = true
            eyeButton.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
            eyeButton.setImage(UIImage(named: "Sukbakji_PW_noView"), for: .selected)
            deleteButton.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
            currentPWTextField.backgroundColor = UIColor(hexCode: "FAFAFA")
            currentPWTextField.updateUnderlineColor(to: UIColor(hexCode: "E1E1E1"))
        } else {
            eyeButton.isHidden = false
            deleteButton.isHidden = false
            warningImageView.isHidden = false
            warningPWLabel.isHidden = false
            eyeButton.setImage(UIImage(named: "Sukbakji_PWView"), for: .normal)
            eyeButton.setImage(UIImage(named: "Sukbakji_PWnoView"), for: .selected)
            deleteButton.setImage(UIImage(named: "Sukbakji_PWDelete"), for: .normal)
            currentPWTextField.backgroundColor = UIColor(hexCode: "FFEBEE")
            currentPWTextField.updateUnderlineColor(to: UIColor(hexCode: "FF4A4A"))
        }
        
        UIView.animate(withDuration: 0.1) { // 효과 주기
                self.view.layoutIfNeeded()
        }
    }
    
    @objc func newPWRegex(_ textField: UITextField) {
        if isValidPW(testStr: textField.text) {
            eyeButton2.isHidden = true
            deleteButton2.isHidden = true
            warningImageView2.isHidden = true
            warningPWLabel2.isHidden = true
            eyeButton2.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
            eyeButton2.setImage(UIImage(named: "Sukbakji_PW_noView"), for: .selected)
            deleteButton2.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
            newPWTextField.backgroundColor = UIColor(hexCode: "FAFAFA")
            newPWTextField.updateUnderlineColor(to: UIColor(hexCode: "E1E1E1"))
        }
        else {
            eyeButton2.isHidden = false
            deleteButton2.isHidden = false
            warningImageView2.isHidden = false
            warningPWLabel2.isHidden = false
            eyeButton2.setImage(UIImage(named: "Sukbakji_PWView"), for: .normal)
            eyeButton2.setImage(UIImage(named: "Sukbakji_PWnoView"), for: .selected)
            deleteButton2.setImage(UIImage(named: "Sukbakji_PWDelete"), for: .normal)
            newPWTextField.backgroundColor = UIColor(hexCode: "FFEBEE")
            newPWTextField.updateUnderlineColor(to: UIColor(hexCode: "FF4A4A"))
        }
        
        UIView.animate(withDuration: 0.1) { // 효과 주기
                self.view.layoutIfNeeded()
        }
    }
    
    @objc func newPWAgainRegex(_ textField: UITextField) {
        if (newPWAgainTextField.text == newPWTextField.text) {
            eyeButton3.isHidden = true
            deleteButton3.isHidden = true
            warningImageView3.isHidden = true
            warningPWLabel3.isHidden = true
            eyeButton3.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
            eyeButton3.setImage(UIImage(named: "Sukbakji_PW_noView"), for: .selected)
            deleteButton3.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
            newPWAgainTextField.backgroundColor = UIColor(hexCode: "FAFAFA")
            newPWAgainTextField.updateUnderlineColor(to: UIColor(hexCode: "E1E1E1"))
        } else {
            eyeButton3.isHidden = false
            deleteButton3.isHidden = false
            warningImageView3.isHidden = false
            warningPWLabel3.isHidden = false
            eyeButton3.setImage(UIImage(named: "Sukbakji_PWView"), for: .normal)
            eyeButton3.setImage(UIImage(named: "Sukbakji_PWnoView"), for: .selected)
            deleteButton3.setImage(UIImage(named: "Sukbakji_PWDelete"), for: .normal)
            newPWAgainTextField.backgroundColor = UIColor(hexCode: "FFEBEE")
            newPWAgainTextField.updateUnderlineColor(to: UIColor(hexCode: "FF4A4A"))
        }
        
        UIView.animate(withDuration: 0.1) { // 효과 주기
                self.view.layoutIfNeeded()
        }
    }
    
    @objc private func show_currentPW() {
        currentPWTextField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
        if eyeButton.image(for: .normal) == UIImage(named: "Sukbakji_PW_View") {
            let eyeImage = eyeButton.isSelected ? "Sukbakji_PW_noView" : "Sukbakji_PW_View"
            eyeButton.setImage(UIImage(named: eyeImage), for: .selected)
        } else if eyeButton.image(for: .selected) == UIImage(named: "Sukbakji_PW_noView") {
            let eyeImage = eyeButton.isSelected ? "Sukbakji_PW_View" : "Sukbakji_PW_noView"
            eyeButton.setImage(UIImage(named: eyeImage), for: .normal)
        } else if eyeButton.image(for: .normal) == UIImage(named: "Sukbakji_PWView") {
            let eyeImage = eyeButton.isSelected ? "Sukbakji_PWnoView" : "Sukbakji_PWView"
            eyeButton.setImage(UIImage(named: eyeImage), for: .selected)
        } else if eyeButton.image(for: .selected) == UIImage(named: "Sukbakji_PWnoView") {
            let eyeImage = eyeButton.isSelected ? "Sukbakji_PWView" : "Sukbakji_PWnoView"
            eyeButton.setImage(UIImage(named: eyeImage), for: .normal)
        }
        eyeButton.tintColor = .clear
    }
    
    @objc private func show_newPW() {
        newPWTextField.isSecureTextEntry.toggle()
        eyeButton2.isSelected.toggle()
        if eyeButton2.image(for: .normal) == UIImage(named: "Sukbakji_PW_View") {
            let eyeImage = eyeButton2.isSelected ? "Sukbakji_PW_noView" : "Sukbakji_PW_View"
            eyeButton2.setImage(UIImage(named: eyeImage), for: .selected)
        } else if eyeButton2.image(for: .selected) == UIImage(named: "Sukbakji_PW_noView") {
            let eyeImage = eyeButton2.isSelected ? "Sukbakji_PW_View" : "Sukbakji_PW_noView"
            eyeButton2.setImage(UIImage(named: eyeImage), for: .normal)
        } else if eyeButton2.image(for: .normal) == UIImage(named: "Sukbakji_PWView") {
            let eyeImage = eyeButton2.isSelected ? "Sukbakji_PWnoView" : "Sukbakji_PWView"
            eyeButton2.setImage(UIImage(named: eyeImage), for: .selected)
        } else if eyeButton2.image(for: .selected) == UIImage(named: "Sukbakji_PWnoView") {
            let eyeImage = eyeButton2.isSelected ? "Sukbakji_PWView" : "Sukbakji_PWnoView"
            eyeButton2.setImage(UIImage(named: eyeImage), for: .normal)
        }
        eyeButton2.tintColor = .clear
    }
    
    @objc private func show_newAgainPW() {
        newPWAgainTextField.isSecureTextEntry.toggle()
        eyeButton3.isSelected.toggle()
        if eyeButton3.image(for: .normal) == UIImage(named: "Sukbakji_PW_View") {
            let eyeImage = eyeButton3.isSelected ? "Sukbakji_PW_noView" : "Sukbakji_PW_View"
            eyeButton3.setImage(UIImage(named: eyeImage), for: .selected)
        } else if eyeButton3.image(for: .selected) == UIImage(named: "Sukbakji_PW_noView") {
            let eyeImage = eyeButton3.isSelected ? "Sukbakji_PW_View" : "Sukbakji_PW_noView"
            eyeButton3.setImage(UIImage(named: eyeImage), for: .normal)
        } else if eyeButton3.image(for: .normal) == UIImage(named: "Sukbakji_PWView") {
            let eyeImage = eyeButton3.isSelected ? "Sukbakji_PWnoView" : "Sukbakji_PWView"
            eyeButton3.setImage(UIImage(named: eyeImage), for: .selected)
        } else if eyeButton3.image(for: .selected) == UIImage(named: "Sukbakji_PWnoView") {
            let eyeImage = eyeButton3.isSelected ? "Sukbakji_PWView" : "Sukbakji_PWnoView"
            eyeButton3.setImage(UIImage(named: eyeImage), for: .normal)
        }
        eyeButton3.tintColor = .clear
    }

    @objc private func delete_CurrentPW() {
        currentPWTextField.text = ""
    }
    
    @objc private func delete_NewPW() {
        newPWTextField.text = ""
    }
    
    @objc private func delete_NewAgainPW() {
        newPWAgainTextField.text = ""
    }
    
    private func changePWAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.userPassword.path
        
        let params = [
            "currentPassword": self.currentPWTextField.text ?? "",
            "newPassword": self.newPWTextField.text ?? "",
            "confirmPassword": self.newPWAgainTextField.text ?? "",
        ] as [String : Any]
        
        APIService().postWithAccessToken(of: APIResponse<String>.self, url: url, parameters: params, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                print("비밀번호 변경이 정상적으로 처리되었습니다.")
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    private func logOutAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.authLogout.path
        
        APIService().postWithAccessToken(of: APIResponse<String>.self, url: url, parameters: nil, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                print("로그아웃이 정상적으로 처리되었습니다.")
                AlertController(message: "로그아웃 하시겠어요?", isCancel: true) {
                    let LoginVC = UINavigationController(rootViewController: LoginViewController())
                    SceneDelegate().setRootViewController(LoginVC)
                    self.navigationController?.popToRootViewController(animated: true)
                }.show()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    @objc private func change_Tapped() {
        changePWAPI()
        logOutAPI()
    }
}

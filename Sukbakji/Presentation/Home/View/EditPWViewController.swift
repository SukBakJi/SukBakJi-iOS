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
    
    private let currentPWView = UIView().then {
        $0.backgroundColor = .white
    }
    private let currentPWLabel = UILabel().then {
        $0.text = "현재 비밀번호"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let dotImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Dot")
    }
    private let currentPWTextField = UITextField().then {
       $0.backgroundColor = .gray50
        $0.placeholder = "현재 비밀번호를 입력해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
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
        $0.textColor = .warning400
    }
    private let newPWView = UIView().then {
        $0.backgroundColor = .white
    }
    private let newPWLabel = UILabel().then {
        $0.text = "새로운 비밀번호"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let newPWTextField = UITextField().then {
       $0.backgroundColor = .gray50
        $0.placeholder = "새로운 비밀번호를 입력해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
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
        $0.textColor = .warning400
    }
    private let newPWAgainView = UIView().then {
        $0.backgroundColor = .white
    }
    private let newPWAgainLabel = UILabel().then {
        $0.text = "새로운 비밀번호 확인"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    private let newPWAgainTextField = UITextField().then {
       $0.backgroundColor = .gray50
        $0.placeholder = "새로운 비밀번호를 입력해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
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
        $0.textColor = .warning400
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

        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitle("비밀번호 변경하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.gray200, for: .normal)
    }
    
    private var currentPWViewheightConstraint: Constraint?
    private var newPWViewheightConstraint: Constraint?
    private var newPWAgainViewheightConstraint: Constraint?
    
    private var userPW: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        hideKeyboardWhenTappedAround()
        getUserPW()
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
        
        self.view.addSubview(currentPWView)
        currentPWView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(46)
            make.leading.trailing.equalToSuperview()
            currentPWViewheightConstraint = make.height.equalTo(99).constraint
        }
        
        self.currentPWView.addSubview(currentPWLabel)
        currentPWLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.currentPWView.addSubview(dotImageView)
        dotImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(currentPWLabel.snp.trailing).offset(4)
            make.height.width.equalTo(4)
        }
        
        self.currentPWView.addSubview(currentPWTextField)
        currentPWTextField.snp.makeConstraints { make in
            make.top.equalTo(currentPWLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        currentPWTextField.isSecureTextEntry = true
        currentPWTextField.addTFUnderline()
        currentPWTextField.setLeftPadding(15)
        currentPWTextField.errorfix()
        currentPWTextField.addTarget(self, action: #selector(currentPWRegex), for: .editingChanged)
        currentPWTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        
        self.currentPWView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(currentPWTextField)
            make.trailing.equalToSuperview().inset(28)
            make.height.width.equalTo(25)
        }
        deleteButton.isHidden = true
        deleteButton.addTarget(self, action: #selector(delete_CurrentPW), for: .touchUpInside)
        
        self.currentPWView.addSubview(eyeButton)
        eyeButton.snp.makeConstraints { make in
            make.centerY.equalTo(currentPWTextField)
            make.trailing.equalTo(deleteButton.snp.leading)
            make.height.width.equalTo(25)
        }
        eyeButton.isHidden = true
        eyeButton.addTarget(self, action: #selector(show_currentPW), for: .touchUpInside)
        
        self.currentPWView.addSubview(warningImageView)
        warningImageView.snp.makeConstraints { make in
            make.top.equalTo(currentPWTextField.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(24)
            make.height.width.equalTo(12)
        }
        warningImageView.isHidden = true
        
        self.currentPWView.addSubview(warningPWLabel)
        warningPWLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPWTextField.snp.bottom).offset(5)
            make.leading.equalTo(warningImageView.snp.trailing).offset(4)
            make.height.equalTo(12)
        }
        warningPWLabel.isHidden = true
        
        self.view.addSubview(newPWView)
        newPWView.snp.makeConstraints { make in
            make.top.equalTo(currentPWView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            newPWViewheightConstraint = make.height.equalTo(99).constraint
        }
        
        self.newPWView.addSubview(newPWLabel)
        newPWLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        newPWLabel.addImageAboveLabel(referenceView: currentPWView, spacing: 20)
        
        self.newPWView.addSubview(newPWTextField)
        newPWTextField.snp.makeConstraints { make in
            make.top.equalTo(newPWLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        newPWTextField.isSecureTextEntry = true
        newPWTextField.addTFUnderline()
        newPWTextField.setLeftPadding(15)
        newPWTextField.errorfix()
        newPWTextField.addTarget(self, action: #selector(newPWRegex(_:)), for: .editingChanged)
        newPWTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        
        self.newPWView.addSubview(deleteButton2)
        deleteButton2.snp.makeConstraints { make in
            make.centerY.equalTo(newPWTextField)
            make.trailing.equalToSuperview().inset(28)
            make.height.width.equalTo(25)
        }
        deleteButton2.isHidden = true
        deleteButton2.addTarget(self, action: #selector(delete_NewPW), for: .touchUpInside)
        
        self.newPWView.addSubview(eyeButton2)
        eyeButton2.snp.makeConstraints { make in
            make.centerY.equalTo(newPWTextField)
            make.trailing.equalTo(deleteButton2.snp.leading)
            make.height.width.equalTo(25)
        }
        eyeButton2.isHidden = true
        eyeButton2.addTarget(self, action: #selector(show_newPW), for: .touchUpInside)
        
        self.newPWView.addSubview(warningImageView2)
        warningImageView2.snp.makeConstraints { make in
            make.top.equalTo(newPWTextField.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(24)
            make.height.width.equalTo(12)
        }
        warningImageView2.isHidden = true
        
        self.newPWView.addSubview(warningPWLabel2)
        warningPWLabel2.snp.makeConstraints { make in
            make.top.equalTo(newPWTextField.snp.bottom).offset(5)
            make.leading.equalTo(warningImageView2.snp.trailing).offset(4)
            make.height.equalTo(12)
        }
        warningPWLabel2.isHidden = true
        
        self.view.addSubview(newPWAgainView)
        newPWAgainView.snp.makeConstraints { make in
            make.top.equalTo(newPWView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            newPWAgainViewheightConstraint = make.height.equalTo(99).constraint
        }
        
        self.newPWAgainView.addSubview(newPWAgainLabel)
        newPWAgainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        newPWAgainLabel.addImageAboveLabel(referenceView: newPWView, spacing: 20)
        
        self.newPWAgainView.addSubview(newPWAgainTextField)
        newPWAgainTextField.snp.makeConstraints { make in
            make.top.equalTo(newPWAgainLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        newPWAgainTextField.isSecureTextEntry = true
        newPWAgainTextField.addTFUnderline()
        newPWAgainTextField.setLeftPadding(15)
        newPWAgainTextField.errorfix()
        newPWAgainTextField.addTarget(self, action: #selector(newPWAgainRegex), for: .editingChanged)
        newPWAgainTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        
        self.newPWAgainView.addSubview(deleteButton3)
        deleteButton3.snp.makeConstraints { make in
            make.centerY.equalTo(newPWAgainTextField)
            make.trailing.equalToSuperview().inset(28)
            make.height.width.equalTo(25)
        }
        deleteButton3.isHidden = true
        deleteButton3.addTarget(self, action: #selector(delete_NewAgainPW), for: .touchUpInside)
        
        self.newPWAgainView.addSubview(eyeButton3)
        eyeButton3.snp.makeConstraints { make in
            make.centerY.equalTo(newPWAgainTextField)
            make.trailing.equalTo(deleteButton3.snp.leading)
            make.height.width.equalTo(25)
        }
        eyeButton3.isHidden = true
        eyeButton3.addTarget(self, action: #selector(show_newAgainPW), for: .touchUpInside)
        
        self.newPWAgainView.addSubview(warningImageView3)
        warningImageView3.snp.makeConstraints { make in
            make.top.equalTo(newPWAgainTextField.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(24)
            make.height.width.equalTo(12)
        }
        warningImageView3.isHidden = true
        
        self.newPWAgainView.addSubview(warningPWLabel3)
        warningPWLabel3.snp.makeConstraints { make in
            make.top.equalTo(newPWAgainTextField.snp.bottom).offset(5)
            make.leading.equalTo(warningImageView3.snp.trailing).offset(4)
            make.height.equalTo(12)
        }
        warningPWLabel3.isHidden = true
        
        self.view.addSubview(pwStackView)
        pwStackView.snp.makeConstraints { make in
            make.top.equalTo(newPWAgainView.snp.bottom).offset(48)
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
            changeButton.setBackgroundColor(.orange700, for:.normal)
            changeButton.setTitleColor(.white, for: .normal)
        } else {
            changeButton.isEnabled = false
            changeButton.setBackgroundColor(.gray500, for: .normal)
            changeButton.setTitleColor(.gray200, for: .normal)
        }
    }
    
    private func isValidPW(testStr: String?) -> Bool{
        let regex = "^.{6,}$"
        let pwTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return pwTest.evaluate(with: testStr)
    }
    
    struct PasswordFieldComponents {
        let textField: UITextField
        let eyeButton: UIButton
        let deleteButton: UIButton
        let warningImageView: UIImageView
        let warningLabel: UILabel
    }
    
    private func updatePasswordFieldAppearance(isValid: Bool, components: PasswordFieldComponents, heightConstraint: Constraint?) {
        components.eyeButton.isHidden = false
        components.deleteButton.isHidden = false
        components.warningImageView.isHidden = isValid
        components.warningLabel.isHidden = isValid

        heightConstraint?.update(offset: isValid ? 99 : 115)

        let eyeImage = UIImage(named: isValid ? "Sukbakji_PW_View" : "Sukbakji_PWView")
        let eyeSelectedImage = UIImage(named: isValid ? "Sukbakji_PW_noView" : "Sukbakji_PWnoView")
        let deleteImage = UIImage(named: isValid ? "Sukbakji_PW_Delete" : "Sukbakji_PWDelete")
        
        components.eyeButton.setImage(eyeImage, for: .normal)
        components.eyeButton.setImage(eyeSelectedImage, for: .selected)
        components.deleteButton.setImage(deleteImage, for: .normal)

        components.textField.backgroundColor = isValid ? .gray50 : .warning50
        components.textField.updateUnderlineColor(to: isValid ? .gray300 : .warning400)

        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func currentPWRegex(_ textField: UITextField) {
        let isValid = currentPWTextField.text == "\(userPW ?? "")"
        let components = PasswordFieldComponents(
            textField: currentPWTextField,
            eyeButton: eyeButton,
            deleteButton: deleteButton,
            warningImageView: warningImageView,
            warningLabel: warningPWLabel
        )
        updatePasswordFieldAppearance(isValid: isValid, components: components, heightConstraint: currentPWViewheightConstraint)
    }

    @objc func newPWRegex(_ textField: UITextField) {
        let isValid = isValidPW(testStr: textField.text)
        let components = PasswordFieldComponents(
            textField: newPWTextField,
            eyeButton: eyeButton2,
            deleteButton: deleteButton2,
            warningImageView: warningImageView2,
            warningLabel: warningPWLabel2
        )
        updatePasswordFieldAppearance(isValid: isValid, components: components, heightConstraint: newPWViewheightConstraint)
    }

    @objc func newPWAgainRegex(_ textField: UITextField) {
        let isValid = newPWAgainTextField.text == newPWTextField.text
        let components = PasswordFieldComponents(
            textField: newPWAgainTextField,
            eyeButton: eyeButton3,
            deleteButton: deleteButton3,
            warningImageView: warningImageView3,
            warningLabel: warningPWLabel3
        )
        updatePasswordFieldAppearance(isValid: isValid, components: components, heightConstraint: newPWAgainViewheightConstraint)
    }
    
    private func togglePasswordVisibility(for textField: UITextField, eyeButton: UIButton) {
        textField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
        
        let eyeImageNormal: String
        let eyeImageSelected: String
        
        if eyeButton.image(for: .normal) == UIImage(named: "Sukbakji_PW_View") || eyeButton.image(for: .selected) == UIImage(named: "Sukbakji_PW_noView"){
            eyeImageNormal = "Sukbakji_PW_View"
            eyeImageSelected = "Sukbakji_PW_noView"
        } else {
            eyeImageNormal = "Sukbakji_PWView"
            eyeImageSelected = "Sukbakji_PWnoView"
        }
        
        let newImage = eyeButton.isSelected ? eyeImageSelected : eyeImageNormal
        eyeButton.setImage(UIImage(named: newImage), for: .normal)
        eyeButton.setImage(UIImage(named: newImage), for: .selected)
        
        eyeButton.tintColor = .clear
    }

    @objc private func show_currentPW() {
        togglePasswordVisibility(for: currentPWTextField, eyeButton: eyeButton)
    }

    @objc private func show_newPW() {
        togglePasswordVisibility(for: newPWTextField, eyeButton: eyeButton2)
    }

    @objc private func show_newAgainPW() {
        togglePasswordVisibility(for: newPWAgainTextField, eyeButton: eyeButton3)
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

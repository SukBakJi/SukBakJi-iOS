//
//  EditPWViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit
import SnapKit
import RxSwift

class EditPWViewController: UIViewController {
    
    private let editPWView = EditPWView()
    private let viewModel = MyProfileViewModel()
    private let disposeBag = DisposeBag()
    
    private var currentPWViewheightConstraint: Constraint?
    private var newPWViewheightConstraint: Constraint?
    private var newPWAgainViewheightConstraint: Constraint?
    private var userPW: String?
    
    override func loadView() {
        self.view = editPWView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        hideKeyboardWhenTappedAround()
        bindViewModel()
        getUserPW()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
}
    
extension EditPWViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        editPWView.currentPWView.snp.makeConstraints { make in
            currentPWViewheightConstraint = make.height.equalTo(99).constraint
        }
        editPWView.currentPWTextField.addTarget(self, action: #selector(currentPWRegex), for: .editingChanged)
        editPWView.currentPWTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        
        editPWView.newPWView.snp.makeConstraints { make in
            newPWViewheightConstraint = make.height.equalTo(99).constraint
        }
        editPWView.newPWTextField.addTarget(self, action: #selector(newPWRegex(_:)), for: .editingChanged)
        editPWView.newPWTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
    
        editPWView.newPWAgainView.snp.makeConstraints { make in
            newPWAgainViewheightConstraint = make.height.equalTo(99).constraint
        }
        editPWView.newPWAgainTextField.addTarget(self, action: #selector(newPWAgainRegex), for: .editingChanged)
        editPWView.newPWAgainTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
    }

    private func getUserPW() {
        if let retrievedData = KeychainHelper.standard.read(service: "password", account: "user") {
            userPW = retrievedData
        } else {
            print("Failed to retrieve password.")
        }
    }
    
    private func updateButtonColor() {
        let isFormValid = ((editPWView.currentPWTextField.text == userPW) && (isValidPW(testStr: editPWView.newPWTextField.text)) && (editPWView.newPWAgainTextField.text == editPWView.newPWTextField.text))
        editPWView.changeButton.isEnabled = isFormValid
        editPWView.changeButton.setBackgroundColor(isFormValid ? .orange700 : .gray200, for: .normal)
        editPWView.changeButton.setTitleColor(isFormValid ? .white : .gray500, for: .normal)
    }
    
    private func isValidPW(testStr: String?) -> Bool{
        let regex = "^.{6,}$"
        let pwTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return pwTest.evaluate(with: testStr)
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
        let isValid = editPWView.currentPWTextField.text == "\(userPW ?? "")"
        let components = PasswordFieldComponents(
            textField: editPWView.currentPWTextField,
            eyeButton: editPWView.eyeButton,
            deleteButton: editPWView.deleteButton,
            warningImageView: editPWView.warningImageView,
            warningLabel: editPWView.warningPWLabel
        )
        updatePasswordFieldAppearance(isValid: isValid, components: components, heightConstraint: currentPWViewheightConstraint)
    }
    
    @objc func newPWRegex(_ textField: UITextField) {
        let isValid = isValidPW(testStr: textField.text)
        let components = PasswordFieldComponents(
            textField: editPWView.newPWTextField,
            eyeButton: editPWView.eyeButton2,
            deleteButton: editPWView.deleteButton2,
            warningImageView: editPWView.warningImageView2,
            warningLabel: editPWView.warningPWLabel2
        )
        updatePasswordFieldAppearance(isValid: isValid, components: components, heightConstraint: newPWViewheightConstraint)
    }
    
    @objc func newPWAgainRegex(_ textField: UITextField) {
        let isValid = editPWView.newPWAgainTextField.text == editPWView.newPWTextField.text
        let components = PasswordFieldComponents(
            textField: editPWView.newPWAgainTextField,
            eyeButton: editPWView.eyeButton3,
            deleteButton: editPWView.deleteButton3,
            warningImageView: editPWView.warningImageView3,
            warningLabel: editPWView.warningPWLabel3
        )
        updatePasswordFieldAppearance(isValid: isValid, components: components, heightConstraint: newPWAgainViewheightConstraint)
    }
}

extension EditPWViewController {
    
    private func bindViewModel() {
        editPWView.newPWTextField.rx.text.orEmpty
            .bind(to: viewModel.newPWInput)
            .disposed(by: disposeBag)
        
        editPWView.newPWAgainTextField.rx.text.orEmpty
            .bind(to: viewModel.confirmPWInput)
            .disposed(by: disposeBag)
        
        editPWView.changeButton.rx.tap
            .bind { [weak self] in
                self?.showLogoutAlert()
            }
            .disposed(by: disposeBag)
        
        viewModel.pwChanged
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isSuccess in
                if isSuccess {
                    self?.navigateToLogin()
                } else {
                    AlertController(message: "비밀번호를 변경에 실패했습니다. 다시 시도해주세요.").show()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showLogoutAlert() {
        AlertController(message: "비밀번호를 변경하시겠어요?", isCancel: true) { [weak self] in
            self?.viewModel.loadChangePW()
            self?.viewModel.loadLogOut()
        }.show()
    }
    
    private func navigateToLogin() {
        let loginVC = UINavigationController(rootViewController: LoginViewController())
        SceneDelegate().setRootViewController(loginVC)
    }
    
    @objc func textFieldEdited(_ textField: UITextField) {
        updateButtonColor()
    }
}

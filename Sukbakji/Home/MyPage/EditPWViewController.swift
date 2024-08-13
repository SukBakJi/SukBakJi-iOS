//
//  EditPWViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit

class EditPWViewController: UIViewController {
    
    @IBOutlet weak var currentPWTF: UITextField!
    @IBOutlet weak var newPWTF: UITextField!
    @IBOutlet weak var newPWAgainTF: UITextField!
    
    @IBOutlet weak var currentPWView: UIStackView!
    @IBOutlet weak var newPWView: UIStackView!
    @IBOutlet weak var newPWAgainView: UIStackView!
    
    @IBOutlet weak var currentPWEye: UIButton!
    @IBOutlet weak var currentPWDelete: UIButton!
    @IBOutlet weak var newPWEye: UIButton!
    @IBOutlet weak var newPWDelete: UIButton!
    @IBOutlet weak var newPWAgainEye: UIButton!
    @IBOutlet weak var newPWAgainDelete: UIButton!
    
    @IBOutlet weak var setButton: UIButton!
    
    private var userPW: String?
    
    private var PWData: ChangePWResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPWTF.addBottomShadow()
        newPWTF.addBottomShadow()
        newPWAgainTF.addBottomShadow()
        currentPWTF.setLeftPadding(10)
        newPWTF.setLeftPadding(10)
        newPWAgainTF.setLeftPadding(10)
        currentPWTF.errorfix()
        newPWTF.errorfix()
        newPWAgainTF.errorfix()
        
        settingButton()
        
        currentPWView.isHidden = true
        newPWView.isHidden = true
        newPWAgainView.isHidden = true
        currentPWTF.addTarget(self, action: #selector(currentPWRegex), for: .editingChanged)
        newPWTF.addTarget(self, action: #selector(newPWRegex(_:)), for: .editingChanged)
        newPWAgainTF.addTarget(self, action: #selector(newPWAgainRegex), for: .editingChanged)
        
        currentPWTF.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        newPWTF.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        newPWAgainTF.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        
        getUserPW()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentPWTF.errorfix()
        newPWTF.errorfix()
        newPWAgainTF.errorfix()
    }
    
    func getUserPW() {
        if let retrievedData = KeychainHelper.standard.read(service: "password", account: "user", type: String.self),
           let retrievedPW = String(data: retrievedData, encoding: .utf8) {
            userPW = retrievedPW
            print("Password retrieved and stored in userPW: \(userPW ?? "")")
        } else {
            print("Failed to retrieve password.")
        }
    }
    
    func settingButton() {
        setButton.isEnabled = false
        setButton.layer.masksToBounds = true
        setButton.layer.cornerRadius = 10
        setButton.backgroundColor = UIColor(hexCode: "EFEFEF")
        setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
    }
    
    @objc func textFieldEdited(_ textField: UITextField) {
        updateButtonColor()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 텍스트 필드 내용이 변경될 때 버튼 색깔 업데이트
        DispatchQueue.main.async {
            self.updateButtonColor()
        }
        return true
    }
        
    func updateButtonColor() {
        if (currentPWTF.text == "123456") && (isValidPW(testStr: newPWTF.text)) && (newPWAgainTF.text == newPWTF.text) {
            setButton.isEnabled = true
            setButton.backgroundColor = UIColor(named: "Coquelicot")
            setButton.setTitleColor(.white, for: .normal)
            setButton.setTitleColor(.white, for: .selected)
        } else {
            setButton.isEnabled = false
            setButton.backgroundColor = UIColor(hexCode: "EFEFEF")
            setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
            setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .selected)
        }
    }
    
    func isValidPW(testStr: String?) -> Bool{
        let regex = "^.{6,}$"
        let pwTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return pwTest.evaluate(with: testStr)
    }
    
    @objc func currentPWRegex(_ textField: UITextField) {
        if (currentPWTF.text == "123456") {
            currentPWView.isHidden = true
            currentPWEye.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
            currentPWEye.setImage(UIImage(named: "Sukbakji_PW_noView"), for: .selected)
            currentPWDelete.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
            currentPWTF.backgroundColor = UIColor(hexCode: "FAFAFA")
            currentPWTF.addBottomShadow()
        }
        else {
            currentPWEye.isEnabled = true
            currentPWDelete.isEnabled = true
            currentPWEye.isHidden = false
            currentPWDelete.isHidden = false
            currentPWView.isHidden = false
            currentPWEye.setImage(UIImage(named: "Sukbakji_PWView"), for: .normal)
            currentPWEye.setImage(UIImage(named: "Sukbakji_PWnoView"), for: .selected)
            currentPWDelete.setImage(UIImage(named: "Sukbakji_PWDelete"), for: .normal)
            currentPWTF.backgroundColor = UIColor(hexCode: "FFEBEE")
            currentPWTF.addPWBottomShadow()
        }
        
        UIView.animate(withDuration: 0.1) { // 효과 주기
                self.view.layoutIfNeeded()
        }
    }
    
    @objc func newPWRegex(_ textField: UITextField) {
        
        if isValidPW(testStr: textField.text) {
            newPWView.isHidden = true
            newPWEye.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
            newPWEye.setImage(UIImage(named: "Sukbakji_PW_noView"), for: .selected)
            newPWDelete.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
            newPWTF.backgroundColor = UIColor(hexCode: "FAFAFA")
            newPWTF.addBottomShadow()
        }
        else {
            newPWEye.isEnabled = true
            newPWDelete.isEnabled = true
            newPWEye.isHidden = false
            newPWDelete.isHidden = false
            newPWView.isHidden = false
            newPWEye.setImage(UIImage(named: "Sukbakji_PWView"), for: .normal)
            newPWEye.setImage(UIImage(named: "Sukbakji_PWnoView"), for: .selected)
            newPWDelete.setImage(UIImage(named: "Sukbakji_PWDelete"), for: .normal)
            newPWTF.backgroundColor = UIColor(hexCode: "FFEBEE")
            newPWTF.addPWBottomShadow()
        }
        
        UIView.animate(withDuration: 0.1) { // 효과 주기
                self.view.layoutIfNeeded()
        }
    }
    
    @objc func newPWAgainRegex(_ textField: UITextField) {
        
        if (newPWAgainTF.text == newPWTF.text) {
            newPWAgainView.isHidden = true
            newPWAgainEye.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
            newPWAgainEye.setImage(UIImage(named: "Sukbakji_PW_noView"), for: .selected)
            newPWAgainDelete.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
            newPWAgainTF.backgroundColor = UIColor(hexCode: "FAFAFA")
            newPWAgainTF.addBottomShadow()
        }
        else {
            newPWAgainEye.isEnabled = true
            newPWAgainDelete.isEnabled = true
            newPWAgainEye.isHidden = false
            newPWAgainDelete.isHidden = false
            newPWAgainView.isHidden = false
            newPWAgainEye.setImage(UIImage(named: "Sukbakji_PWView"), for: .normal)
            newPWAgainEye.setImage(UIImage(named: "Sukbakji_PWnoView"), for: .selected)
            newPWAgainDelete.setImage(UIImage(named: "Sukbakji_PWDelete"), for: .normal)
            newPWAgainTF.backgroundColor = UIColor(hexCode: "FFEBEE")
            newPWAgainTF.addPWBottomShadow()
        }
        
        UIView.animate(withDuration: 0.1) { // 효과 주기
                self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func Show_currentPW(_ sender: Any) {
        currentPWTF.isSecureTextEntry.toggle()
        currentPWEye.isSelected.toggle()
        if currentPWEye.image(for: .normal) == UIImage(named: "Sukbakji_PW_View") {
            let eyeImage = currentPWEye.isSelected ? "Sukbakji_PW_noView" : "Sukbakji_PW_View"
            currentPWEye.setImage(UIImage(named: eyeImage), for: .selected)
        } else if currentPWEye.image(for: .selected) == UIImage(named: "Sukbakji_PW_noView") {
            let eyeImage = currentPWEye.isSelected ? "Sukbakji_PW_View" : "Sukbakji_PW_noView"
            currentPWEye.setImage(UIImage(named: eyeImage), for: .normal)
        } else if currentPWEye.image(for: .normal) == UIImage(named: "Sukbakji_PWView") {
            let eyeImage = currentPWEye.isSelected ? "Sukbakji_PWnoView" : "Sukbakji_PWView"
            currentPWEye.setImage(UIImage(named: eyeImage), for: .selected)
        } else if currentPWEye.image(for: .selected) == UIImage(named: "Sukbakji_PWnoView") {
            let eyeImage = currentPWEye.isSelected ? "Sukbakji_PWView" : "Sukbakji_PWnoView"
            currentPWEye.setImage(UIImage(named: eyeImage), for: .normal)
        }
        currentPWEye.tintColor = .clear
    }
    
    @IBAction func Show_newPW(_ sender: Any) {
        newPWTF.isSecureTextEntry.toggle()
        newPWEye.isSelected.toggle()
        if newPWEye.image(for: .normal) == UIImage(named: "Sukbakji_PW_View") {
            let eyeImage = newPWEye.isSelected ? "Sukbakji_PW_noView" : "Sukbakji_PW_View"
            newPWEye.setImage(UIImage(named: eyeImage), for: .selected)
        } else if newPWEye.image(for: .selected) == UIImage(named: "Sukbakji_PW_noView") {
            let eyeImage = newPWEye.isSelected ? "Sukbakji_PW_View" : "Sukbakji_PW_noView"
            newPWEye.setImage(UIImage(named: eyeImage), for: .normal)
        } else if newPWEye.image(for: .normal) == UIImage(named: "Sukbakji_PWView") {
            let eyeImage = newPWEye.isSelected ? "Sukbakji_PWnoView" : "Sukbakji_PWView"
            newPWEye.setImage(UIImage(named: eyeImage), for: .selected)
        } else if newPWEye.image(for: .selected) == UIImage(named: "Sukbakji_PWnoView") {
            let eyeImage = newPWEye.isSelected ? "Sukbakji_PWView" : "Sukbakji_PWnoView"
            newPWEye.setImage(UIImage(named: eyeImage), for: .normal)
        }
        newPWEye.tintColor = .clear
    }
    
    @IBAction func Show_newPWAgain(_ sender: Any) {
        newPWAgainTF.isSecureTextEntry.toggle()
        newPWAgainEye.isSelected.toggle()
        if newPWAgainEye.image(for: .normal) == UIImage(named: "Sukbakji_PW_View") {
            let eyeImage = newPWAgainEye.isSelected ? "Sukbakji_PW_noView" : "Sukbakji_PW_View"
            newPWAgainEye.setImage(UIImage(named: eyeImage), for: .selected)
        } else if newPWAgainEye.image(for: .selected) == UIImage(named: "Sukbakji_PW_noView") {
            let eyeImage = newPWAgainEye.isSelected ? "Sukbakji_PW_View" : "Sukbakji_PW_noView"
            newPWAgainEye.setImage(UIImage(named: eyeImage), for: .normal)
        } else if newPWAgainEye.image(for: .normal) == UIImage(named: "Sukbakji_PWView") {
            let eyeImage = newPWAgainEye.isSelected ? "Sukbakji_PWnoView" : "Sukbakji_PWView"
            newPWAgainEye.setImage(UIImage(named: eyeImage), for: .selected)
        } else if newPWAgainEye.image(for: .selected) == UIImage(named: "Sukbakji_PWnoView") {
            let eyeImage = newPWAgainEye.isSelected ? "Sukbakji_PWView" : "Sukbakji_PWnoView"
            newPWAgainEye.setImage(UIImage(named: eyeImage), for: .normal)
        }
        newPWAgainEye.tintColor = .clear
    }
    
    @IBAction func currentPW_Delete(_ sender: Any) {
        currentPWTF.text = ""
    }
    
    @IBAction func newPW_Delete(_ sender: Any) {
        newPWTF.text = ""
    }
    
    @IBAction func newPWAgain_Delete(_ sender: Any) {
        newPWAgainTF.text = ""
    }
    
    @IBAction func change_Tapped(_ sender: Any) {
        let parameters = ChangePWModel(currentPassword: currentPWTF.text ?? "", newPassword: newPWTF.text ?? "", confirmPassword: newPWAgainTF.text ?? "")
        APIChangePWPost.instance.SendingChangePW(parameters: parameters) { result in self.PWData = result }
        self.presentingViewController?.dismiss(animated: true)
    }
}

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
        
        currentPWView.isHidden = true
        newPWView.isHidden = true
        newPWAgainView.isHidden = true
        currentPWTF.addTarget(self, action: #selector(currentPWRegex), for: .editingChanged)
        newPWTF.addTarget(self, action: #selector(newPWRegex(_:)), for: .editingChanged)
        newPWAgainTF.addTarget(self, action: #selector(newPWAgainRegex), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentPWTF.errorfix()
        newPWTF.errorfix()
        newPWAgainTF.errorfix()
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
}

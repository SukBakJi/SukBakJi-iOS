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
       $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(hexCode: "E1E1E1")
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
       $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(hexCode: "E1E1E1")
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
       $0.backgroundColor = .gray50
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(hexCode: "E1E1E1")
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
    private let editButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8

        $0.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
        $0.setTitle("비밀번호 변경하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(UIColor(hexCode: "EFEFEF"), for: .normal)
    }
    
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
    
    private var PWData: ChangePW!
    private var logoutData: Logout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextField()
        
        setPWView()
        
        hideKeyboardWhenTappedAround()
        
        getUserPW()
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
        currentPWTextField.addTFUnderline()
        currentPWTextField.setLeftPadding(10)
        
        self.view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(currentPWTextField)
            make.trailing.equalToSuperview().inset(28)
            make.height.width.equalTo(25)
        }
        
        self.view.addSubview(eyeButton)
        eyeButton.snp.makeConstraints { make in
            make.centerY.equalTo(currentPWTextField)
            make.trailing.equalTo(deleteButton.snp.leading)
            make.height.width.equalTo(25)
        }
    }
    
    func setTextField() {
        currentPWTF.addTFUnderline()
        newPWTF.addTFUnderline()
        newPWAgainTF.addTFUnderline()
        currentPWTF.setLeftPadding(10)
        newPWTF.setLeftPadding(10)
        newPWAgainTF.setLeftPadding(10)
        currentPWTF.errorfix()
        newPWTF.errorfix()
        newPWAgainTF.errorfix()
    }
    
    func setPWView() {
        currentPWView.isHidden = true
        newPWView.isHidden = true
        newPWAgainView.isHidden = true
        
        currentPWTF.addTarget(self, action: #selector(currentPWRegex), for: .editingChanged)
        newPWTF.addTarget(self, action: #selector(newPWRegex(_:)), for: .editingChanged)
        newPWAgainTF.addTarget(self, action: #selector(newPWAgainRegex), for: .editingChanged)
        
        currentPWTF.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        newPWTF.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        newPWAgainTF.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
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
    
    @objc func textFieldEdited(_ textField: UITextField) {
        updateButtonColor()
    }
        
    private func updateButtonColor() {
        if (currentPWTextField.text == userPW) && (isValidPW(testStr: newPWTextField.text)) && (newPWAgainTextField.text == newPWTextField.text) {
            editButton.isEnabled = true
            editButton.setBackgroundColor(UIColor(named: "Coquelicot")!, for:.normal)
            editButton.setTitleColor(.white, for: .normal)
        } else {
            editButton.isEnabled = false
            editButton.setBackgroundColor(UIColor(hexCode: "EFEFEF"), for: .normal)
            editButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
        }
    }
    
    private func isValidPW(testStr: String?) -> Bool{
        let regex = "^.{6,}$"
        let pwTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return pwTest.evaluate(with: testStr)
    }
    
    @objc func currentPWRegex(_ textField: UITextField) {
        if (currentPWTF.text == "\(userPW ?? "")") {
            currentPWView.isHidden = true
            currentPWEye.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
            currentPWEye.setImage(UIImage(named: "Sukbakji_PW_noView"), for: .selected)
            currentPWDelete.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
            currentPWTF.backgroundColor = UIColor(hexCode: "FAFAFA")
            currentPWTF.addTFUnderline()
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
            currentPWTF.addTFRedUnderline()
        }
        
        UIView.animate(withDuration: 0.1) { // 효과 주기
                self.view.layoutIfNeeded()
        }
    }
    
    @objc func newPWRegex(_ textField: UITextField) {
//        if isValidPW(testStr: textField.text) {
//            newPWView.isHidden = true
//            newPWEye.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
//            newPWEye.setImage(UIImage(named: "Sukbakji_PW_noView"), for: .selected)
//            newPWDelete.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
//            newPWTF.backgroundColor = UIColor(hexCode: "FAFAFA")
//            newPWTF.addTFUnderline()
//        }
//        else {
//            newPWEye.isEnabled = true
//            newPWDelete.isEnabled = true
//            newPWEye.isHidden = false
//            newPWDelete.isHidden = false
//            newPWView.isHidden = false
//            newPWEye.setImage(UIImage(named: "Sukbakji_PWView"), for: .normal)
//            newPWEye.setImage(UIImage(named: "Sukbakji_PWnoView"), for: .selected)
//            newPWDelete.setImage(UIImage(named: "Sukbakji_PWDelete"), for: .normal)
//            newPWTF.backgroundColor = UIColor(hexCode: "FFEBEE")
//            newPWTF.addTFRedUnderline()
//        }
//        
//        UIView.animate(withDuration: 0.1) { // 효과 주기
//                self.view.layoutIfNeeded()
//        }
    }
    
    @objc func newPWAgainRegex(_ textField: UITextField) {
//        if (newPWAgainTF.text == newPWTF.text) {
//            newPWAgainView.isHidden = true
//            newPWAgainEye.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
//            newPWAgainEye.setImage(UIImage(named: "Sukbakji_PW_noView"), for: .selected)
//            newPWAgainDelete.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
//            newPWAgainTF.backgroundColor = UIColor(hexCode: "FAFAFA")
//            newPWAgainTF.addTFUnderline()
//        }
//        else {
//            newPWAgainEye.isEnabled = true
//            newPWAgainDelete.isEnabled = true
//            newPWAgainEye.isHidden = false
//            newPWAgainDelete.isHidden = false
//            newPWAgainView.isHidden = false
//            newPWAgainEye.setImage(UIImage(named: "Sukbakji_PWView"), for: .normal)
//            newPWAgainEye.setImage(UIImage(named: "Sukbakji_PWnoView"), for: .selected)
//            newPWAgainDelete.setImage(UIImage(named: "Sukbakji_PWDelete"), for: .normal)
//            newPWAgainTF.backgroundColor = UIColor(hexCode: "FFEBEE")
//            newPWAgainTF.addTFRedUnderline()
//        }
//        
//        UIView.animate(withDuration: 0.1) { // 효과 주기
//                self.view.layoutIfNeeded()
//        }
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
        let pwParameters = ChangePW(currentPassword: currentPWTF.text ?? "", newPassword: newPWTF.text ?? "", confirmPassword: newPWAgainTF.text ?? "")
        APIChangePWPost.instance.SendingChangePW(parameters: pwParameters) { result in self.PWData = result }
        let LoginVC = UINavigationController(rootViewController: LoginViewController())
        SceneDelegate().setRootViewController(LoginVC)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

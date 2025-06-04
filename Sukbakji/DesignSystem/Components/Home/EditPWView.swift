//
//  EditPWView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/20/25.
//

import UIKit
import SnapKit
import Then

class EditPWView: UIView {
    
    let currentPWView = UIView().then {
        $0.backgroundColor = .white
    }
    let currentPWLabel = UILabel().then {
        $0.text = "현재 비밀번호"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let dotImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Dot")
    }
    let currentPWTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "현재 비밀번호를 입력해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let eyeButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
    }
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
    }
    let warningImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningPWLabel = UILabel().then {
        $0.text = "현재 비밀번호와 일치하지 않습니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    let newPWView = UIView().then {
        $0.backgroundColor = .white
    }
    let newPWLabel = UILabel().then {
        $0.text = "새로운 비밀번호"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let newPWTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "새로운 비밀번호를 입력해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let eyeButton2 = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
    }
    let deleteButton2 = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
    }
    let warningImageView2 = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningPWLabel2 = UILabel().then {
        $0.text = "비밀번호는 6자리 이상 입력해야 합니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    let newPWAgainView = UIView().then {
        $0.backgroundColor = .white
    }
    let newPWAgainLabel = UILabel().then {
        $0.text = "새로운 비밀번호 확인"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let newPWAgainTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "새로운 비밀번호를 입력해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let eyeButton3 = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_PW_View"), for: .normal)
    }
    let deleteButton3 = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_PW_Delete"), for: .normal)
    }
    let warningImageView3 = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningPWLabel3 = UILabel().then {
        $0.text = "입력한 비밀번호와 일치하지 않습니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    lazy var forgetPWLabel = UILabel().then {
        $0.text = "비밀번호가 기억나지 않는다면?"
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .gray500
    }
    lazy var findPWButton = UIButton().then {
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setTitleColor(.gray600, for: .normal)
    }
    lazy var pwStackView = UIStackView().then {
        $0.addArrangedSubview(forgetPWLabel)
        $0.addArrangedSubview(findPWButton)
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    let changeButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitle("비밀번호 변경하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.gray200, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(currentPWView)
        currentPWView.addSubview(currentPWLabel)
        currentPWView.addSubview(dotImageView)
        currentPWView.addSubview(currentPWTextField)
        currentPWView.addSubview(deleteButton)
        currentPWView.addSubview(eyeButton)
        currentPWView.addSubview(warningImageView)
        currentPWView.addSubview(warningPWLabel)
        
        addSubview(newPWView)
        newPWView.addSubview(newPWLabel)
        newPWView.addSubview(newPWTextField)
        newPWView.addSubview(deleteButton2)
        newPWView.addSubview(eyeButton2)
        newPWView.addSubview(warningImageView2)
        newPWView.addSubview(warningPWLabel2)
        
        addSubview(newPWAgainView)
        newPWAgainView.addSubview(newPWAgainLabel)
        newPWAgainView.addSubview(newPWAgainTextField)
        newPWAgainView.addSubview(deleteButton3)
        newPWAgainView.addSubview(eyeButton3)
        newPWAgainView.addSubview(warningImageView3)
        newPWAgainView.addSubview(warningPWLabel3)
        
        addSubview(pwStackView)
        addSubview(changeButton)
    }
    
    private func setupConstraints() {
        currentPWView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(46)
            $0.leading.trailing.equalToSuperview()
        }
        
        currentPWLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        dotImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(currentPWLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(4)
        }
        
        currentPWTextField.snp.makeConstraints {
            $0.top.equalTo(currentPWLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        currentPWTextField.isSecureTextEntry = true
        currentPWTextField.addTFUnderline()
        currentPWTextField.setLeftPadding(16)
        currentPWTextField.errorfix()
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(currentPWTextField)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.width.equalTo(25)
        }
        deleteButton.addTarget(self, action: #selector(delete_CurrentPW), for: .touchUpInside)
        deleteButton.isHidden = true
        
        eyeButton.snp.makeConstraints {
            $0.centerY.equalTo(currentPWTextField)
            $0.trailing.equalTo(deleteButton.snp.leading)
            $0.height.width.equalTo(25)
        }
        eyeButton.addTarget(self, action: #selector(show_currentPW), for: .touchUpInside)
        eyeButton.isHidden = true
        
        warningImageView.snp.makeConstraints {
            $0.top.equalTo(currentPWTextField.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(24)
            $0.height.width.equalTo(12)
        }
        warningImageView.isHidden = true
        
        warningPWLabel.snp.makeConstraints {
            $0.top.equalTo(currentPWTextField.snp.bottom).offset(5)
            $0.leading.equalTo(warningImageView.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningPWLabel.isHidden = true
        
        newPWView.snp.makeConstraints {
            $0.top.equalTo(currentPWView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        newPWLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        newPWLabel.addImageAboveLabel(referenceView: currentPWView, spacing: 20)
        
        newPWTextField.snp.makeConstraints {
            $0.top.equalTo(newPWLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        newPWTextField.isSecureTextEntry = true
        newPWTextField.addTFUnderline()
        newPWTextField.setLeftPadding(16)
        newPWTextField.errorfix()
        
        deleteButton2.snp.makeConstraints {
            $0.centerY.equalTo(newPWTextField)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.width.equalTo(25)
        }
        deleteButton2.addTarget(self, action: #selector(delete_NewPW), for: .touchUpInside)
        deleteButton2.isHidden = true
        
        eyeButton2.snp.makeConstraints {
            $0.centerY.equalTo(newPWTextField)
            $0.trailing.equalTo(deleteButton2.snp.leading)
            $0.height.width.equalTo(25)
        }
        eyeButton2.addTarget(self, action: #selector(show_newPW), for: .touchUpInside)
        eyeButton2.isHidden = true
        
        warningImageView2.snp.makeConstraints {
            $0.top.equalTo(newPWTextField.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(24)
            $0.height.width.equalTo(12)
        }
        warningImageView2.isHidden = true
        
        warningPWLabel2.snp.makeConstraints {
            $0.top.equalTo(newPWTextField.snp.bottom).offset(5)
            $0.leading.equalTo(warningImageView2.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningPWLabel2.isHidden = true
        
        newPWAgainView.snp.makeConstraints {
            $0.top.equalTo(newPWView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        newPWAgainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        newPWAgainLabel.addImageAboveLabel(referenceView: newPWView, spacing: 20)
        
        newPWAgainTextField.snp.makeConstraints {
            $0.top.equalTo(newPWAgainLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        newPWAgainTextField.isSecureTextEntry = true
        newPWAgainTextField.addTFUnderline()
        newPWAgainTextField.setLeftPadding(16)
        newPWAgainTextField.errorfix()
        
        deleteButton3.snp.makeConstraints {
            $0.centerY.equalTo(newPWAgainTextField)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.width.equalTo(25)
        }
        deleteButton3.addTarget(self, action: #selector(delete_NewAgainPW), for: .touchUpInside)
        deleteButton3.isHidden = true
        
        eyeButton3.snp.makeConstraints {
            $0.centerY.equalTo(newPWAgainTextField)
            $0.trailing.equalTo(deleteButton3.snp.leading)
            $0.height.width.equalTo(25)
        }
        eyeButton3.addTarget(self, action: #selector(show_newAgainPW), for: .touchUpInside)
        eyeButton3.isHidden = true
        
        warningImageView3.snp.makeConstraints {
            $0.top.equalTo(newPWAgainTextField.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(24)
            $0.height.width.equalTo(12)
        }
        warningImageView3.isHidden = true
        
        warningPWLabel3.snp.makeConstraints {
            $0.top.equalTo(newPWAgainTextField.snp.bottom).offset(5)
            $0.leading.equalTo(warningImageView3.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningPWLabel3.isHidden = true
        
        pwStackView.snp.makeConstraints {
            $0.top.equalTo(newPWAgainView.snp.bottom).offset(48)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        changeButton.snp.makeConstraints {
            $0.top.equalTo(pwStackView.snp.bottom).offset(120)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
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
}

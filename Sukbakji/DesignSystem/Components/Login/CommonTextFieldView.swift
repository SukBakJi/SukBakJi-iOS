//
//  CommonTextFieldView.swift
//  Sukbakji
//
//  Created by 오현민 on 3/5/25.
//

import UIKit

class CommonTextFieldView: UIView {
    //MARK: - Properties
    private var isPassword: Bool = false
    var validationHandler: ((String?) -> Bool)? /// 유효성 검사 핸들러
    private var stateViewHeightConstraint: NSLayoutConstraint!

    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        stateView.isHidden = true
        rightView.isHidden = true

        setView()
        setConstraints()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    //MARK: - SetText
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func setPlaceholder(_ text: String) {
        textField.placeholder = text
    }
    
    func setErrorMessage(_ text: String) {
        stateLabel.text = text
    }
    
    //MARK: - SetState
    /// 비밀번호 필드인지 구분
    func setPasswordTF() {
        textField.isSecureTextEntry = true
        eyeButton.isHidden = false
    }
    
    func setErrorState(_ isError: Bool) {
        stateView.isHidden = !isError
        if isError {
            textField.setErrorState()
            clearButton.setImage(UIImage(named: "SBJ_clear-red"), for: .normal)
            eyeButton.setImage(UIImage(named: "SBJ_Password-hidden-red"), for: .normal)
            eyeButton.setImage(UIImage(named: "SBJ_Password-shown-red"), for: .selected)
            
            stateViewHeightConstraint.constant = 20
        } else {
            textField.setNormalState()
            clearButton.setImage(UIImage(named: "SBJ_clear"), for: .normal)
            eyeButton.setImage(UIImage(named: "SBJ_Password-hidden"), for: .normal)
            eyeButton.setImage(UIImage(named: "SBJ_Password-shown"), for: .selected)
            
            stateViewHeightConstraint.constant = 0
        }
    }
    
    //MARK: - Functional
    private func addTargets() {
        clearButton.addTarget(self, action: #selector(clearButtonDidTap), for: .touchUpInside)
        eyeButton.addTarget(self, action: #selector(eyeButtonDidTap), for: .touchUpInside)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
    }
    
    @objc
    private func clearButtonDidTap() {
        textField.text = ""
    }
    
    @objc
    private func eyeButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            textField.isSecureTextEntry = false
        } else {
            textField.isSecureTextEntry = true
        }
    }
    
    /// 사용자가 입력할 때마다 검사
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let validationHandler = validationHandler else { return }
        let isValid = validationHandler(textField.text)
        setErrorState(!isValid)
    }

    /// 포커스를 잃었을 때 검사
    @objc
    private func textFieldDidEndEditing(_ textField: UITextField) {
        textField.updateUnderlineColor(to: .gray300)
        rightView.isHidden = true

        guard let validationHandler = validationHandler else { return }
        let isValid = validationHandler(textField.text)
        setErrorState(!isValid)
    }
    
    @objc
    private func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.updateUnderlineColor(to: .blue400)
        rightView.isHidden = false
    }
    
    func validation(textField: CommonTextFieldView, regex: String, errorMessage: String, emptyErrorMessage: String) {
        textField.validationHandler = { text in
            guard let text = text, !text.isEmpty else {
                textField.setErrorMessage(emptyErrorMessage)
                return false
            }
            
            let regex = regex
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)

            let isValid = predicate.evaluate(with: text)
            
            if !isValid {
                textField.setErrorMessage(errorMessage)
            }
            
            return isValid
        }
    }
    
    //MARK: - Components
    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    
    private lazy var dotImage = UIImageView().then {
        $0.image = UIImage(named: "SBJ_dot-badge")
        $0.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 4, height: 4))
        }
    }
    
    private lazy var textField = UITextField().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.clearButtonMode = .never
        
        $0.setNormalState()
        $0.setLeftPadding(16)
        $0.errorfix()
        $0.setTFStyle()
    }
    
    private lazy var rightView: UIStackView = makeStack(axis: .horizontal, spacing: 8)
    
    private lazy var clearButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_clear"), for: .normal)
        $0.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 12, height: 12))
        }
    }
    
    private lazy var eyeButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_Password-hidden"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_Password-shown"), for: .selected)
        $0.isHidden = true
        $0.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 12, height: 12))
        }
    }
    
    private lazy var stateView: UIStackView = makeStack(axis: .horizontal, spacing: 4)
    
    private lazy var stateIcon = UIImageView().then {
        $0.image = UIImage(named: "SBJ_ErrorCircle")
        $0.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 12, height: 12))
        }
    }
    
    private lazy var stateLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textAlignment = .left
        $0.textColor = .warning400
    }
    
    private func makeStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
            let stack = UIStackView()
            stack.axis = axis
            stack.spacing = spacing
            stack.distribution = .fill
            stack.alignment = .center
            return stack
        }
    
    
    //MARK: - SetUI
    private func setView() {
        self.addSubviews([titleLabel, dotImage, textField, rightView, stateView])
        
        rightView.addArrangedSubViews([eyeButton, clearButton])
        stateView.addArrangedSubViews([stateIcon, stateLabel])
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        dotImage.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        rightView.snp.makeConstraints {
            $0.centerY.equalTo(textField)
            $0.trailing.equalTo(textField.snp.trailing).inset(12)
        }
        
        stateView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(4)
            $0.leading.equalTo(textField.snp.leading).offset(4)
            $0.bottom.equalToSuperview()
        }
        
        stateViewHeightConstraint = stateView.heightAnchor.constraint(equalToConstant: 0)
        stateViewHeightConstraint.isActive = true
    }
}

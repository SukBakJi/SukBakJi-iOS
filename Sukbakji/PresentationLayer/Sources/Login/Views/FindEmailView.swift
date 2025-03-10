//
//  FindView.swift
//  Sukbakji
//
//  Created by 오현민 on 2/28/25.
//

import UIKit
import SnapKit

class FindEmailView: UIView {
    //MARK: - Properties
    var textFieldChanged: (() -> Void)? // 입력값 변경 이벤트 전달용 클로저
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setView()
        setConstraints()
        addTargets()
        setDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functional
    @objc
    private func textFieldDidChange() {
        textFieldChanged?() // 입력값이 변경될 때 VC에 이벤트 전달
    }
    
    private func addTargets() {
        nameTF.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        phoneNumTF.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setDelegates() {
        nameTF.textField.delegate = self
        phoneNumTF.textField.delegate = self
    }
    
    private func makeStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
            let stack = UIStackView()
            stack.axis = axis
            stack.spacing = spacing
            stack.distribution = .fill
            return stack
        }
    
    //MARK: - Components
    private lazy var TFView = makeStack(axis: .vertical, spacing: 8)
    public var nameTF = CommonTextFieldView().then {
        $0.setTitle("이름")
        $0.setPlaceholder("이름을 입력해 주세요")
    }
    public var phoneNumTF = CommonTextFieldView().then {
        $0.setTitle("전화번호")
        $0.setPlaceholder("전화번호를 입력해 주세요")
    }
    
    public var nextButton = OrangeButton(title: "이메일 찾기", isEnabled: false)
    
    //MARK: - SetUI
    private func setView() {
        addSubviews([TFView, nextButton])
        TFView.addArrangedSubViews([nameTF, phoneNumTF])
    }
    
    private func setConstraints() {
        TFView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(100)
        }
    }
}

extension FindEmailView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumTF.textField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            // 숫자 입력만 허용
            guard allowedCharacters.isSuperset(of: characterSet) else {
                return false
            }
            
            // 현재 텍스트 가져오기
            guard let currentText = textField.text as NSString? else {
                return true
            }
            
            // 변경 후 예상되는 텍스트
            let newText = currentText.replacingCharacters(in: range, with: string)
            
            // 최대 글자수 제한
            return newText.count <= 11
        }
        
        return true // 다른 필드는 제한 없음
    }
}

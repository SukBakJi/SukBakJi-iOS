//
//  BoardCreateViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 6/3/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoardCreateViewController: UIViewController, UITextViewDelegate {
    
    private let boardCreateView = BoardCreateView()
    private var hasStartedEditing = false
    
    private var nameHeightConstraint: Constraint?
    private var noticeHeightConstraint: Constraint?
    
    override func loadView() {
        self.view = boardCreateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        boardCreateView.noticeTextView.delegate = self
        
        boardCreateView.nameView.snp.makeConstraints { make in
            nameHeightConstraint = make.height.equalTo(102).constraint
        }
        boardCreateView.noticeView.snp.makeConstraints { make in
            noticeHeightConstraint = make.height.equalTo(178).constraint
        }
        
        boardCreateView.nameTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        boardCreateView.deleteButton.addTarget(self, action: #selector(textDelete_Tapped), for: .touchUpInside)
    }
}

extension BoardCreateViewController {
    
    @objc func textFieldEdited(_ textField: UITextField) {
        updateButtonColor()
        if boardCreateView.nameTextField.text?.isEmpty == true {
            warningName()
        } else {
            deleteWarningName()
        }
    }
    
    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            self.updateButtonColor()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard !hasStartedEditing else { return }
        hasStartedEditing = true
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: textView, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            let isValid = !(textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            self.updateButtonColor()
            
            if isValid {
                self.deleteWarningNotice()
            } else {
                self.warningNotice()
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: textView)
    }
    
    private func updateButtonColor() {
        let isFormValid = (boardCreateView.nameTextField.text?.isEmpty == false && boardCreateView.noticeTextView.text?.isEmpty == false)
        boardCreateView.makeBoardButton.isEnabled = isFormValid
        boardCreateView.makeBoardButton.setBackgroundColor(isFormValid ? .orange700 : .gray200, for: .normal)
        boardCreateView.makeBoardButton.setTitleColor(isFormValid ? .white : .gray500, for: .normal)
    }
    
    private func warningName() {
        nameHeightConstraint?.update(offset: 118)
        boardCreateView.warningNameImage.isHidden = false
        boardCreateView.warningNameLabel.isHidden = false
        boardCreateView.nameTextField.backgroundColor = .warning50
        boardCreateView.nameTextField.setPlaceholderColor(.warning400)
        boardCreateView.nameTextField.updateUnderlineColor(to: .warning400)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func deleteWarningName() {
        nameHeightConstraint?.update(offset: 102)
        boardCreateView.warningNameImage.isHidden = true
        boardCreateView.warningNameLabel.isHidden = true
        boardCreateView.nameTextField.backgroundColor = .gray50
        boardCreateView.nameTextField.setPlaceholderColor(.gray500)
        boardCreateView.nameTextField.updateUnderlineColor(to: .gray300)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func warningNotice() {
        noticeHeightConstraint?.update(offset: 194)
        boardCreateView.warningNoticeImage.isHidden = false
        boardCreateView.warningNoticeLabel.isHidden = false
        boardCreateView.noticeTextView.backgroundColor = .warning50
        boardCreateView.noticeTextView.textColor = .warning400
        boardCreateView.noticeTextView.updateUnderlineColor(to: .warning400)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func deleteWarningNotice() {
        noticeHeightConstraint?.update(offset: 178)
        boardCreateView.warningNoticeImage.isHidden = true
        boardCreateView.warningNoticeLabel.isHidden = true
        boardCreateView.noticeTextView.backgroundColor = .gray50
        boardCreateView.noticeTextView.textColor = .gray900
        boardCreateView.noticeTextView.updateUnderlineColor(to: .gray300)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    @objc private func textDelete_Tapped() {
        boardCreateView.nameTextField.text = ""
        warningName()
    }
}

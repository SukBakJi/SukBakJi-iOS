//
//  SetAlarmViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 1/5/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import DropDown

class SetAlarmViewController: UIViewController {
    
    private let memberId = UserDefaults.standard.integer(forKey: "memberID")
    private let setAlarmView = SetAlarmView()
    private let alarmViewModel = AlarmViewModel()
    private let alarmDetailViewModel = AlarmDetailViewModel()
    private let disposeBag = DisposeBag()
    private lazy var drop: DropDown = DropDownFactory.make(anchor: setAlarmView.univTextField)
    private var didSetupDropDowns = false
    
    private var univViewHeightConstraint: Constraint?
    private var alarmNameViewHeightConstraint: Constraint?
    
    override func loadView() {
        self.view = setAlarmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAPI()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didSetupDropDowns {
            view.layoutIfNeeded()
            setDropdown()
            didSetupDropDowns = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
}
    
extension SetAlarmViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setAlarmView.navigationbarView.delegate = self
        setAlarmView.univView.snp.makeConstraints { make in
            univViewHeightConstraint = make.height.equalTo(99).constraint
        }
        setAlarmView.alarmNameView.snp.makeConstraints { make in
            alarmNameViewHeightConstraint = make.height.equalTo(99).constraint
        }
        setAlarmView.alarmNameTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        setAlarmView.deleteButton.addTarget(self, action: #selector(textDelete_Tapped), for: .touchUpInside)
        setAlarmView.setButton.addTarget(self, action: #selector(set_Tapped), for: .touchUpInside)
    }
    
    private func setDropdown() {
        drop.selectionAction = { [weak self] (index, item) in
            self?.setAlarmView.univTextField.text = "\(item)"
            self?.updateButtonColor()
            self?.setAlarmView.univTextField.backgroundColor = .gray50
            self?.setAlarmView.univTextField.setPlaceholderColor(.gray500)
            self?.setAlarmView.univTextField.updateUnderlineColor(to: .gray300)
            self?.deleteWarningUnivName()
        }
    }
}

extension SetAlarmViewController {
    
    private func setAPI() {
        bindViewModel()
        alarmViewModel.loadAlarmUniv()
    }
    
    private func bindViewModel() {
        alarmViewModel.univItems
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in self?.drop.dataSource = $0 })
            .disposed(by: disposeBag)
        
        setAlarmView.dropButton.rx.tap
            .bind(onNext: { [weak self] in self?.drop.show() })
            .disposed(by: disposeBag)
    }
    
    @objc func textFieldEdited(_ textField: UITextField) {
        updateButtonColor()
        if setAlarmView.alarmNameTextField.text?.isEmpty == true {
            warningAlarmName()
        } else {
            deleteWarningAlarmName()
        }
    }
    
    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            self.updateButtonColor()
        }
        return true
    }
    
    private func warningUnivName() {
        univViewHeightConstraint?.update(offset: 115)
        setAlarmView.warningImageView.isHidden = false
        setAlarmView.warningUnivLabel.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func deleteWarningUnivName() {
        univViewHeightConstraint?.update(offset: 99)
        setAlarmView.warningImageView.isHidden = true
        setAlarmView.warningUnivLabel.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func warningAlarmName() {
        alarmNameViewHeightConstraint?.update(offset: 115)
        setAlarmView.warningImageView2.isHidden = false
        setAlarmView.warningAlarmNameLabel.isHidden = false
        setAlarmView.alarmNameTextField.backgroundColor = .warning50
        setAlarmView.alarmNameTextField.setPlaceholderColor(.warning400)
        setAlarmView.alarmNameTextField.updateUnderlineColor(to: .warning400)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func deleteWarningAlarmName() {
        alarmNameViewHeightConstraint?.update(offset: 99)
        setAlarmView.warningImageView2.isHidden = true
        setAlarmView.warningAlarmNameLabel.isHidden = true
        setAlarmView.alarmNameTextField.backgroundColor = .gray50
        setAlarmView.alarmNameTextField.setPlaceholderColor(.gray500)
        setAlarmView.alarmNameTextField.updateUnderlineColor(to: .gray300)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func updateButtonColor() {
        let isFormValid = (setAlarmView.univTextField.text?.isEmpty == false && setAlarmView.alarmNameTextField.text?.isEmpty == false)
        setAlarmView.setButton.isEnabled = isFormValid
        setAlarmView.setButton.setBackgroundColor(isFormValid ? .orange700 : .gray200, for: .normal)
        setAlarmView.setButton.setTitleColor(isFormValid ? .white : .gray500, for: .normal)
    }
    
    @objc private func set_Tapped() {
        alarmDetailViewModel.createAlarm(memberId: memberId, univName: setAlarmView.univTextField.text ?? "", name: setAlarmView.alarmNameTextField.text ?? "", date: setAlarmView.dateValue, time: setAlarmView.timeValue)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func textDelete_Tapped() {
        setAlarmView.alarmNameTextField.text = ""
        warningAlarmName()
    }
}

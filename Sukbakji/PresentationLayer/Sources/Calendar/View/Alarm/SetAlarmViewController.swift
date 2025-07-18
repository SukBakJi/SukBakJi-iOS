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
    private let viewModel = AlarmViewModel()
    private let disposeBag = DisposeBag()
    private let drop = DropDown()
    
    private var univViewHeightConstraint: Constraint?
    private var alarmNameViewHeightConstraint: Constraint?
    
    override func loadView() {
        self.view = setAlarmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDrop()
        setAPI()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
}
    
extension SetAlarmViewController {
    
    private func setDrop() {
        initUI()
        setDropdown()
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setAlarmView.navigationbarView.delegate = self
        setAlarmView.univView.snp.makeConstraints { make in
            univViewHeightConstraint = make.height.equalTo(99).constraint
        }
        setAlarmView.alarmNameView.snp.makeConstraints { make in
            alarmNameViewHeightConstraint = make.height.equalTo(99).constraint
        }
        setAlarmView.dropButton.addTarget(self, action: #selector(drop_Tapped), for: .touchUpInside)
        setAlarmView.alarmNameTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        setAlarmView.deleteButton.addTarget(self, action: #selector(textDelete_Tapped), for: .touchUpInside)
        setAlarmView.setButton.addTarget(self, action: #selector(set_Tapped), for: .touchUpInside)
    }
    
    private func initUI() {
        DropDown.appearance().textColor = .gray900 // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = .orange700 // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = .gray50 // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = .orange50 // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(5)
        DropDown.appearance().setupMaskedCorners(CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner))
        drop.dismissMode = .automatic // 팝업을 닫을 모드 설정
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 12)
    }
    
    private func setDropdown() {
        drop.cellHeight = 44
        drop.anchorView = self.setAlarmView.univTextField
        drop.bottomOffset = CGPoint(x: 0, y: 45.5 + setAlarmView.univTextField.bounds.height)
        drop.shadowColor = .clear
        
        drop.cellConfiguration = { (index, item) in
            return "  \(item)" // 앞에 4칸 공백 추가
        }
        
        drop.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            
            guard index != (self.drop.dataSource.count) - 1 else { return }

            let separator = UIView()
            separator.backgroundColor = .gray300
            separator.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(separator)

            let separatorHeight: CGFloat = 1.5
            
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: separatorHeight)
            ])
        }

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
        viewModel.loadAlarmUniv()
    }
    
    private func bindViewModel() {
        viewModel.univItems
            .subscribe(onNext: { univList in self.drop.dataSource = self.viewModel.univItems.value })
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
        viewModel.enrollAlarm(memberId: memberId, univName: setAlarmView.univTextField.text, name: setAlarmView.alarmNameTextField.text, date: setAlarmView.dateValue, time: setAlarmView.timeValue)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func drop_Tapped() {
        drop.show()
    }
    
    @objc private func textDelete_Tapped() {
        setAlarmView.alarmNameTextField.text = ""
        warningAlarmName()
    }
}

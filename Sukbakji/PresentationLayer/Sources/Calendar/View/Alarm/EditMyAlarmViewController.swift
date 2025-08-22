//
//  EditMyAlarmViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 1/6/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import DropDown

class EditMyAlarmViewController: UIViewController {
    
    private let memberId = UserDefaults.standard.integer(forKey: "memberID")
    private let editAlarmView = EditAlarmView()
    private var alarmViewModel = AlarmViewModel()
    private let alarmDetailViewModel = AlarmDetailViewModel()
    private let disposeBag = DisposeBag()
    private lazy var drop: DropDown = DropDownFactory.make(anchor: editAlarmView.univTextField)
    private var didSetupDropDowns = false

    private var alarmNameViewHeightConstraint: Constraint?
    
    init(alarmViewModel: AlarmViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.alarmViewModel = alarmViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = editAlarmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setMyAlarmData()
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
}
    
extension EditMyAlarmViewController {
    
    private func setUI() {
        editAlarmView.alarmNameView.snp.makeConstraints { make in
            self.alarmNameViewHeightConstraint = make.height.equalTo(100).constraint
        }
        editAlarmView.alarmNameDeleteButton.addTarget(self, action: #selector(textDelete_Tapped), for: .touchUpInside)
        editAlarmView.alarmNameTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        editAlarmView.saveButton.addTarget(self, action: #selector(alarmEdit_Tapped), for: .touchUpInside)
        editAlarmView.deleteButton.addTarget(self, action: #selector(alarmDelete_Tapped), for: .touchUpInside)
    }
    
    private func setDropdown() {
        drop.selectionAction = { [weak self] (index, item) in
            self?.editAlarmView.univTextField.text = "\(item)"
        }
    }
    
    private func setMyAlarmData() {
        guard let selectMyAlarmItem = self.alarmViewModel.selectAlarmItem else { return }
        let alarmUnivName = selectMyAlarmItem.alarmUnivName
        let alarmName = selectMyAlarmItem.alarmName
        let alarmDate = selectMyAlarmItem.alarmDate
        let alarmTime = selectMyAlarmItem.alarmTime
        let formattedDate = DateUtils.formatDateString(alarmDate)
        
        editAlarmView.dateValue = selectMyAlarmItem.alarmDate
        editAlarmView.univTextField.text = alarmUnivName
        editAlarmView.alarmNameTextField.text = alarmName
        editAlarmView.alarmDateTextField.text = formattedDate
        editAlarmView.dateLabel.text = formattedDate
        let formattedTime = TimeHelper.convertTimeToAMPM(time: alarmTime)
        editAlarmView.timeButton.setTitle("\(formattedTime)", for: .normal)
    }
}
    
extension EditMyAlarmViewController {
    
    private func setAPI() {
        bindViewModel()
        alarmViewModel.loadAlarmUniv()
    }
    
    private func bindViewModel() {
        alarmViewModel.univItems
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in self?.drop.dataSource = $0 })
            .disposed(by: disposeBag)
        
        editAlarmView.dropButton.rx.tap
            .bind(onNext: { [weak self] in self?.drop.show() })
            .disposed(by: disposeBag)
    }
    
    @objc func textFieldEdited(_ textField: UITextField) {
        if editAlarmView.alarmNameTextField.text?.isEmpty == true {
            warningAlarmName()
        } else {
            deleteWarningAlarmName()
        }
    }
    
    private func warningAlarmName() {
        alarmNameViewHeightConstraint?.update(offset: 116)
        editAlarmView.warningImageView.isHidden = false
        editAlarmView.warningAlarmNameLabel.isHidden = false
        
        editAlarmView.alarmNameTextField.backgroundColor = .warning50
        editAlarmView.alarmNameTextField.setPlaceholderColor(.warning400)
        editAlarmView.alarmNameTextField.updateUnderlineColor(to: .warning400)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func deleteWarningAlarmName() {
        alarmNameViewHeightConstraint?.update(offset: 100)
        editAlarmView.warningImageView.isHidden = true
        editAlarmView.warningAlarmNameLabel.isHidden = true
        
        editAlarmView.alarmNameTextField.backgroundColor = .gray50
        editAlarmView.alarmNameTextField.setPlaceholderColor(.gray500)
        editAlarmView.alarmNameTextField.updateUnderlineColor(to: .gray300)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    @objc private func alarmEdit_Tapped() {
        guard let selectItem = self.alarmViewModel.selectAlarmItem else { return }
        alarmDetailViewModel.editAlarm(memberId: memberId, alarmId: selectItem.alarmId, univName: editAlarmView.univTextField.text ?? "", name: editAlarmView.alarmNameTextField.text ?? "", date: editAlarmView.dateValue, time: editAlarmView.timeValue, onoff: selectItem.onoff)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc private func alarmDelete_Tapped() {
        let deleteView = CalendarDeleteView(title: "알람 삭제하기", content: "해당 알람을 삭제할까요? 삭제 후 복구되지 않습\n니다.", alarmViewModel: alarmViewModel, univDelete: UnivDelete(memberId: 0, univId: 0, season: "", method: ""))
        deleteView.delegateViewController = self
        
        self.view.addSubview(deleteView)
        deleteView.alpha = 0
        deleteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            deleteView.alpha = 1
        }
    }
    
    @objc private func textDelete_Tapped() {
        editAlarmView.alarmNameTextField.text = ""
        warningAlarmName()
    }
}

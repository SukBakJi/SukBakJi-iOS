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
    private var viewModel = AlarmViewModel()
    private let disposeBag = DisposeBag()
    private let drop = DropDown()

    private var alarmNameViewHeightConstraint: Constraint?
    
    init(alarmViewModel: AlarmViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = alarmViewModel
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
        setDrop()
        setMyAlarmData()
        setAPI()
        hideKeyboardWhenTappedAround()
    }
}
    
extension EditMyAlarmViewController {
    
    private func setDrop() {
        initUI()
        setDropdown()
    }
    
    private func setUI() {
        editAlarmView.alarmNameView.snp.makeConstraints { make in
            self.alarmNameViewHeightConstraint = make.height.equalTo(100).constraint
        }
        editAlarmView.dropButton.addTarget(self, action: #selector(drop_Tapped), for: .touchUpInside)
        editAlarmView.alarmNameDeleteButton.addTarget(self, action: #selector(textDelete_Tapped), for: .touchUpInside)
        editAlarmView.alarmNameTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        editAlarmView.saveButton.addTarget(self, action: #selector(alarmEdit_Tapped), for: .touchUpInside)
        editAlarmView.deleteButton.addTarget(self, action: #selector(alarmDelete_Tapped), for: .touchUpInside)
    }
    
    private func initUI() {
        DropDown.appearance().textColor = .gray900
        DropDown.appearance().selectedTextColor = .orange700
        DropDown.appearance().backgroundColor = .gray50
        DropDown.appearance().selectionBackgroundColor = .orange50
        DropDown.appearance().setupCornerRadius(5)
        DropDown.appearance().setupMaskedCorners(CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner))
        drop.dismissMode = .automatic
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 12)
    }
    
    private func setDropdown() {
        drop.cellHeight = 44
        drop.anchorView = editAlarmView.univTextField
        drop.bottomOffset = CGPoint(x: 0, y: 45.5 + editAlarmView.univTextField.bounds.height)
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
            self?.editAlarmView.univTextField.text = "\(item)"
        }
    }
    
    private func setMyAlarmData() {
        guard let selectMyAlarmItem = self.viewModel.selectAlarmItem else { return }
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
        viewModel.loadAlarmUniv()
    }
    
    private func bindViewModel() {
        viewModel.univItems
            .subscribe(onNext: { univList in self.drop.dataSource = self.viewModel.univItems.value })
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
        guard let selectItem = self.viewModel.selectAlarmItem else { return }
        viewModel.editAlarm(memberId: memberId, alarmId: selectItem.alarmId, univName: editAlarmView.univTextField.text, name: editAlarmView.alarmNameTextField.text, date: editAlarmView.dateValue, time: editAlarmView.timeValue, onoff: selectItem.onoff)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc private func alarmDelete_Tapped() {
        let deleteView = CalendarDeleteView(title: "알람 삭제하기", content: "해당 알람을 삭제할까요? 삭제 후 복구되지 않습\n니다.", alarmViewModel: viewModel, univDelete: UnivDelete(memberId: 0, univId: 0, season: "", method: ""))
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
    
    @objc private func drop_Tapped() {
        drop.show()
    }
    
    @objc private func textDelete_Tapped() {
        editAlarmView.alarmNameTextField.text = ""
        warningAlarmName()
    }
}

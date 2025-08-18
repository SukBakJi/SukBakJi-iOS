//
//  EditUnivCalendarViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 1/4/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import DropDown

class EditUnivCalendarViewController: UIViewController {

    private let editUnivView = EditUnivView()
    private var univViewModel = UnivViewModel()
    private var univDetailViewModel = UnivDetailViewModel()
    private let disposeBag = DisposeBag()
    private lazy var drop: DropDown = DropDownFactory.make(anchor: editUnivView.recruitTypeTextField)
    private var didSetupDropDowns = false
    
    init(univViewModel: UnivViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.univViewModel = univViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = editUnivView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAPI()
        setUnivCalendarData()
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

extension EditUnivCalendarViewController {
    
    private func setDropdown() {
        drop.selectionAction = { [weak self] (index, item) in
            self?.editUnivView.recruitTypeTextField.text = "\(item)"
            self?.updateButtonColor()
        }
    }
    
    private func setUnivCalendarData() {
        guard let selectUnivCalendarItem = self.univViewModel.selectUnivList else { return }
        let univId = selectUnivCalendarItem.univId
        let season = selectUnivCalendarItem.season
        let method = selectUnivCalendarItem.method

        univViewModel.loadUnivName(univId: univId)
            .subscribe(onNext: { [weak self] univName in
                self?.editUnivView.univLabel.text = univName
            })
            .disposed(by: disposeBag)
        if season == editUnivView.recruitFirstLabel.text {
            editUnivView.recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
            editUnivView.recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
            editUnivView.recruitFirstButton.isEnabled = false
        } else {
            editUnivView.recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
            editUnivView.recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
            editUnivView.recruitSecondButton.isEnabled = false
        }
        editUnivView.recruitTypeTextField.text = method
    }
}

extension EditUnivCalendarViewController {
    
    private func setAPI() {
        bindViewModel()
        univViewModel.loadUnivMethod(univId: univViewModel.selectUnivList?.univId ?? 0)
    }
    
    private func bindViewModel() {
        univViewModel.recruitTypes
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in self?.drop.dataSource = $0 })
            .disposed(by: disposeBag)
        
        editUnivView.dropButton.rx.tap
            .bind(onNext: { [weak self] in self?.drop.show() })
            .disposed(by: disposeBag)
        
        editUnivView.editButton.rx.tap
            .bind { [weak self] in self?.univEditTapped() }
            .disposed(by: disposeBag)
    }
    
    private func univEditTapped() {
        guard let selectItem = self.univViewModel.selectUnivList else { return }
        univDetailViewModel.editUniv(univId: selectItem.univId, season: selectItem.season, method: selectItem.method)
        self.presentingViewController?.dismiss(animated: true)
    }
        
    private func updateButtonColor() {
        let isFormValid = !(editUnivView.recruitTypeTextField.text?.isEmpty ?? true)
        editUnivView.editButton.isEnabled = isFormValid
        editUnivView.editButton.setBackgroundColor(isFormValid ? .orange700 : .gray200, for: .normal)
        editUnivView.editButton.setTitleColor(isFormValid ? .white : .gray500, for: .normal)
    }
    
    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            self.updateButtonColor()
        }
        return true
    }
}

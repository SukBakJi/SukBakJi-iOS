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
    private var viewModel = CalendarViewModel()
    private var univViewModel = UnivViewModel()
    private let disposeBag = DisposeBag()
    
    private let drop = DropDown()
    private var recruitType: [String] = []
    
    init(calendarViewModel: CalendarViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = calendarViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = editUnivView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initUI()
        setDropdown()
//        setAPI()
    }
}

extension EditUnivCalendarViewController {
    
    private func setUI() {
        editUnivView.recruitFirstButton.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
        editUnivView.recruitSecondButton.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
        editUnivView.dropButton.addTarget(self, action: #selector(drop_Tapped), for: .touchUpInside)
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
        drop.anchorView = editUnivView.recruitTypeTextField
        drop.bottomOffset = CGPoint(x: 0, y: 45.5 + editUnivView.recruitTypeTextField.bounds.height)
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
                        
            let separatorHeight: CGFloat = 1.5 // 원하는 굵기 설정
                        
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: separatorHeight)
            ])
        }

        drop.selectionAction = { [weak self] (index, item) in
            self?.editUnivView.recruitTypeTextField.text = "\(item)"
            self?.updateButtonColor()
        }
    }
    
    private func setUnivCalendarData() {
        guard let selectUnivCalendarItem = self.viewModel.selectUnivList.value else { return }
        let univName = selectUnivCalendarItem.univId
        let season = selectUnivCalendarItem.season
        let method = selectUnivCalendarItem.method
        
        if univName == 1 {
            editUnivView.univLabel.text = "서울대학교"
        } else if univName == 2 {
            editUnivView.univLabel.text = "연세대학교"
        } else if univName == 3 {
            editUnivView.univLabel.text = "고려대학교"
        } else {
            editUnivView.univLabel.text = "카이스트"
        }
        if season == editUnivView.recruitFirstLabel.text {
            editUnivView.recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
            editUnivView.recruitFirstButton.isEnabled = false
        } else {
            editUnivView.recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
            editUnivView.recruitSecondButton.isEnabled = false
        }
        editUnivView.recruitTypeTextField.text = method
    }
}

extension EditUnivCalendarViewController {
    
    private func setAPI() {
        bindViewModel()
        univViewModel.loadUnivMethod(univId: viewModel.selectUnivList.value?.univId ?? 0)
    }
    
    private func bindViewModel() {
        univViewModel.recruitTypes
            .subscribe(onNext: { univList in self.drop.dataSource = self.univViewModel.recruitTypes.value })
            .disposed(by: disposeBag)
        
        editUnivView.editButton.rx.tap
            .bind { [weak self] in self?.univEditTapped() }
            .disposed(by: disposeBag)
    }
    
    private func univEditTapped() {
        guard let selectItem = self.viewModel.selectUnivList.value else { return }
        viewModel.editUnivCalendar(univId: selectItem.univId, season: selectItem.season, method: selectItem.method)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func firstButtonTapped() {
        editUnivView.recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
        editUnivView.recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
                
        editUnivView.recruitFirstButton.isEnabled = false
        editUnivView.recruitSecondButton.isEnabled = true
    }
    
    @objc func secondButtonTapped() {
        editUnivView.recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        editUnivView.recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
                
        editUnivView.recruitFirstButton.isEnabled = true
        editUnivView.recruitSecondButton.isEnabled = false
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
    
    @objc private func drop_Tapped() {
        drop.show()
    }
}

//
//  PostWritingViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/29/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import DropDown

class PostWritingViewController: UIViewController, UITextViewDelegate {
    
    private var postWritingView = PostWritingView()
    private let postDetailViewModel = PostDetailViewModel()
    private let boardViewModel = BoardViewModel()
    var disposeBag = DisposeBag()
    
    private let categoryDrop = DropDown()
    private let fieldDrop = DropDown()
    
    private var categoryHeightConstraint: Constraint?
    private var titleHeightConstraint: Constraint?
    private var contentHeightConstraint: Constraint?
    private var supportFieldHeightConstraint: Constraint?
    private var jobHeightConstraint: Constraint?
    private var infoHeightConstraint: Constraint?
    
    private var hiringType = ""
    private var finalEdu = ""
    private var fieldMenu: [String] = ["법무", "인사∙HR", "회계∙세무", "마케팅∙광고∙MD", "개발∙데이터", "디자인", "물류∙무역", "운전∙운송∙배송", "영업", "고객상담∙TM", "금융∙보험", "식∙음료", "고객서비스∙리테일", "엔지니어링∙설계", "제조∙생산", "교육", "건축∙시설", "의료∙바이오", "미디어∙문화∙스포츠", "공공∙복지", "기타"]
    
    override func loadView() {
        self.view = postWritingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        initUI()
        setDropdown()
        setAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PostWritingViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        postWritingView.navigationbarView.delegate = self
        postWritingView.contentTextView.delegate = self
        
        postWritingView.categoryView.snp.makeConstraints { make in
            categoryHeightConstraint = make.height.equalTo(99).constraint
        }
        postWritingView.titleView.snp.makeConstraints { make in
            titleHeightConstraint = make.height.equalTo(99).constraint
        }
        postWritingView.contentView.snp.makeConstraints { make in
            contentHeightConstraint = make.height.equalTo(175).constraint
        }
        postWritingView.supportFieldView.snp.makeConstraints { make in
            supportFieldHeightConstraint = make.height.equalTo(1).constraint
        }
        postWritingView.jobView.snp.makeConstraints { make in
            jobHeightConstraint = make.height.equalTo(1).constraint
        }
        postWritingView.infoView.snp.makeConstraints { make in
            infoHeightConstraint = make.height.equalTo(1).constraint
        }
        
        postWritingView.menuButtons.keys.forEach { button in
            button.addTarget(self, action: #selector(menuButtonTapped(_:)), for: .touchUpInside)
        }
        postWritingView.hiringTypeButtons.keys.forEach { button in
            button.addTarget(self, action: #selector(hiringTypeButtonTapped(_:)), for: .touchUpInside)
        }
        postWritingView.finalEduButtons.keys.forEach { button in
            button.addTarget(self, action: #selector(finalEduButtonTapped(_:)), for: .touchUpInside)
        }
        postWritingView.dropButton.addTarget(self, action: #selector(categoryDrop_Tapped), for: .touchUpInside)
        postWritingView.dropButton2.addTarget(self, action: #selector(jobDrop_Tapped), for: .touchUpInside)
        postWritingView.titleTextField.addTarget(self, action: #selector(titleTextFieldEdited), for: .editingChanged)
        postWritingView.jobTextField.addTarget(self, action: #selector(jobTextFieldEdited), for: .editingChanged)
        postWritingView.deleteButton.addTarget(self, action: #selector(jobDelete_Tapped), for: .touchUpInside)
        postWritingView.deleteButton2.addTarget(self, action: #selector(titleDelete_Tapped), for: .touchUpInside)
        postWritingView.buttonView.enrollButton.addTarget(self, action: #selector(enroll_Tapped), for: .touchUpInside)
    }
    
    private func initUI() {
        DropDown.appearance().textColor = .gray900
        DropDown.appearance().selectedTextColor = .orange700
        DropDown.appearance().backgroundColor = .gray50
        DropDown.appearance().selectionBackgroundColor = .orange50
        DropDown.appearance().setupCornerRadius(5)
        DropDown.appearance().setupMaskedCorners(CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner))
        categoryDrop.dismissMode = .automatic // 팝업을 닫을 모드 설정
        fieldDrop.dismissMode = .automatic
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 12)
    }
    
    private func setDropdown() {
        categoryDrop.cellHeight = 44
        categoryDrop.anchorView = self.postWritingView.categoryTextField
        categoryDrop.bottomOffset = CGPoint(x: 0, y: 45.5 + postWritingView.categoryTextField.bounds.height)
        
        fieldDrop.cellHeight = 44
        fieldDrop.anchorView = self.postWritingView.supportFieldTextField
        fieldDrop.bottomOffset = CGPoint(x: 0, y: 45.5 + postWritingView.supportFieldTextField.bounds.height)
        fieldDrop.dataSource = fieldMenu
        
        categoryDrop.cellConfiguration = { (index, item) in
            return "  \(item)" // 앞에 4칸 공백 추가
        }
        fieldDrop.cellConfiguration = { (index, item) in
            return "  \(item)" // 앞에 4칸 공백 추가
        }
        
        categoryDrop.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) in
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            cell.subviews.forEach {
                if $0.tag == 9999 { $0.removeFromSuperview() }
            }
            
            guard let self = self else { return }
            guard index != (self.categoryDrop.dataSource.count - 1) else { return }
            
            let separator = UIView()
            separator.tag = 9999
            separator.backgroundColor = .gray300
            separator.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(separator)
            
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: 1.5)
            ])
        }
        
        fieldDrop.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) in
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            cell.subviews.forEach {
                if $0.tag == 9999 { $0.removeFromSuperview() }
            }
            
            guard let self = self else { return }
            guard index != (self.fieldDrop.dataSource.count - 1) else { return }
            
            let separator = UIView()
            separator.tag = 9999
            separator.backgroundColor = .gray300
            separator.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(separator)
            
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: 1.5)
            ])
        }
        
        categoryDrop.selectionAction = { [weak self] (index, item) in
            self?.postWritingView.categoryTextField.text = "\(item)"
            self?.updateButtonColor()
            self?.postWritingView.categoryTextField.backgroundColor = .gray50
            self?.postWritingView.categoryTextField.setPlaceholderColor(.gray500)
            self?.postWritingView.categoryTextField.updateUnderlineColor(to: .gray300)
            self?.deleteWarningCategory()
            if item == "취업후기 게시판" {
                self?.supportFieldHeightConstraint?.update(offset: 99)
                self?.jobHeightConstraint?.update(offset: 99)
                self?.infoHeightConstraint?.update(offset: 170)
            } else {
                self?.supportFieldHeightConstraint?.update(offset: 1)
                self?.jobHeightConstraint?.update(offset: 1)
                self?.infoHeightConstraint?.update(offset: 1)
            }
        }
        
        fieldDrop.selectionAction = { [weak self] (index, item) in
            self?.postWritingView.supportFieldTextField.text = "\(item)"
            self?.postWritingView.supportFieldTextField.backgroundColor = .gray50
            self?.postWritingView.supportFieldTextField.setPlaceholderColor(.gray500)
            self?.postWritingView.supportFieldTextField.updateUnderlineColor(to: .gray300)
            self?.deleteWarningSupport()
        }
    }
}
    
extension PostWritingViewController {
    
    private func setAPI() {
        bindViewModel()
        boardViewModel.loadCategories(for: .doctor)
    }
    
    private func bindViewModel() {
        boardViewModel.categoryList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] categories in
                self?.categoryDrop.dataSource = categories
            })
            .disposed(by: disposeBag)
        
        postDetailViewModel.postEvent
            .emit(onNext: { [weak self] event in
                guard case .created = event else { return }
                self?.postWritingView.buttonView.enrollButton.isEnabled = true
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            postWritingView.categoryTextField.rx.text.orEmpty,
            postWritingView.titleTextField.rx.text.orEmpty,
            postWritingView.contentTextView.rx.text.orEmpty
        )
        .map { PostFormState(category: $0.0, title: $0.1, content: $0.2) }
        .bind(to: postDetailViewModel.formState)
        .disposed(by: disposeBag)
        
        postDetailViewModel.formState
            .map(\.isValid)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] enabled in
                self?.styleEnrollButton(enabled: enabled)
            })
            .disposed(by: disposeBag)
        
        boardViewModel.selectedMenu
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] menu in
                self?.boardViewModel.loadCategories(for: menu)
            })
            .disposed(by: disposeBag)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateButtonColor() // 기존 스타일 로직을 재사용
        let trimmed = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            warningContent()
        } else {
            deleteWarningContent()
        }
    }
    
    private enum WarningType {
        case category
        case title
        case support
        case job
    }

    private func updateWarningUI(for type: WarningType, showWarning: Bool) {
        var heightConstraint: Constraint?
        var warningImage: UIImageView?
        var warningLabel: UILabel?
        var textField: UITextField?
        
        switch type {
        case .category:
            heightConstraint = categoryHeightConstraint
            warningImage = postWritingView.warningCategoryImage
            warningLabel = postWritingView.warningCategoryLabel
            textField = postWritingView.categoryTextField
        case .title:
            heightConstraint = titleHeightConstraint
            warningImage = postWritingView.warningTitleImage
            warningLabel = postWritingView.warningTitleLabel
            textField = postWritingView.titleTextField
        case .support:
            heightConstraint = supportFieldHeightConstraint
            warningImage = postWritingView.warningSupportFieldImage
            warningLabel = postWritingView.warningSupportFieldLabel
            textField = postWritingView.supportFieldTextField
        case .job:
            heightConstraint = jobHeightConstraint
            warningImage = postWritingView.warningJobImage
            warningLabel = postWritingView.warningJobLabel
            textField = postWritingView.jobTextField
        }
        
        heightConstraint?.update(offset: showWarning ? 117 : 99)
        warningImage?.isHidden = !showWarning
        warningLabel?.isHidden = !showWarning
        textField?.backgroundColor = showWarning ? .warning50 : .gray50
        textField?.setPlaceholderColor(showWarning ? .warning400 : .gray500)
        textField?.updateUnderlineColor(to: showWarning ? .warning400 : .gray300)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func warningCategory() {
        updateWarningUI(for: .category, showWarning: true)
    }

    private func deleteWarningCategory() {
        updateWarningUI(for: .category, showWarning: false)
    }

    private func warningTitle() {
        updateWarningUI(for: .title, showWarning: true)
    }

    private func deleteWarningTitle() {
        updateWarningUI(for: .title, showWarning: false)
    }
    
    private func warningSupport() {
        updateWarningUI(for: .support, showWarning: true)
    }

    private func deleteWarningSupport() {
        updateWarningUI(for: .support, showWarning: false)
    }

    private func warningJob() {
        updateWarningUI(for: .job, showWarning: true)
    }

    private func deleteWarningJob() {
        updateWarningUI(for: .job, showWarning: false)
    }
    
    private func warningContent() {
        contentHeightConstraint?.update(offset: 193)
        postWritingView.warningContentImage.isHidden = false
        postWritingView.warningContentLabel.isHidden = false
        postWritingView.contentTextView.backgroundColor = .warning50
        postWritingView.contentTextView.textColor = .warning400
        postWritingView.contentTextView.updateUnderlineColor(to: .warning400)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func deleteWarningContent() {
        contentHeightConstraint?.update(offset: 175)
        postWritingView.warningContentImage.isHidden = true
        postWritingView.warningContentLabel.isHidden = true
        postWritingView.contentTextView.backgroundColor = .gray50
        postWritingView.contentTextView.textColor = .gray900
        postWritingView.contentTextView.updateUnderlineColor(to: .gray300)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 레이아웃 변경 애니메이션 적용
        }
    }
    
    private func styleEnrollButton(enabled: Bool) {
        postWritingView.buttonView.enrollButton.isEnabled = enabled
        postWritingView.buttonView.enrollButton.setBackgroundColor(enabled ? .orange700 : .gray200, for: .normal)
        postWritingView.buttonView.enrollButton.setTitleColor(enabled ? .white : .gray500, for: .normal)
    }
    
    private func updateButtonColor() {
        let isFormValid = (postWritingView.categoryTextField.text?.isEmpty == false && postWritingView.titleTextField.text?.isEmpty == false && postWritingView.contentTextView.text?.isEmpty == false)
        styleEnrollButton(enabled: isFormValid)
    }
    
    @objc private func menuButtonTapped(_ sender: UIButton) {
        for button in postWritingView.menuButtons.keys {
            let isSelected = (button == sender)
            let imageName = isSelected ? "Sukbakji_RadioButton" : "Sukbakji_RadioButton2"
            button.setImage(UIImage(named: imageName), for: .normal)
            button.isEnabled = !isSelected
        }
        if let selectedMenu = postWritingView.menuButtons[sender] {
            boardViewModel.selectedMenu.accept(selectedMenu)
        }
    }
    
    @objc private func hiringTypeButtonTapped(_ sender: UIButton) {
        for button in postWritingView.hiringTypeButtons.keys {
            let isSelected = (button == sender)
            let imageName = isSelected ? "Sukbakji_RadioButton" : "Sukbakji_RadioButton2"
            button.setImage(UIImage(named: imageName), for: .normal)
            button.isEnabled = !isSelected
        }
        if let selectedType = postWritingView.hiringTypeButtons[sender] {
            hiringType = selectedType
        }
    }
    
    @objc private func finalEduButtonTapped(_ sender: UIButton) {
        for button in postWritingView.finalEduButtons.keys {
            let isSelected = (button == sender)
            let imageName = isSelected ? "Sukbakji_RadioButton" : "Sukbakji_RadioButton2"
            button.setImage(UIImage(named: imageName), for: .normal)
            button.isEnabled = !isSelected
        }
        if let selectedEdu = postWritingView.finalEduButtons[sender] {
            finalEdu = selectedEdu
        }
    }
    
    @objc func titleTextFieldEdited(_ textField: UITextField) {
        updateButtonColor()
        if postWritingView.titleTextField.text?.isEmpty == true {
            warningTitle()
        } else {
            deleteWarningTitle()
        }
    }
    
    @objc func jobTextFieldEdited(_ textField: UITextField) {
        if postWritingView.jobTextField.text?.isEmpty == true {
            warningJob()
        } else {
            deleteWarningJob()
        }
    }
    
    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            self.updateButtonColor()
        }
        return true
    }
    
    @objc private func enroll_Tapped() {
        postDetailViewModel.createPost(menu: boardViewModel.selectedMenu.value, boardName: postWritingView.categoryTextField.text!, title: postWritingView.titleTextField.text!, content: postWritingView.contentTextView.text)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func jobDelete_Tapped() {
        postWritingView.jobTextField.text = ""
        warningJob()
    }
    
    @objc private func titleDelete_Tapped() {
        postWritingView.titleTextField.text = ""
        warningTitle()
    }
    
    @objc private func categoryDrop_Tapped() {
        categoryDrop.show()
    }
    
    @objc private func jobDrop_Tapped() {
        fieldDrop.show()
    }
}

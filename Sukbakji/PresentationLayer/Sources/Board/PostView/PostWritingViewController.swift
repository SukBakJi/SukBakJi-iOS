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
    
    private lazy var categoryDrop: DropDown = DropDownFactory.make(anchor: postWritingView.categoryTextField)
    private lazy var fieldDrop: DropDown = DropDownFactory.make(anchor: postWritingView.supportFieldTextField)
    private var didSetupDropDowns = false
    
    private var menuGroup: RadioGroup<BoardMenu>!
    private var hiringTypeGroup: RadioGroup<String>!
    private var finalEduGroup: RadioGroup<String>!
    
    private var hiringType = ""
    private var finalEdu = ""
    private let fieldList = BehaviorRelay<[String]>(value: [
        "법무","인사∙HR","회계∙세무","총무∙사무","마케팅∙광고","영업","고객상담",
        "IT∙개발","데이터","디자인","연구∙R&D","물류∙무역","구매","전문직",
        "금융","건설","부동산","엔지니어링","제조∙생산","교육","건축∙시설",
        "의료∙바이오","미디어∙문화∙스포츠","공공∙복지","기타"
    ])
    
    override func loadView() {
        self.view = postWritingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAPI()
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

extension PostWritingViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        postWritingView.navigationbarView.delegate = self
        postWritingView.contentTextView.delegate = self
        postWritingView.titleTextField.delegate = self
        postWritingView.jobTextField.delegate = self
        
        postWritingView.titleTextField.addTarget(self, action: #selector(titleTextFieldEdited), for: .editingChanged)
        postWritingView.jobTextField.addTarget(self, action: #selector(jobTextFieldEdited), for: .editingChanged)
        postWritingView.deleteButton.addTarget(self, action: #selector(jobDelete_Tapped), for: .touchUpInside)
        postWritingView.deleteButton2.addTarget(self, action: #selector(titleDelete_Tapped), for: .touchUpInside)
        postWritingView.buttonView.enrollButton.addTarget(self, action: #selector(enroll_Tapped), for: .touchUpInside)
        
        setupRadioGroups()
    }
    
    private func setDropdown() {
        categoryDrop.selectionAction = { [weak self] index, item in
            self?.postWritingView.categoryTextField.text = "\(item)"
            self?.updateButtonColor()
            self?.postWritingView.categoryTextField.backgroundColor = .gray50
            self?.postWritingView.categoryTextField.setPlaceholderColor(.gray500)
            self?.postWritingView.categoryTextField.updateUnderlineColor(to: .gray300)
            self?.deleteWarningCategory()
            self?.applySectionVisibility(forCategory: item)
        }
        
        fieldDrop.selectionAction = { [weak self] (index, item) in
            self?.postWritingView.supportFieldTextField.text = "\(item)"
            self?.postWritingView.supportFieldTextField.backgroundColor = .gray50
            self?.postWritingView.supportFieldTextField.setPlaceholderColor(.gray500)
            self?.postWritingView.supportFieldTextField.updateUnderlineColor(to: .gray300)
            self?.deleteWarningSupport()
        }
    }
    
    private func setupRadioGroups() {
        let menuButtons: [UIButton] = postWritingView.menuButtonArray
        let menuValues: [BoardMenu] = [.doctor, .master, .enter, .free]

        menuGroup = RadioGroup(
            buttons: menuButtons,
            values: menuValues,
            initial: boardViewModel.selectedMenu.value,
            appearance: .images(
                selected: UIImage(named: "Sukbakji_RadioButton"),
                deselected: UIImage(named: "Sukbakji_RadioButton2")
            )
        )
        
        let hiringButtons = postWritingView.hiringTypeButtonArray
        let hiringValues = ["신입", "경력"]
        hiringTypeGroup = RadioGroup(buttons: hiringButtons, values: hiringValues)

        let eduButtons = postWritingView.finalEduButtonArray
        let eduValues = ["박사", "석사"]
        finalEduGroup = RadioGroup(buttons: eduButtons, values: eduValues)
    }

}
    
extension PostWritingViewController: UITextFieldDelegate {
    
    private func setAPI() {
        bindViewModel()
        bindRadioGroups()
        boardViewModel.loadCategories(for: .doctor)
    }
    
    private func bindViewModel() {
        boardViewModel.categoryList
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in self?.categoryDrop.dataSource = $0 })
            .disposed(by: disposeBag)
        
        fieldList
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in self?.fieldDrop.dataSource = $0 })
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
        
        postWritingView.categoryTextField.rx.text
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] text in
                self?.applySectionVisibility(forCategory: text)
            })
            .disposed(by: disposeBag)
        
        postWritingView.dropButton.rx.tap
            .withLatestFrom(boardViewModel.categoryList) // Observable<[String]>
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] list in
                guard let self, !list.isEmpty else { return }
                self.categoryDrop.dataSource = list
                self.categoryDrop.reloadAllComponents()
                self.categoryDrop.show()
            })
            .disposed(by: disposeBag)
        
        postWritingView.dropButton2.rx.tap
            .bind(onNext: { [weak self] in self?.fieldDrop.show() })
            .disposed(by: disposeBag)
    }
    
    private func bindRadioGroups() {
        menuGroup
            .asValueDriver()
            .drive(onNext: { [weak self] value in
                self?.boardViewModel.selectedMenu.accept(value)
            })
            .disposed(by: disposeBag)
        
        hiringTypeGroup
            .asValueDriver()
            .drive(onNext: { [weak self] v in self?.hiringType = v })
            .disposed(by: disposeBag)
        
        finalEduGroup
            .asValueDriver()
            .drive(onNext: { [weak self] v in self?.finalEdu = v })
            .disposed(by: disposeBag)
    }
    
    private enum Section { case supportField, job, info }

    private func setSection(_ section: Section, hidden: Bool, animated: Bool = true) {
        let view: UIView = {
            switch section {
            case .supportField: return postWritingView.supportFieldView
            case .job:          return postWritingView.jobView
            case .info:         return postWritingView.infoView
            }
        }()

        guard view.isHidden != hidden else { return }
        let apply = { view.isHidden = hidden }
        animated ? UIView.animate(withDuration: 0.22, animations: apply) : apply()
    }

    // 게시판 메뉴에 따른 표시 규칙 (예시는 취업후기만 3개 섹션 표시)
    private func applySectionVisibility(forCategory name: String?) {
        let show = isEmploymentReviewCategory(name)
        setSection(.supportField, hidden: !show)
        setSection(.job,          hidden: !show)
        setSection(.info,         hidden: !show)
    }

    private func isEmploymentReviewCategory(_ name: String?) -> Bool {
        guard let raw = name else { return false }
        return raw.trimmingCharacters(in: .whitespacesAndNewlines) == "취업후기 게시판"
    }
    
    private enum WarningType {
        case category
        case title
        case support
        case job
        case content
    }

    private func updateWarningUI(for type: WarningType, showWarning: Bool) {
        var warningImage: UIImageView?
        var warningLabel: UILabel?
        var textField: UITextField?
        var textView: UITextView?
        
        switch type {
        case .category:
            warningImage = postWritingView.warningCategoryImage
            warningLabel = postWritingView.warningCategoryLabel
            textField = postWritingView.categoryTextField
        case .title:
            warningImage = postWritingView.warningTitleImage
            warningLabel = postWritingView.warningTitleLabel
            textField = postWritingView.titleTextField
        case .support:
            warningImage = postWritingView.warningSupportFieldImage
            warningLabel = postWritingView.warningSupportFieldLabel
            textField = postWritingView.supportFieldTextField
        case .job:
            warningImage = postWritingView.warningJobImage
            warningLabel = postWritingView.warningJobLabel
            textField = postWritingView.jobTextField
        case .content:
            warningImage = postWritingView.warningContentImage
            warningLabel = postWritingView.warningContentLabel
            textView = postWritingView.contentTextView
        }
        
        warningImage?.isHidden = !showWarning
        warningLabel?.isHidden = !showWarning
        
        if let tf = textField {
            tf.backgroundColor = showWarning ? .warning50 : .gray50
            tf.setPlaceholderColor(showWarning ? .warning400 : .gray500)
            tf.updateUnderlineColor(to: showWarning ? .warning400 : .gray300)
        }
        if let tv = textView {
            tv.backgroundColor = showWarning ? .warning50 : .gray50
            tv.textColor = showWarning ? .warning400 : .gray900
            tv.updateUnderlineColor(to: showWarning ? .warning400 : .gray300)
        }
        
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
        updateWarningUI(for: .content, showWarning: true)
    }
    
    private func deleteWarningContent() {
        updateWarningUI(for: .content, showWarning: false)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            self.updateButtonColor()
        }
        return true
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
    
    @objc private func enroll_Tapped() {
        guard
            let boardName = postWritingView.categoryTextField.text, !boardName.isEmpty,
            let title = postWritingView.titleTextField.text, !title.isEmpty
        else { return }
        postDetailViewModel.createPost(
            menu: boardViewModel.selectedMenu.value,
            boardName: boardName,
            title: title,
            content: postWritingView.contentTextView.text
        )
    }
    
    @objc private func jobDelete_Tapped() {
        postWritingView.jobTextField.text = ""
        warningJob()
    }
    
    @objc private func titleDelete_Tapped() {
        postWritingView.titleTextField.text = ""
        warningTitle()
    }
}

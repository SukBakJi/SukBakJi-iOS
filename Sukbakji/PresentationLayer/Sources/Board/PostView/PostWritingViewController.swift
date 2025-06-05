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
    private let postViewModel = PostViewModel()
    private let boardViewModel = BoardViewModel()
    var disposeBag = DisposeBag()
    private let drop = DropDown()
    private var hasStartedEditing = false
    
    private var categoryHeightConstraint: Constraint?
    private var titleHeightConstraint: Constraint?
    private var contentHeightConstraint: Constraint?
    
    private var menu = "박사"
    
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
        
        postWritingView.radioButtons.keys.forEach { button in
            button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        }
        postWritingView.dropButton.addTarget(self, action: #selector(drop_Tapped), for: .touchUpInside)
        postWritingView.titleTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        postWritingView.deleteButton.addTarget(self, action: #selector(textDelete_Tapped), for: .touchUpInside)
        postWritingView.buttonView.enrollButton.addTarget(self, action: #selector(enroll_Tapped), for: .touchUpInside)
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
        drop.anchorView = self.postWritingView.categoryTextField
        drop.bottomOffset = CGPoint(x: 0, y: 45.5 + postWritingView.categoryTextField.bounds.height)
        drop.shadowColor = .clear
        
        drop.cellConfiguration = { (index, item) in
            return "  \(item)" // 앞에 4칸 공백 추가
        }
        
        drop.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) in
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            
            cell.subviews.forEach {
                if $0.tag == 9999 { $0.removeFromSuperview() }
            }
            
            guard let self = self else { return }
            
            // 마지막 셀에는 separator 추가하지 않음
            guard index != (self.drop.dataSource.count - 1) else { return }
            
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
        
        drop.selectionAction = { [weak self] (index, item) in
            self?.postWritingView.categoryTextField.text = "\(item)"
            self?.updateButtonColor()
            self?.postWritingView.categoryTextField.backgroundColor = .gray50
            self?.postWritingView.categoryTextField.setPlaceholderColor(.gray500)
            self?.postWritingView.categoryTextField.updateUnderlineColor(to: .gray300)
            self?.deleteWarningCategory()
        }
        
        drop.cancelAction = { [weak self] in
            self?.postWritingView.categoryTextField.text = ""
            self?.postWritingView.categoryTextField.backgroundColor = .warning50
            self?.postWritingView.categoryTextField.setPlaceholderColor(.warning400)
            self?.postWritingView.categoryTextField.updateUnderlineColor(to: .warning400)
            self?.warningCategory()
        }
    }
}
    
extension PostWritingViewController {
    
    private func setAPI() {
        bindViewModel()
        boardViewModel.loadMenu(menu: "박사")
    }
    
    private func bindViewModel() {
        boardViewModel.categoryList
            .subscribe(onNext: { categoryList in self.drop.dataSource = self.boardViewModel.categoryList.value })
            .disposed(by: disposeBag)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard !hasStartedEditing else { return }
        hasStartedEditing = true
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: textView, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            let isValid = !(textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            self.updateButtonColor()
            
            if isValid {
                self.deleteWarningContent()
            } else {
                self.warningContent()
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: textView)
    }
    
    private enum WarningType {
        case category
        case title
    }

    private func updateWarningUI(for type: WarningType, showWarning: Bool) {
        let isCategory = type == .category
        let heightConstraint = isCategory ? categoryHeightConstraint : titleHeightConstraint
        let warningImage = isCategory ? postWritingView.warningCategoryImage : postWritingView.warningTitleImage
        let warningLabel = isCategory ? postWritingView.warningCategoryLabel : postWritingView.warningTitleLabel
        let textField = isCategory ? postWritingView.categoryTextField : postWritingView.titleTextField

        heightConstraint?.update(offset: showWarning ? 117 : 99)
        warningImage.isHidden = !showWarning
        warningLabel.isHidden = !showWarning
        textField.backgroundColor = showWarning ? .warning50 : .gray50
        textField.setPlaceholderColor(showWarning ? .warning400 : .gray500)
        textField.updateUnderlineColor(to: showWarning ? .warning400 : .gray300)

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
    
    private func updateButtonColor() {
        let isFormValid = (postWritingView.categoryTextField.text?.isEmpty == false && postWritingView.titleTextField.text?.isEmpty == false && postWritingView.contentTextView.text?.isEmpty == false)
        postWritingView.buttonView.enrollButton.isEnabled = isFormValid
        postWritingView.buttonView.enrollButton.setBackgroundColor(isFormValid ? .orange700 : .gray200, for: .normal)
        postWritingView.buttonView.enrollButton.setTitleColor(isFormValid ? .white : .gray500, for: .normal)
    }
    
    @objc private func radioButtonTapped(_ sender: UIButton) {
        for button in postWritingView.radioButtons.keys {
            let isSelected = (button == sender)
            let imageName = isSelected ? "Sukbakji_RadioButton" : "Sukbakji_RadioButton2"
            button.setImage(UIImage(named: imageName), for: .normal)
            button.isEnabled = !isSelected
        }
        if let selectedMenu = postWritingView.radioButtons[sender] {
            boardViewModel.loadMenu(menu: selectedMenu)
            menu = selectedMenu
        }
    }
    
    @objc func textFieldEdited(_ textField: UITextField) {
        updateButtonColor()
        if postWritingView.titleTextField.text?.isEmpty == true {
            warningTitle()
        } else {
            deleteWarningTitle()
        }
    }
    
    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            self.updateButtonColor()
        }
        return true
    }
    
    @objc private func enroll_Tapped() {
        postViewModel.enrollPost(menu: menu, boardName: postWritingView.categoryTextField.text!, title: postWritingView.titleTextField.text!, content: postWritingView.contentTextView.text)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func textDelete_Tapped() {
        postWritingView.titleTextField.text = ""
        warningTitle()
    }
    
    @objc private func drop_Tapped() {
        drop.show()
    }
}

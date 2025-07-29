//
//  ReviewWritingViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/11/25.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewWritingViewController: UIViewController, UITextViewDelegate {
    
    private let reviewWritingView = ReviewWritingView()
    private let labInfoviewModel = LabInfoViewModel()
    private let disposeBag = DisposeBag()
    private var hasStartedEditing = false
    var labId: Int = 0
    
    private var leadership = ""
    private var salary = ""
    private var autonomy = ""
    
    init(labId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.labId = labId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = reviewWritingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        reviewWritingView.navigationbarView.delegate = self
        reviewWritingView.reviewTextView.delegate = self
        
        reviewWritingView.leadershipButtons.keys.forEach { button in
            button.addTarget(self, action: #selector(leadershipButtonTapped(_:)), for: .touchUpInside)
        }
        reviewWritingView.salaryButtons.keys.forEach { button in
            button.addTarget(self, action: #selector(salaryButtonTapped(_:)), for: .touchUpInside)
        }
        reviewWritingView.autonomyButtons.keys.forEach { button in
            button.addTarget(self, action: #selector(autonomyButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard !hasStartedEditing else { return }
        hasStartedEditing = true
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: textView, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            let isValid = !(textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            self.updateButtonColor()
            
//            if isValid {
//                self.deleteWarningContent()
//            } else {
//                self.warningContent()
//            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: textView)
    }
    
    private func updateButtonColor() {
        let isFormValid = (leadership != "" && salary != "" && autonomy != "" && reviewWritingView.reviewTextView.text?.isEmpty == false)
        reviewWritingView.writingButton.isEnabled = isFormValid
        reviewWritingView.writingButton.setBackgroundColor(isFormValid ? .orange700 : .gray200, for: .normal)
        reviewWritingView.writingButton.setTitleColor(isFormValid ? .white : .gray500, for: .normal)
    }
}

extension ReviewWritingViewController {
    
    private func setAPI() {
        bindViewModel()
        labInfoviewModel.loadLabInfo(labId: labId)
    }
    
    private func bindViewModel() {
        labInfoviewModel.labInfo
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] lab in
                self?.reviewWritingView.univLabel.text = lab.universityName
                self?.reviewWritingView.univLabel2.text = lab.departmentName
                self?.reviewWritingView.professorLabel.text = lab.professorName + "교수"
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func leadershipButtonTapped(_ sender: UIButton) {
        for button in reviewWritingView.leadershipButtons.keys {
            let isSelected = (button == sender)
            button.setTitleColor(isSelected ? .orange500 : .gray500, for: .normal)
            button.setBackgroundColor(isSelected ? .orange50 : .gray50, for: .normal)
            button.isEnabled = !isSelected
        }
        if let selectedMenu = reviewWritingView.leadershipButtons[sender] {
            leadership = selectedMenu
        }
    }
    
    @objc private func salaryButtonTapped(_ sender: UIButton) {
        for button in reviewWritingView.salaryButtons.keys {
            let isSelected = (button == sender)
            button.setTitleColor(isSelected ? .orange500 : .gray500, for: .normal)
            button.setBackgroundColor(isSelected ? .orange50 : .gray50, for: .normal)
            button.isEnabled = !isSelected
        }
        if let selectedMenu = reviewWritingView.salaryButtons[sender] {
            salary = selectedMenu
        }
    }
    
    @objc private func autonomyButtonTapped(_ sender: UIButton) {
        for button in reviewWritingView.autonomyButtons.keys {
            let isSelected = (button == sender)
            button.setTitleColor(isSelected ? .orange500 : .gray500, for: .normal)
            button.setBackgroundColor(isSelected ? .orange50 : .gray50, for: .normal)
            button.isEnabled = !isSelected
        }
        if let selectedMenu = reviewWritingView.autonomyButtons[sender] {
            autonomy = selectedMenu
        }
    }
}

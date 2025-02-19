//
//  TOSViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 8/5/24.
//

import UIKit

class TOSViewController: UIViewController {
    
    // MARK: - Properties
    var isKakaoSignUp: Bool = false
    
    private var allChecked: Bool {
        return tosView.tableView.visibleCells
            .compactMap { $0 as? TOSTableViewCell }
            .allSatisfy { $0.checkButton.isSelected }
    }
    
    // MARK: - view
    private lazy var tosView = TOSView().then {
        $0.finalAgreeCheckButton.addTarget(self, action: #selector(finalAgreeCheckButtonTapped), for: .touchUpInside)
        $0.AllAgreeCheckButton.addTarget(self, action: #selector(AllAgreeCheckButtonTapped), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Screen transition
    @objc private func nextButtonTapped() {
        if isKakaoSignUp {
            let AcademicVerificationVC = AcademicVerificationViewController()
            self.navigationController?.pushViewController(AcademicVerificationVC, animated: true)
            
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .black
            self.navigationItem.backBarButtonItem = backBarButtonItem
        } else {
            let EmailSignUpVC = EmailSignUpViewController()
            self.navigationController?.pushViewController(EmailSignUpVC, animated: true)
            //self.dismiss(animated: true)
            
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .black
            self.navigationItem.backBarButtonItem = backBarButtonItem
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tosView)
        
        tosView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tosView.tableView.delegate = self
        tosView.tableView.dataSource = self
        
        setUpNavigationBar()
        updateNextButtonState()
    }

    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "회원가입"
    }
    
    // MARK: - Functional
    @objc func finalAgreeCheckButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if !sender.isSelected {
            tosView.AllAgreeCheckButton.isSelected = false
        } else if allChecked {
            tosView.AllAgreeCheckButton.isSelected = true
        }
        updateNextButtonState()
    }
    
    @objc func AllAgreeCheckButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isSelected = sender.isSelected
        
        tosView.tableView.visibleCells
            .compactMap { $0 as? TOSTableViewCell }
            .forEach { $0.checkButton.isSelected = isSelected }
        
        tosView.finalAgreeCheckButton.isSelected = isSelected
        updateNextButtonState()
    }
    
    @objc func checkButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if !sender.isSelected {
            tosView.AllAgreeCheckButton.isSelected = false
        } else if allChecked && tosView.finalAgreeCheckButton.isSelected {
            tosView.AllAgreeCheckButton.isSelected = true
        }
        updateNextButtonState()
    }
    
    private func updateNextButtonState() {
        let allSelected = allChecked && tosView.finalAgreeCheckButton.isSelected
        tosView.nextButton.isEnabled = allSelected
        tosView.nextButton.backgroundColor = allSelected ? .orange700 : .gray200
        tosView.nextButton.setTitleColor(allSelected ? .white : .gray500, for: .normal)
    }
    
    
    
}

extension TOSViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tosView.consent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TOSTableViewCell", for: indexPath) as? TOSTableViewCell else { return UITableViewCell() }
        cell.consentLabel.text = tosView.consent[indexPath.item]
        cell.checkButton.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}

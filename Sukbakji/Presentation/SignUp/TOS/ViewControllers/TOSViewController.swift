//
//  TOSViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 8/5/24.
//

import UIKit

class TOSViewController: UIViewController {
    var isKakaoSignUp: Bool = false
    private let tosView = TOSView()
    private let consent = ["서비스 이용약관 동의", "전자금융거래 이용약관 동의", "개인정보 수집 및 이용 동의", "커뮤니티 이용규칙 확인"]

    override func loadView() {
        self.view = tosView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        configureTableView()
        addTargets()
    }

    private func setUpNavigationBar() {
        self.title = "회원가입"
    }

    private func configureTableView() {
        tosView.tableView.delegate = self
        tosView.tableView.dataSource = self
    }

    private func addTargets() {
        tosView.allAgreeCheckButton.addTarget(self, action: #selector(allAgreeCheckButtonTapped), for: .touchUpInside)
        tosView.finalAgreeCheckButton.addTarget(self, action: #selector(finalAgreeCheckButtonTapped), for: .touchUpInside)
        tosView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc private func nextButtonTapped() {
        if isKakaoSignUp {
            let AcademicVerificationVC = AcademicVerificationViewController()
            navigationController?.pushViewController(AcademicVerificationVC, animated: true)
        } else {
            let EmailSignUpVC = EmailSignUpViewController()
            navigationController?.pushViewController(EmailSignUpVC, animated: true)
        }
    }


    @objc private func allAgreeCheckButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isSelected = sender.isSelected
        tosView.tableView.visibleCells.compactMap { $0 as? TOSTableViewCell }.forEach { $0.checkButton.isSelected = isSelected }
        tosView.finalAgreeCheckButton.isSelected = isSelected
        updateNextButtonState()
    }

    @objc private func finalAgreeCheckButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if !sender.isSelected { tosView.allAgreeCheckButton.isSelected = false }
        else if tosView.allChecked { tosView.allAgreeCheckButton.isSelected = true }
        updateNextButtonState()
    }

    @objc private func checkButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if !sender.isSelected { tosView.allAgreeCheckButton.isSelected = false }
        else if tosView.allChecked && tosView.finalAgreeCheckButton.isSelected {
            tosView.allAgreeCheckButton.isSelected = true
        }
        updateNextButtonState()
    }

    private func updateNextButtonState() {
        let allSelected = tosView.allChecked && tosView.finalAgreeCheckButton.isSelected
        tosView.nextButton.isEnabled = allSelected
        tosView.nextButton.backgroundColor = allSelected ? .orange700 : .gray200
        tosView.nextButton.setTitleColor(allSelected ? .white : .gray500, for: .normal)
    }
}

extension TOSViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consent.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TOSTableViewCell", for: indexPath) as? TOSTableViewCell else { return UITableViewCell() }
        cell.consentLabel.text = consent[indexPath.row]
        cell.checkButton.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

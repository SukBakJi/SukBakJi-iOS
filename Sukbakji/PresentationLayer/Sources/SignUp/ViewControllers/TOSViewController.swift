//
//  TOSViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 8/5/24.
//

import UIKit

protocol TOSCellDelegate: AnyObject {
    func didTapReadMore(in cell: TOSTableViewCell)
}

class TOSViewController: UIViewController, TOSCellDelegate {
    // MARK: - Properties
    public var isOAuth2: Bool = false
    public var appleName: String? // Apple 로그인일 경우 이름
    private var allChecked: Bool {
        return tosView.tableView.visibleCells
            .compactMap { $0 as? TOSTableViewCell }
            .allSatisfy { $0.checkButton.isSelected }
    }
    
    // MARK: - view
    private lazy var tosView = TOSView().then {
        $0.finalAgreeCheckButton.addTarget(self, action: #selector(finalAgreeCheckButtonTapped), for: .touchUpInside)
        $0.AllAgreeCheckButton.addTarget(self, action: #selector(AllAgreeCheckButtonTapped), for: .touchUpInside)
        $0.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
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
        self.title = "회원가입"
        
        updateNextButtonState()
    }
    
    // MARK: - Delegate Method
    // 각 이용약관 페이지 이동
    func didTapReadMore(in cell: TOSTableViewCell) {
        guard let indexPath = tosView.tableView.indexPath(for: cell) else { return }
        
        let tosData = TOSData.data()[indexPath.row]
        let nextVC = DetailTOSViewController(tosData: tosData)
        navigationController?.pushViewController(nextVC, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil).then {
            $0.tintColor = .black
        }
    }
    
    
    // MARK: - Functional
    private func pushToNextVC(_ nextVC: UIViewController) {
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil).then {
            $0.tintColor = .black
        }
    }
    
    private func updateNextButtonState() {
        let allSelected = allChecked && tosView.finalAgreeCheckButton.isSelected
        tosView.nextButton.isEnabled = allSelected
        tosView.nextButton.backgroundColor = allSelected ? .orange700 : .gray200
        tosView.nextButton.setTitleColor(allSelected ? .white : .gray500, for: .normal)
    }
    
    //MARK: Event
    @objc
    private func nextButtonTapped() {
        if isOAuth2 {
            let vc = AcademicVerificationViewController()
            vc.preFilledName = appleName // ← 전달
            pushToNextVC(vc)
        } else {
            pushToNextVC(SMSAuthViewController())
        }
        
    }
    
    @objc
    func finalAgreeCheckButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if !sender.isSelected {
            tosView.AllAgreeCheckButton.isSelected = false
        } else if allChecked {
            tosView.AllAgreeCheckButton.isSelected = true
        }
        updateNextButtonState()
    }
    
    @objc
    func AllAgreeCheckButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isSelected = sender.isSelected
        
        tosView.tableView.visibleCells
            .compactMap { $0 as? TOSTableViewCell }
            .forEach { $0.checkButton.isSelected = isSelected }
        
        tosView.finalAgreeCheckButton.isSelected = isSelected
        updateNextButtonState()
    }
    
    @objc
    func checkButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if !sender.isSelected {
            tosView.AllAgreeCheckButton.isSelected = false
        } else if allChecked && tosView.finalAgreeCheckButton.isSelected {
            tosView.AllAgreeCheckButton.isSelected = true
        }
        updateNextButtonState()
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}

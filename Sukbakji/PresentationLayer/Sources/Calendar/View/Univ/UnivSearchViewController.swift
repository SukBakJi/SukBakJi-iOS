//
//  UnivSearchViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 12/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UnivSearchViewController: UIViewController, UITextFieldDelegate {
    
    private let univSearchView = UnivSearchView()
    private let viewModel = UnivViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = univSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
}

extension UnivSearchViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        univSearchView.deleteButton.rx.tap
                    .bind { [weak self] in self?.univSearchView.univSearchTextField.text = "" }
                    .disposed(by: disposeBag)
        univSearchView.backButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
        univSearchView.nextButton.addTarget(self, action: #selector(clickNextButton), for: .touchUpInside)

        bindTableView()
    }
    
    @objc private func clickXButton() {
        let univStopView = UnivStopView(target: self, num: 2)
        self.view.addSubview(univStopView)
        univStopView.alpha = 0
        univStopView.snp.makeConstraints { $0.edges.equalToSuperview() }
        UIView.animate(withDuration: 0.3) { univStopView.alpha = 1 }
    }
    
    @objc private func clickNextButton() {
        guard let selectedUniv = viewModel.selectUnivItem.value else { return }
        let univRecruitVC = UnivRecruitViewController(univName: selectedUniv.name, univId: selectedUniv.id)
        self.navigationController?.pushViewController(univRecruitVC, animated: true)
    }
    
    @objc private func delete_Tapped() {
        univSearchView.univSearchTextField.text = ""
    }
}

extension UnivSearchViewController {
    private func bindTableView() {
        univSearchView.univSearchTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        univSearchView.univSearchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keyword in
                guard !keyword.isEmpty else { return }
                self?.viewModel.loadUnivSearch(keyword: keyword)
            })
            .disposed(by: disposeBag)
        
        viewModel.univSearchList
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                self.univSearchView.univSearchTableView.isHidden = list.isEmpty
                self.univSearchView.searchWarningImageView.isHidden = !list.isEmpty
                self.univSearchView.searchWarningLabel.isHidden = !list.isEmpty
                self.univSearchView.searchWarningLabel.text = "\(univSearchView.univSearchTextField.text ?? "")대학교에 대한 검색 결과가 없어요"
            })
            .disposed(by: disposeBag)
        
        viewModel.univSearchList
            .bind(to: univSearchView.univSearchTableView.rx.items(cellIdentifier: UnivSearchTableViewCell.identifier, cellType: UnivSearchTableViewCell.self)) { row, univ, cell in
                cell.prepare(uniSearchList: univ)
                
                self.viewModel.selectUnivItem
                    .map { $0 == univ }
                    .bind(to: cell.isSelectedCell)
                    .disposed(by: cell.disposeBag)
                
                cell.selectButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        self.viewModel.selectUniversity(univ)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        viewModel.selectUnivItem
            .subscribe(onNext: { [weak self] selectedUniv in
                self?.updateSelectionUI(selectedUniv)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateSelectionUI(_ selectedUniv: UnivSearchList?) {
        let isSelected = selectedUniv != nil
        univSearchView.nextButton.isEnabled = isSelected
        univSearchView.nextButton.setBackgroundColor(isSelected ? .orange700 : .gray200, for: .normal)
        univSearchView.nextButton.setTitleColor(isSelected ? .white : .gray500, for: .normal)
        univSearchView.univSearchTextField.text = selectedUniv?.name
    }
}

extension UnivSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

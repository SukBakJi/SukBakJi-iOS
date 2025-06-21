//
//  LabSearchViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 6/18/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LabSearchViewController: UIViewController {
    
    private let labSearchView = LabSearchView()
    private let viewModel = DirectoryViewModel()
    private let disposeBag = DisposeBag()
    
    private let recentSearchKey = "RecentSearchKeywords"
    private var recentKeywords = BehaviorRelay<[String]>(value: [])
    
    override func loadView() {
        self.view = labSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindViewModel()
        hideKeyboardWhenTappedAround()
        recentKeywords.accept(loadSearchKeywords())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        labSearchView.cancelButton.addTarget(self, action: #selector(backButton_Tapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let targetView = labSearchView.adView
        
        UIView.animate(withDuration: duration) {
            targetView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
        }
        
        labSearchView.adImageView.isHidden = false
    }
    
    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let targetView = labSearchView.adView
        
        UIView.animate(withDuration: duration) {
            targetView.transform = .identity
        }
        
        labSearchView.adImageView.isHidden = true
    }
}
    
extension LabSearchViewController {
    
    private func bindViewModel() {
        labSearchView.labRecentCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        recentKeywords
            .bind(to: labSearchView.labRecentCollectionView.rx.items(cellIdentifier: LabRecentCollectionViewCell.identifier, cellType: LabRecentCollectionViewCell.self)) { row, keyword, cell in
                cell.configure(keyword: keyword)
                cell.onDeleteTapped = {
                    self.deleteKeyword(keyword)
                }
            }
            .disposed(by: disposeBag)
        
        recentKeywords
            .map { !$0.isEmpty }
            .bind(to: labSearchView.noResultLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        labSearchView.labSearchTextField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(labSearchView.labSearchTextField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] query in
                guard !query.isEmpty else { return }
                self?.saveSearchKeyword(query)
                self?.labSearchView.labRecentCollectionView.reloadData()
                self?.labSearchView.labSearchTextField.text = ""
            })
            .disposed(by: disposeBag)
    }
    
    private func deleteKeyword(_ keyword: String) {
        var keywords = recentKeywords.value
        keywords.removeAll { $0 == keyword }
        UserDefaults.standard.setValue(keywords, forKey: recentSearchKey)
        recentKeywords.accept(keywords)
    }
    
    private func saveSearchKeyword(_ keyword: String) {
        var keywords = UserDefaults.standard.stringArray(forKey: recentSearchKey) ?? []
        keywords.removeAll(where: { $0 == keyword })
        keywords.insert(keyword, at: 0)
        keywords = Array(keywords.prefix(10))
        UserDefaults.standard.setValue(keywords, forKey: recentSearchKey)
        
        recentKeywords.accept(keywords)
    }
    
    private func loadSearchKeywords() -> [String] {
        return UserDefaults.standard.stringArray(forKey: recentSearchKey) ?? []
    }
    
    @objc private func backButton_Tapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LabSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items = recentKeywords.value
        
        if collectionView == labSearchView.labRecentCollectionView {
            guard indexPath.item < items.count else {
                return CGSize(width: 40, height: 29) // 기본 사이즈 반환
            }
            let label = UILabel().then {
                $0.text = String(items[indexPath.item])
                $0.sizeToFit()
            }
            let size = label.frame.size
            return CGSize(width: size.width + 52, height: 29)
        } else {
            guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
                return CGSize.zero
            }
            
            let value = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing)) / 2
            return CGSize(width: value, height: 172)
        }
    }
}

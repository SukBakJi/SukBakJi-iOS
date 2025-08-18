//
//  UnivRecruitViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 12/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import DropDown

class UnivRecruitViewController: UIViewController {
    
    private let memberId = UserDefaults.standard.integer(forKey: "memberID")
    private let univRecruitView = UnivRecruitView()
    private let viewModel = UnivViewModel()
    private let univDetailViewModel = UnivDetailViewModel()
    private let disposeBag = DisposeBag()
    private lazy var drop: DropDown = DropDownFactory.make(anchor: univRecruitView.recruitTypeTextField)
    private var didSetupDropDowns = false
    
    private var univName: String?
    private var univId: Int?
    
    override func loadView() {
        self.view = univRecruitView
    }
    
    init(univName: String, univId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.univName = univName
        self.univId = univId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
extension UnivRecruitViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        univRecruitView.dateSelectLabel.text = "\(univName ?? "") 일정을 선택해 주세요"
        
        univRecruitView.backButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
    }
    
    private func setDropdown() {
        drop.selectionAction = { [weak self] (index, item) in
            self?.univRecruitView.recruitTypeTextField.text = "\(item)"
            self?.univRecruitView.warningTypeLabel.isHidden = true
            self?.univRecruitView.warningImageView.isHidden = true
            self?.updateButtonColor()
            self?.univRecruitView.recruitTypeTextField.backgroundColor = .gray100
            self?.univRecruitView.recruitTypeTextField.setPlaceholderColor(.gray500)
            self?.univRecruitView.recruitTypeTextField.updateUnderlineColor(to: .gray300)
            self?.univRecruitView.recruitLabel.text = "\(item)"
            self?.univRecruitView.recruitLabel.textColor = .orange700
        }
    }
}
    
extension UnivRecruitViewController {
    
    private func setAPI() {
        bindViewModel()
        viewModel.loadUnivMethod(univId: univId ?? 0)
    }
    
    private func bindViewModel() {
        viewModel.recruitTypes
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in self?.drop.dataSource = $0 })
            .disposed(by: disposeBag)
        
        univRecruitView.dropButton.rx.tap
            .bind(onNext: { [weak self] in self?.drop.show() })
            .disposed(by: disposeBag)
        
        univRecruitView.nextButton.rx.tap
            .bind { [weak self] in self?.showEnrollAlert() }
            .disposed(by: disposeBag)
        
        univDetailViewModel.univCreated
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isSuccess in
                if isSuccess {
                    self?.navigateToHome()
                } else {
                    AlertController(message: "대학교 등록에 실패했습니다. 다시 시도해주세요.").show()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension UnivRecruitViewController {
    
    private func updateButtonColor() {
        let isFormValid = !(univRecruitView.recruitTypeTextField.text?.isEmpty ?? true)
        univRecruitView.nextButton.isEnabled = isFormValid
        univRecruitView.nextButton.setBackgroundColor(isFormValid ? .orange700 : .gray200, for: .normal)
        univRecruitView.nextButton.setTitleColor(isFormValid ? .white : .gray500, for: .normal)
    }
    
    private func showEnrollAlert() {
        AlertController(message: "대학교를 등록하시겠어요?", isCancel: true) { [weak self] in
            self?.univDetailViewModel.createUniv(
                memberId: self!.memberId,
                univId: self!.univId!,
                season: self?.univRecruitView.recruitTitleLabel.text ?? "",
                method: self?.univRecruitView.recruitTypeTextField.text ?? "")
        }.show()
    }
    
    private func navigateToHome() {
        if let navigationController = self.navigationController {
            if let targetViewController = navigationController.viewControllers.dropLast(2).last {
                navigationController.popToViewController(targetViewController, animated: true)
            }
        }
    }
    
    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            self.updateButtonColor()
        }
        return true
    }
    
    @objc private func clickXButton() {
        let univStopView = UnivStopView(target: self, num: 3)
        self.view.addSubview(univStopView)
        univStopView.alpha = 0
        univStopView.snp.makeConstraints { $0.edges.equalToSuperview() }
        UIView.animate(withDuration: 0.3) { univStopView.alpha = 1 }
    }
}

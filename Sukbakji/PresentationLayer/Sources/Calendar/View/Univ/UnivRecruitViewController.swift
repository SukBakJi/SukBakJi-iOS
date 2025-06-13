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
    private let disposeBag = DisposeBag()
    private let drop = DropDown()
    
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
        initUI()
        setDropdown()
        setAPI()
        print(memberId)
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
        univRecruitView.dropButton.addTarget(self, action: #selector(drop_Tapped), for: .touchUpInside)
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
        drop.anchorView = univRecruitView.recruitTypeTextField
        drop.bottomOffset = CGPoint(x: 0, y: 45.5 + univRecruitView.recruitTypeTextField.bounds.height)
        drop.shadowColor = .clear
        
        drop.cellConfiguration = { (index, item) in
            return "  \(item)" // 앞에 4칸 공백 추가
        }
        
        drop.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            
            guard index != (self.drop.dataSource.count) - 1 else { return }

            let separator = UIView()
            separator.backgroundColor = .gray300
            separator.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(separator)

            let separatorHeight: CGFloat = 1.5 // 원하는 굵기 설정
            
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: separatorHeight)
            ])
        }
        
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
            .subscribe(onNext: { typeList in self.drop.dataSource = self.viewModel.recruitTypes.value })
            .disposed(by: disposeBag)
        
        univRecruitView.nextButton.rx.tap
            .bind { [weak self] in self?.showEnrollAlert() }
            .disposed(by: disposeBag)
        
        viewModel.univEnrolled
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
            self?.viewModel.enrollUniv(
                memberId: self?.memberId,
                univId: self?.univId,
                season: self?.univRecruitView.recruitTitleLabel.text,
                method: self?.univRecruitView.recruitTypeTextField.text)
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
    
    @objc private func drop_Tapped() {
        drop.show()
    }
    
    @objc private func clickXButton() {
        let univStopView = UnivStopView(target: self, num: 3)
        self.view.addSubview(univStopView)
        univStopView.alpha = 0
        univStopView.snp.makeConstraints { $0.edges.equalToSuperview() }
        UIView.animate(withDuration: 0.3) { univStopView.alpha = 1 }
    }
}

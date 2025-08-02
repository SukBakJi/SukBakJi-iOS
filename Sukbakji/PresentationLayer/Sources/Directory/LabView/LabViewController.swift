//
//  LabViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/2/25.
//

import UIKit
import SnapKit
import Then

class LabViewController: UIViewController {
    
    private let optionNavigationbarView = OptionNavigationBarView(title: "연구실 정보", buttonHidden: false)
    private let classifyView = UIView().then {
        $0.backgroundColor = .white
    }
    private let writingButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Write"), for: .normal)
    }
    var labId: Int = 0
    
    init(labId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.labId = labId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = false
        }
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        optionNavigationbarView.delegate = self
        self.view.addSubview(optionNavigationbarView)
        optionNavigationbarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(95)
        }
        
        self.view.addSubview(classifyView)
        classifyView.snp.makeConstraints { make in
            make.top.equalTo(optionNavigationbarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        let childVC = LabTabViewController(labId: labId)
        addChild(childVC)
        classifyView.addSubview(childVC.view)
        childVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        childVC.didMove(toParent: self)
        
        optionNavigationbarView.optionButton.addTarget(self, action: #selector(option_Tapped), for: .touchUpInside)
        
        self.view.addSubview(writingButton)
        writingButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(120)
            make.trailing.bottom.equalToSuperview().inset(24)
            make.width.height.equalTo(60)
        }
        writingButton.addTarget(self, action: #selector(writing_Tapped), for: .touchUpInside)
    }
    
    @objc private func option_Tapped() {
        let alert = UIAlertController(title: "연구실 정보",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let inquiry = UIAlertAction(title: "수정 문의하기", style: .default) { _ in
            let labInquiryVC = LabInquiryViewController(labId: self.labId)
            self.navigationController?.pushViewController(labInquiryVC, animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(inquiry)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    @objc private func writing_Tapped() {
        let reviewWritingVC = ReviewWritingViewController(labId: labId)
        self.navigationController?.pushViewController(reviewWritingVC, animated: true)
    }
}

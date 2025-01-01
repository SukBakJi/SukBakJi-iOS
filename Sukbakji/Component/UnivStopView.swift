//
//  UnivStopView.swift
//  Sukbakji
//
//  Created by jaegu park on 1/1/25.
//

import UIKit

final class UnivStopView: UIView {
    private var num: Int = 1
    private weak var targetViewController: UIViewController?
    
    var mainView = UIView().then {
       $0.backgroundColor = .white
       $0.layer.cornerRadius = 12
    }
    var titleLabel = UILabel().then {
        $0.text = "이동하면 내용이 사라져요"
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    var stopLabel = UILabel().then {
        $0.text = "페이지를 이탈하면 현재 입력한 내용이 사라져요. 그래도 메인 페이지로 이동할까요?"
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    }
    var cancelButton = UIButton().then {
        $0.tintColor = .clear
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(UIColor(hexCode: "EFEFEF"), for: .normal)
    }
    var okButton = UIButton().then {
        $0.tintColor = .clear
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.setTitle("이동할게요", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(UIColor(named: "Coquelicot")!, for: .normal)
    }
    private lazy var buttonStackView = UIStackView().then {
        $0.addArrangedSubview(cancelButton)
        $0.addArrangedSubview(okButton)
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    init(target: UIViewController, num: Int) {
       super.init(frame: .zero)
       self.targetViewController = target
       self.num = num
       setUI()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        self.addSubview(mainView)
        self.mainView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(48)
            make.height.equalTo(203)
        }
        
        self.mainView.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(21)
        }
        
        self.mainView.addSubview(stopLabel)
        self.stopLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(254)
            make.height.equalTo(40)
        }
        let fullText = stopLabel.text ?? ""
        let changeText = "메인"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "Coquelicot")!, range: nsRange)
        }
        stopLabel.attributedText = attributedString
        
        self.mainView.addSubview(buttonStackView)
        self.buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(stopLabel.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        self.okButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
       if let target = targetViewController {
          setBackButtonTarget(target: target, num: num)
       }
    }
    
    @objc private func dismissView() {
       UIView.animate(withDuration: 0.3, animations: {
          self.alpha = 0
       }) { _ in
          self.removeFromSuperview() // 애니메이션 후 뷰에서 제거
       }
    }
    
    func setBackButtonTarget(target: UIViewController, num: Int) {
        if let navigationController = target.navigationController {
            let viewControllers = navigationController.viewControllers
            if viewControllers.count > 1 {
                let previousViewController = viewControllers[viewControllers.count - num]
                self.removeFromSuperview()
                navigationController.popToViewController(previousViewController, animated: true)
            }
        }
    }
}

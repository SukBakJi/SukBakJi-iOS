//
//  UnivStopView.swift
//  Sukbakji
//
//  Created by jaegu park on 1/1/25.
//

import UIKit
import Then
import SnapKit

final class UnivStopView: UIView {
    private var num: Int = 1
    private weak var targetViewController: UIViewController?
    
    var mainView = UIView().then {
       $0.backgroundColor = .white
       $0.layer.cornerRadius = 12
    }
    var titleLabel = UILabel().then {
        $0.text = "이동하면 내용이 사라져요"
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    var stopLabel = UILabel().then {
        $0.text = "페이지를 이탈하면 현재 입력한 내용이 사라져요. 그래도 메인 페이지로 이동할까요?"
        $0.textColor = .gray900
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    }
    var cancelButton = UIButton().then {
        $0.tintColor = .clear
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(UIColor.gray500, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(UIColor.gray200, for: .normal)
    }
    var okButton = UIButton().then {
        $0.tintColor = .clear
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.setTitle("이동할게요", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(.orange700, for: .normal)
    }
    lazy var buttonStackView = UIStackView().then {
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
        backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(48)
            $0.height.equalTo(203)
        }
        
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        mainView.addSubview(stopLabel)
        stopLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(254)
            $0.height.equalTo(40)
        }
        let fullText = stopLabel.text ?? ""
        let changeText = "메인"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        stopLabel.attributedText = attributedString
        
        mainView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(stopLabel.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        
        okButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
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

//
//  DoubleButtonPopup.swift
//  Sukbakji
//
//  Created by 오현민 on 3/10/25.
//

import UIKit

class DoubleButtonPopup: UIView {
    //MARK: - properties
    private var title: String
    private var desc: String
    private var range: String
    private var confirmText: String
    private var cancleText: String
    private var confirmAction: (() -> Void)? // 버튼 클릭 시 실행할 클로저
    
    //MARK: - init
    init(
        title: String,
        desc: String,
        range: String = "",
        confirmText: String,
        cancleText: String,
        confirmAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.desc = desc
        self.range = range
        self.confirmText = confirmText
        self.cancleText = cancleText
        super.init(frame: UIScreen.main.bounds)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        cancleButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - components
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = title
        $0.font = .head2()
        $0.textColor = .gray900
        $0.textAlignment = .center
    }
    
    private lazy var descLabel = UILabel().then {
        $0.font = .popup()
        $0.textColor = .gray800
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    public lazy var confirmButton = OrangeButton(title: confirmText)
    public lazy var cancleButton = OrangeButton(title: cancleText).then {
        $0.titleLabel?.font = .body2()
        $0.setButtonState(isEnabled: false)
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 16
    }
    
    private func updateDescLabel() {
        let text = desc
        let attributedString = NSMutableAttributedString(string: text)

        if !range.isEmpty {
            let rangeValue = (text as NSString).range(of: range)
            
            if rangeValue.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: rangeValue)
            }
        }

        descLabel.attributedText = attributedString
    }

    private func setUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.20)
        stackView.setCustomSpacing(26, after: descLabel)
        updateDescLabel()
        
        self.addSubview(containerView)
        containerView.addSubview(stackView)
        buttonStackView.addArrangedSubViews([cancleButton, confirmButton])
        stackView.addArrangedSubViews([titleLabel, descLabel, buttonStackView])
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(48)
        }
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(24)
        }
    }
    
    //MARK: - functional
    public func show() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        window.addSubview(self)
        
        
        self.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        })
    }
    
    // dismiss + 다른동작(다음화면)
    @objc private func confirmButtonTapped() {
        dismissPopup()
        confirmAction?()
    }
    
    // dismiss 만 필요한 경우
    @objc private func dismissPopup() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

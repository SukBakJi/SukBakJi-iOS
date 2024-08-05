//
//  UploadCompletedPopUpViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 7/27/24.
//

import UIKit

class UploadCompletedPopUpViewController: UIViewController {
    private var popupView: PopUpView!
    var onClose: (() -> Void)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopupView()
    }
    
    private func setupPopupView() {
        popupView = PopUpView()
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.popupView.onClose = { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.onClose?()
            })
        }
    }
    
    private class PopUpView: UIView {
        private let popupView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
        private let titleLabel = UILabel().then {
            $0.text = "학력 인증을 진행하고 있어요"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        private let descLabel = UILabel().then {
            let fullText = "인증을 위해서는 주말과 공휴일을 제외하고 최대\n3일이 소요될 수 있습니다.\n인증이 완료되면 푸시 알림을 보낼게요"
            let attributedString = NSMutableAttributedString(string: fullText)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(.kern, value: -0.5, range: NSMakeRange(0, attributedString.length))
            
            $0.attributedText = attributedString
            $0.textAlignment = .left
            $0.font = UIFont(name: "Pretendard-Regular", size: 14)
            $0.textColor = .gray800
            $0.numberOfLines = 3
        }
        private let confirmButton = UIButton().then {
            $0.setTitle("확인했어요", for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
            $0.titleLabel?.textAlignment = .center
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .orange700
            $0.setTitleColor(.white, for: .normal)
            $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        }
        var onClose: (() -> Void)?
        
        init() {
            super.init(frame: .zero)
            self.backgroundColor = .black.withAlphaComponent(0.2)
            
            setupViews()
            setupLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc private func confirmButtonTapped() {
            onClose?()
        }
        
        private func setupViews() {
            addSubview(popupView)
            popupView.addSubview(titleLabel)
            popupView.addSubview(descLabel)
            popupView.addSubview(confirmButton)
        }
        
        private func setupLayout() {
            popupView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(294)
                make.height.equalTo(219)
            }
            titleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(24)
            }
            
            descLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(16)
                make.centerX.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
            }
            
            confirmButton.snp.makeConstraints { make in
                make.top.equalTo(descLabel.snp.bottom).offset(26)
                make.centerX.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(48)
            }
            
        }
    }
}

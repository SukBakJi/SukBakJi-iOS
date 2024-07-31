//
//  PopUpViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 7/27/24.
//

import Foundation
import UIKit
import SnapKit
import Then

class PopUpViewController: UIViewController {
    
    private let desc: String
    private let rangeText: String
    private var popupView: PopUpView!
    
    var onMove: (() -> Void)?

    init(desc: String, rangeText: String) {
        self.desc = desc
        self.rangeText = rangeText
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
        popupView = PopUpView(desc: desc, rangeText: rangeText)
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.popupView.onClose = { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
        
        self.popupView.onMove = { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.onMove?()
            })
        }
    }
    
    private class PopUpView: UIView {
        
        private let popupView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
        }
        private let buttonView = UIView()
        
        private let titleLabel = UILabel().then {
            $0.text = "이동하면 이미지가 사라져요"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        private let descLabel = UILabel().then {
            $0.textAlignment = .left
            $0.font = UIFont(name: "Pretendard-Regular", size: 14)
            $0.textColor = .gray800
            $0.numberOfLines = 2
        }
        private let closeButton = UIButton().then {
            $0.setTitle("닫기", for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
            $0.titleLabel?.textAlignment = .center
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .gray200
            $0.setTitleColor(.gray500, for: .normal)
            $0.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        }
        private let moveButton = UIButton().then {
            $0.setTitle("이동할게요", for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
            $0.titleLabel?.textAlignment = .center
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .orange700
            $0.setTitleColor(.white, for: .normal)
            $0.addTarget(self, action: #selector(moveButtonTapped), for: .touchUpInside)
        }
        
        var onClose: (() -> Void)?
        var onMove: (() -> Void)?
        
        init(desc: String, rangeText: String) {
            super.init(frame: .zero)
            
            let fullText = desc
            let attributedString = NSMutableAttributedString(string: fullText)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            let rangeText = (fullText as NSString).range(of: rangeText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: rangeText)
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(.kern, value: -0.5, range: NSMakeRange(0, attributedString.length))
            self.descLabel.attributedText = attributedString
            
            self.backgroundColor = .black.withAlphaComponent(0.2)
            
            setupViews()
            setupLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc private func closeButtonTapped() {
            onClose?()
        }
        
        @objc private func moveButtonTapped() {
            onMove?()
        }
        
        private func setupViews() {
            addSubview(popupView)
            popupView.addSubview(titleLabel)
            popupView.addSubview(descLabel)
            popupView.addSubview(buttonView)
            buttonView.addSubview(closeButton)
            buttonView.addSubview(moveButton)
        }
        
        private func setupLayout() {
            popupView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(294)
                make.height.equalTo(203)
            }
            titleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(24)
            }
            
            descLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
            }
            
            buttonView.snp.makeConstraints { make in
                make.top.equalTo(descLabel.snp.bottom).offset(16)
                make.centerX.equalToSuperview()
                make.width.equalTo(252)
                make.bottom.equalToSuperview().inset(20)
            }
            
            closeButton.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(10)
                make.width.equalTo(120)
                make.height.equalTo(48)
            }
            
            moveButton.snp.makeConstraints { make in
                make.top.equalTo(closeButton)
                make.leading.equalTo(closeButton.snp.trailing).offset(12)
                make.width.equalTo(120)
                make.height.equalTo(48)
            }
        }
    }
}

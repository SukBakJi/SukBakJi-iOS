//
//  OptionNavigationBarView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/3/25.
//

import UIKit
import Then
import SnapKit

class OptionNavigationBarView: UIView {
    
    var backButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Back"), for: .normal)
    }
    var titleLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
    }
    var optionButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Menu"), for: .normal)
    }
    
    weak var delegate: NavigationBarViewDelegate?
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        backgroundColor = .white
        
        addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        addSubview(optionButton)
        optionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        delegate?.didTapBackButton()
    }
}

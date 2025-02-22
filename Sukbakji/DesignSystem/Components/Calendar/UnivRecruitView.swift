//
//  UnivRecruitView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/22/25.
//

import UIKit
import SnapKit
import Then

class UnivRecruitView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
    }
    
    private func setupConstraints() {
    }
}

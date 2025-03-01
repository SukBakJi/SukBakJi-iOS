//
//  EditAlarmView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/28/25.
//

import UIKit
import SnapKit
import Then

class EditAlarmView: UIView {
    
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

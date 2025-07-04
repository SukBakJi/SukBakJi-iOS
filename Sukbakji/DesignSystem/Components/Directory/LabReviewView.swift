//
//  LabReviewView.swift
//  Sukbakji
//
//  Created by jaegu park on 7/2/25.
//

import UIKit
import SnapKit
import Then

class LabReviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
    }
    
    private func setConstraints() {
    }
}

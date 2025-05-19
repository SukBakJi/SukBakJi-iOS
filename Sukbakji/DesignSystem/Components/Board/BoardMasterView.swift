//
//  BoardMasterView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class BoardMasterView: UIView {
    
    let boardSearchTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "게시판에서 궁금한 내용을 검색해 보세요!"
        $0.setPlaceholderColor(.gray300)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
        $0.layer.cornerRadius = 12
    }
    let searchImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_SearchImage")
    }
    
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
        
        addSubview(boardSearchTextField)
        addSubview(searchImageView)
    }
    
    private func setupConstraints() {
        boardSearchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(55)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        boardSearchTextField.setLeftPadding(52)
        boardSearchTextField.errorfix()
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(boardSearchTextField)
            $0.leading.equalToSuperview().offset(40)
            $0.height.width.equalTo(24)
        }
    }
}

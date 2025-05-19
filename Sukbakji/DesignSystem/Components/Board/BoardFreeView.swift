//
//  BoardFreeView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class BoardFreeView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
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
    let favBoardView = UIView().then {
        $0.backgroundColor = .clear
    }
    let favBoardLabel = UILabel().then {
        $0.text = "즐겨찾는 게시판"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let favBoardImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Favorite")
    }
    let layerView = UIView().then {
        $0.backgroundColor = .gray100
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
        
    }
    
    private func setupConstraints() {
    }
}

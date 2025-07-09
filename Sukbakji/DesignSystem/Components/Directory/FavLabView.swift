//
//  FavLabView.swift
//  Sukbakji
//
//  Created by jaegu park on 6/14/25.
//

import UIKit
import SnapKit
import Then

class FavLabView: UIView {
    
    var navigationbarView = NavigationBarView(title: "즐겨찾는 연구실")
    let editButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.gray900, for: .normal)
    }
    let selectView = UIView().then {
        $0.backgroundColor = .clear
    }
    let allSelectButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Check"), for: .normal)
    }
    let allSelectLabel = UILabel().then {
        $0.text = "전체선택 (0/5)"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let favLabTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(FavLabTableViewCell.self, forCellReuseIdentifier: FavLabTableViewCell.identifier)
    }
    let deleteButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.gray500, for: .disabled)
        $0.setTitle("삭제하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.orange700, for: .normal)
        $0.setBackgroundColor(.gray200, for: .disabled)
    }
    
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
        
        addSubview(navigationbarView)
        addSubview(editButton)
        
        addSubview(selectView)
        selectView.addSubview(allSelectButton)
        selectView.addSubview(allSelectLabel)
        selectView.addSubview(backgroundLabel)
        
        addSubview(favLabTableView)
        addSubview(deleteButton)
    }
    
    private func setConstraints() {
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(57)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(28)
            $0.width.equalTo(48)
        }
        
        selectView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(94)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        allSelectButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.height.width.equalTo(20)
        }
        
        allSelectLabel.snp.makeConstraints {
            $0.centerY.equalTo(allSelectButton)
            $0.leading.equalTo(allSelectButton.snp.trailing).offset(8)
            $0.height.equalTo(17)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        favLabTableView.snp.makeConstraints {
            $0.top.equalTo(selectView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(150)
        }
        
        deleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        deleteButton.isEnabled = false
    }
}


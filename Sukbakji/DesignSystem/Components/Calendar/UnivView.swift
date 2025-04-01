//
//  UnivView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/22/25.
//

import UIKit
import SnapKit
import Then

class UnivView: UIView {
    
    let navigationbarView = NavigationBarView(title: "대학별 일정")
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
    let selectDeleteButton = UIButton().then {
        $0.setTitle("선택삭제", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.gray500, for: .normal)
    }
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    var univCalendarTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.backgroundColor = .clear
        $0.register(UnivCalendarTableViewCell.self, forCellReuseIdentifier: UnivCalendarTableViewCell.identifier)
    }
    let selectCompleteButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.gray500, for: .disabled)
        $0.setTitle("선택완료", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.orange700, for: .normal)
        $0.setBackgroundColor(.gray200, for: .disabled)
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
        
        addSubview(navigationbarView)
        
        addSubview(selectView)
        selectView.addSubview(allSelectButton)
        selectView.addSubview(allSelectLabel)
        selectView.addSubview(selectDeleteButton)
        selectView.addSubview(backgroundLabel)
        
        addSubview(univCalendarTableView)
        
        addSubview(selectCompleteButton)
    }
    
    private func setupConstraints() {
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        selectView.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom)
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
        
        selectDeleteButton.snp.makeConstraints {
            $0.centerY.equalTo(allSelectButton)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(30)
            $0.width.equalTo(60)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        univCalendarTableView.snp.makeConstraints {
            $0.top.equalTo(selectView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        selectCompleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        selectCompleteButton.isEnabled = false
    }
}

//
//  UnivSearchView.swift
//  Sukbakji
//
//  Created by jaegu park on 2/22/25.
//

import UIKit
import SnapKit
import Then

class UnivSearchView: UIView {
    
    let titleView = UIView()
    let backButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Back"), for: .normal)
    }
    let titleLabel = UILabel().then {
        $0.text = "대학교 선택"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.textColor = .gray900
    }
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let univSelectView = UIView().then {
        $0.backgroundColor = .clear
    }
    let univSelectLabel = UILabel().then {
        $0.text = "대학교를 선택해 주세요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let maxSelectLabel = UILabel().then {
        $0.text = "최대 1개까지 선택할 수 있어요"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray500
    }
    let stepImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Progress1")
    }
    let selectImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_CalendarImage")
    }
    let univSearchTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "대학교명을 입력해 주세요"
        $0.setPlaceholderColor(.gray300)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
        $0.layer.cornerRadius = 12
    }
    let searchImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_SearchImage")
    }
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Delete"), for: .normal)
    }
    var univSearchTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.allowsMultipleSelection = false
        $0.register(UnivSearchTableViewCell.self, forCellReuseIdentifier: UnivSearchTableViewCell.identifier)
    }
    let searchWarningImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_NoResults")
    }
    let searchWarningLabel = UILabel().then {
        $0.text = "석박지대학교에 대한 검색 결과가 없어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let nextButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitleColor(.gray500, for: .disabled)
        $0.setTitle("다음으로", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.setBackgroundColor(.gray200, for: .normal)
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
        
        addSubview(titleView)
        titleView.addSubview(backButton)
        titleView.addSubview(titleLabel)
        addSubview(backgroundLabel)
        
        addSubview(univSelectView)
        univSelectView.addSubview(univSelectLabel)
        univSelectView.addSubview(maxSelectLabel)
        univSelectView.addSubview(stepImageView)
        univSelectView.addSubview(selectImageView)
        
        addSubview(univSearchTextField)
        addSubview(searchImageView)
        addSubview(deleteButton)
        
        addSubview(univSearchTableView)
        
        addSubview(searchWarningImageView)
        addSubview(searchWarningLabel)
        
        addSubview(nextButton)
    }
    
    private func setConstraints() {
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        univSelectView.snp.makeConstraints {
            $0.top.equalTo(backgroundLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(130)
        }
        
        univSelectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        maxSelectLabel.snp.makeConstraints {
            $0.top.equalTo(univSelectLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(17)
        }
        
        stepImageView.snp.makeConstraints {
            $0.top.equalTo(maxSelectLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(20)
            $0.width.equalTo(100)
        }
        
        selectImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(100)
            $0.width.equalTo(93)
        }
        selectImageView.alpha = 0.5
        
        univSearchTextField.snp.makeConstraints {
            $0.top.equalTo(univSelectView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        univSearchTextField.setLeftPadding(52)
        univSearchTextField.errorfix()
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(univSearchTextField)
            $0.leading.equalToSuperview().offset(40)
            $0.height.width.equalTo(24)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(univSearchTextField)
            $0.trailing.equalToSuperview().inset(34)
            $0.height.width.equalTo(24)
        }
        deleteButton.isHidden = true
        
        univSearchTableView.snp.makeConstraints {
            $0.top.equalTo(univSearchTextField.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchWarningImageView.snp.makeConstraints {
            $0.top.equalTo(univSearchTextField.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(32)
        }
        searchWarningImageView.isHidden = true
        
        searchWarningLabel.snp.makeConstraints {
            $0.top.equalTo(searchWarningImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        searchWarningLabel.isHidden = true
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        nextButton.isEnabled = false
    }
}

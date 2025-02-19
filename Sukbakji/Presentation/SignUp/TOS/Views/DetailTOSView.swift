//
//  DetailTOSView.swift
//  Sukbakji
//
//  Created by 오현민 on 2/19/25.
//

import UIKit

class DetailTOSView: UIView {
    //MARK: - Components
    lazy var tosText: String = ""
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "서비스 이용약관"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var dateLabel = UILabel().then {
        $0.text = "2025. 01. 08"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var tosTextView = UITextView().then {
        $0.text = tosText
        $0.textColor = .gray800
        $0.isEditable = false
        $0.isScrollEnabled = true
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - init
    init(tosText: String) {
        super.init(frame: .zero)
        self.tosText = tosText
        
        self.backgroundColor = .white
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 컴포넌트 추가
    private func setView() {
        addSubviews([titleLabel, dateLabel, tosTextView])
    }
    
    //MARK: - 레이아웃 설정
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(24)
        }
        
        tosTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(38)
            $0.leading.equalToSuperview().inset(24)
        }
    }
}

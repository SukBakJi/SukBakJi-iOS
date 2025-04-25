//
//  DetailTOSView.swift
//  Sukbakji
//
//  Created by 오현민 on 2/19/25.
//

import UIKit

class DetailTOSView: UIView {
    //MARK: - Properties
    private let tosData: TOSData
    
    //MARK: - Components
    private var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .gray900
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var dateLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var tosTextView = UITextView().then {
        $0.textColor = .gray800
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var scrollView = UIScrollView(frame: self.bounds).then{
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    //MARK: - init
    init(tosData: TOSData) {
        self.tosData = tosData
        super.init(frame: .zero)
        
        titleLabel.text = tosData.title
        dateLabel.text = tosData.date
        tosTextView.text = tosData.content
        
        self.backgroundColor = .white
        setView()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 컴포넌트 추가
    private func setView() {
        addSubview(scrollView)
        scrollView.addSubviews([titleLabel, dateLabel, tosTextView])
    }
    
    //MARK: - 레이아웃 설정
    private func setConstraints() {
        scrollView.snp.makeConstraints{
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        
        tosTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(38)
            $0.width.bottom.equalToSuperview()
        }
    }
}

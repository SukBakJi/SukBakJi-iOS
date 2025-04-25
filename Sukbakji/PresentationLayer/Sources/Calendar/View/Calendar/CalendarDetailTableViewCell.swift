//
//  CalendarDetailTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/12/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class CalendarDetailTableViewCell: UITableViewCell {

    static let identifier = String(describing: CalendarDetailTableViewCell.self)
    
    private var viewModel = UnivViewModel()
    private let disposeBag = DisposeBag()
    
    private let mainImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_RecruitType")
    }
    private let univLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    private let contentLabel = UILabel().then {
        $0.textColor = .orange700
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
       setUI()
    }
    
    private func setUI() {
        self.contentView.backgroundColor = .gray50
        self.contentView.backgroundColor = UIColor.gray50
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.gray200.cgColor
        self.contentView.clipsToBounds = false
        
        self.contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(4)
        }
        
        self.contentView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        self.contentView.addSubview(univLabel)
        univLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(mainImageView.snp.trailing).offset(8)
            make.height.equalTo(19)
        }
        
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(univLabel.snp.trailing).offset(8)
            make.height.equalTo(19)
        }
    }
    
    func prepare(dateSelectList: DateSelectList) {
        viewModel.loadUnivName(univId: dateSelectList.univId)
            .subscribe(onNext: { [weak self] univName in
                self?.univLabel.text = univName
            })
            .disposed(by: disposeBag)
        self.contentLabel.text = dateSelectList.content
    }
}

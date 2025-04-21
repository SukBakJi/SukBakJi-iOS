//
//  UpComingCalendarCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/12/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class UpComingCalendarCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: UpComingCalendarCollectionViewCell.self)
    
    private var viewModel = UnivViewModel()
    private let disposeBag = DisposeBag()
    
    private let layerImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Layer")
    }
    private let dDayLabel = UILabel().then {
        $0.textColor = .orange700
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let univLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let contentLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray100.cgColor
        contentView.clipsToBounds = false
        contentView.backgroundColor = .gray50
        
        layer.cornerRadius = 8
        layer.masksToBounds = false
        
        self.contentView.addSubview(layerImageView)
        layerImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(6)
        }
        
        self.contentView.addSubview(dDayLabel)
        dDayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(layerImageView.snp.trailing).offset(10)
            make.height.equalTo(15)
        }
        
        self.contentView.addSubview(univLabel)
        univLabel.snp.makeConstraints { make in
            make.top.equalTo(dDayLabel.snp.bottom).offset(4)
            make.leading.equalTo(layerImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }
        
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(univLabel.snp.bottom).offset(4)
            make.leading.equalTo(layerImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }
    }
    
    func prepare(upComingList: UpComingList) {
        dDayLabel.text = String(upComingList.dday)
        viewModel.loadUnivName(univId: upComingList.univId)
            .subscribe(onNext: { [weak self] univName in
                self?.univLabel.text = univName
            })
            .disposed(by: disposeBag)
        contentLabel.text = upComingList.content
    }
}

//
//  UnivSearchTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/12/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class UnivSearchTableViewCell: UITableViewCell {

    static let identifier = String(describing: UnivSearchTableViewCell.self)
    
    var disposeBag = DisposeBag()
    var isSelectedCell = BehaviorRelay<Bool>(value: false)
    
    let selectButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Check"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    let univLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        setUI()
        bindUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setUI() {
        self.contentView.addSubview(selectButton)
        selectButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        self.contentView.addSubview(univLabel)
        univLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(selectButton.snp.trailing).offset(16)
            make.height.equalTo(21)
        }
    }
    
    private func bindUI() {
        isSelectedCell
            .subscribe(onNext: { [weak self] isSelected in
                let imageName = isSelected ? "Sukbakji_Check2" : "Sukbakji_Check"
                self?.selectButton.setImage(UIImage(named: imageName), for: .normal)
                self?.univLabel.textColor = isSelected ? .orange700 : .gray900
            })
            .disposed(by: disposeBag)
    }

    func prepare(uniSearchList: UnivSearchList) {
        univLabel.text = uniSearchList.name
    }
}

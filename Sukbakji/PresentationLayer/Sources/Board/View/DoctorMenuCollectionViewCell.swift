//
//  DoctorMenuCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 5/19/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class DoctorMenuCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: DoctorMenuCollectionViewCell.self)
    
    var disposeBag = DisposeBag()
    var isSelectedCell = BehaviorRelay<Bool>(value: false)
    
    let labelButton = UIButton().then {
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.gray500, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setUI() {
        self.contentView.addSubview(labelButton)
        labelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    func prepare(text: String) {
        labelButton.setTitle(text, for: .normal)
    }
    
    private func bindUI() {
        isSelectedCell
            .subscribe(onNext: { [weak self] isSelected in
                self?.labelButton.backgroundColor = isSelected ? .orange50 : .gray50
                self?.labelButton.setTitleColor(isSelected ? .orange600 : .gray500, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}

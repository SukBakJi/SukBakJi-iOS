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
    
    private let selectButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Check"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    private let univLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
       setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // DisposeBag 재설정
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
    
    func bind(isSelected: Bool, buttonTap: @escaping () -> Void) {
        let imageName = isSelected ? "Sukbakji_Check2" : "Sukbakji_Check"
        selectButton.setImage(UIImage(named: imageName), for: .normal)
        
        selectButton.rx.tap
            .bind { buttonTap() } // 버튼 클릭 시 이벤트 전달
            .disposed(by: disposeBag)
    }

    func prepare(uniSearchList: UniSearchList) {
        univLabel.text = uniSearchList.name
    }
}

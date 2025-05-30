//
//  UnivCalendarTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 12/12/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

protocol UnivCalendarCellDelegate: AnyObject {
    func univDelete_Tapped(cell: UnivCalendarTableViewCell)
    func editButton_Tapped(cell: UnivCalendarTableViewCell)
    func select_Tapped(cell: UnivCalendarTableViewCell)
}

class UnivCalendarTableViewCell: UITableViewCell {

    static let identifier = String(describing: UnivCalendarTableViewCell.self)
    
    private let viewModel = UnivViewModel()
    private let calendarViewModel = CalendarViewModel()
    var disposeBag = DisposeBag()
    weak var delegate: UnivCalendarCellDelegate?
    
    let selectView = UIView().then {
        $0.backgroundColor = .gray50
    }
    let selectButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Check"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    let univLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Delete2"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    let recruitImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_RecruitType")
    }
    let recruitLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    let recruitTypeLabel = UILabel().then {
        $0.textColor = .orange700
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    let editButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setTitleColor(.gray400, for: .normal)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func setUI() {
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.gray200.cgColor
        self.contentView.clipsToBounds = true
        
        self.contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
        
        self.contentView.addSubview(selectView)
        selectView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        self.selectView.addSubview(selectButton)
        selectButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.height.width.equalTo(20)
        }
        selectButton.addTarget(self, action: #selector(select_Tapped), for: .touchUpInside)
        
        self.selectView.addSubview(univLabel)
        univLabel.snp.makeConstraints { make in
            make.centerY.equalTo(selectButton)
            make.leading.equalTo(selectButton.snp.trailing).offset(8)
            make.height.equalTo(19)
        }
        
        self.selectView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(selectButton)
            make.trailing.equalToSuperview().inset(10)
            make.height.width.equalTo(24)
        }
        deleteButton.addTarget(self, action: #selector(univDelete_Tapped), for: .touchUpInside)
        
        self.contentView.addSubview(recruitImageView)
        recruitImageView.snp.makeConstraints { make in
            make.top.equalTo(selectView.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(12)
            make.height.width.equalTo(20)
        }
        
        self.contentView.addSubview(recruitLabel)
        recruitLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recruitImageView)
            make.leading.equalTo(recruitImageView.snp.trailing).offset(8)
            make.height.equalTo(17)
        }
        
        self.contentView.addSubview(recruitTypeLabel)
        recruitTypeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recruitImageView)
            make.leading.equalTo(recruitLabel.snp.trailing).offset(6)
            make.height.equalTo(17)
        }
        
        self.contentView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(recruitImageView)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(24)
            make.width.equalTo(32)
        }
        editButton.addTarget(self, action: #selector(editButton_Tapped), for: .touchUpInside)
    }
    
    @objc private func select_Tapped() {
        delegate?.select_Tapped(cell: self)
    }
    
    @objc private func univDelete_Tapped() {
        delegate?.univDelete_Tapped(cell: self)
    }
    
    @objc private func editButton_Tapped() {
        delegate?.editButton_Tapped(cell: self)
    }
    
    func prepare(univList: UnivList) {
        recruitLabel.text = univList.season
        recruitTypeLabel.text = univList.method
        
        viewModel.loadUnivName(univId: univList.univId)
            .subscribe(onNext: { [weak self] univName in
                self?.univLabel.text = univName
            })
            .disposed(by: disposeBag)
    }
}

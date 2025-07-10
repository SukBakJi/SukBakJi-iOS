//
//  FavLabTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 6/15/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

protocol FavLabCellDelegate: AnyObject {
    func select_Tapped(cell: FavLabTableViewCell)
}

class FavLabTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: FavLabTableViewCell.self)
    
    weak var delegate: FavLabCellDelegate?
    var disposeBag = DisposeBag()
    
    let selectButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Check"), for: .normal)
    }
    private let labView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    private let univView = UIView().then {
        $0.backgroundColor = .white
    }
    private let univLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let labLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    private let professorImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_ProfileImage")
    }
    private let professorNameLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    }
    private let professorLabel = UILabel().then {
        $0.text = "교수"
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let professorLabLabel = UILabel().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let labView2 = UIView().then {
        $0.backgroundColor = .orange50
        $0.layer.cornerRadius = 4
    }
    private let labLabel2 = UILabel().then {
        $0.textColor = .orange600
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    private let labView3 = UIView().then {
        $0.backgroundColor = .orange50
        $0.layer.cornerRadius = 4
    }
    private let labLabel3 = UILabel().then {
        $0.textColor = .orange600
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
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
        contentView.addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.height.width.equalTo(20)
        }
        selectButton.addTarget(self, action: #selector(select_Tapped), for: .touchUpInside)
        
        contentView.addSubview(labView)
        labView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalTo(selectButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(172)
        }
        
        labView.addSubview(univView)
        univView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        univView.addSubview(univLabel)
        univLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(14)
        }
        
        univView.addSubview(labLabel)
        labLabel.snp.makeConstraints {
            $0.top.equalTo(univLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(18)
        }
        
        labView.addSubview(professorImageView)
        professorImageView.snp.makeConstraints {
            $0.top.equalTo(univView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(40)
        }
        
        labView.addSubview(professorNameLabel)
        professorNameLabel.snp.makeConstraints {
            $0.top.equalTo(univView.snp.bottom).offset(14.5)
            $0.leading.equalTo(professorImageView.snp.trailing).offset(12)
            $0.height.equalTo(17)
        }
        
        labView.addSubview(professorLabel)
        professorLabel.snp.makeConstraints {
            $0.centerY.equalTo(professorNameLabel)
            $0.leading.equalTo(professorNameLabel.snp.trailing).offset(4)
            $0.height.equalTo(14)
        }
        
        labView.addSubview(professorLabLabel)
        professorLabLabel.snp.makeConstraints {
            $0.top.equalTo(professorNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(professorImageView.snp.trailing).offset(12)
            $0.height.equalTo(14)
        }
        
        labView.addSubview(labView2)
        labView2.snp.makeConstraints {
            $0.top.equalTo(professorImageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(20)
        }
        
        labView2.addSubview(labLabel2)
        labLabel2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }
        
        labView.addSubview(labView3)
        labView3.snp.makeConstraints {
            $0.top.equalTo(professorImageView.snp.bottom).offset(12)
            $0.leading.equalTo(labView2.snp.trailing).offset(6)
            $0.height.equalTo(20)
        }
        
        labView3.addSubview(labLabel3)
        labLabel3.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(14)
        }
    }
    
    @objc private func select_Tapped() {
        delegate?.select_Tapped(cell: self)
    }

    func prepare(favoriteLab: FavoriteLab, showButton: Bool) {
        selectButton.isHidden = !showButton
        selectButton.snp.remakeConstraints {
            $0.height.width.equalTo(showButton ? 20 : 1)
        }
        
        univLabel.text = favoriteLab.universityName
        labLabel.text = favoriteLab.labName
        professorNameLabel.text = favoriteLab.professorName
        professorLabLabel.text = favoriteLab.departmentName
        labLabel2.text = "#\(favoriteLab.researchTopics[0])"
        if favoriteLab.researchTopics.count == 1 {
            labView3.isHidden = true
        } else {
            labLabel3.text = "#\(favoriteLab.researchTopics[1])"
        }
        
        layoutIfNeeded()
    }
}

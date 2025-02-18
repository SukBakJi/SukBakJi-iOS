//
//  TOSView.swift
//  Sukbakji
//
//  Created by 오현민 on 2/18/25.
//

import Foundation
import UIKit
import SnapKit
import Then

class TOSView: UIView {

    // MARK: - Properties
    var allChecked: Bool {
        return tableView.visibleCells
            .compactMap { $0 as? TOSTableViewCell }
            .allSatisfy { $0.checkButton.isSelected }
    }

    // MARK: - Label
    let titleLabel = UILabel().then {
        let fullText = "석박지를 사용하기 위해서\n아래의 약관 동의가 필요해요"
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let rangeText = (fullText as NSString).range(of: "약관 동의가 필요해요")
        attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: rangeText)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        $0.attributedText = attributedString
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }

    let subtitleLabel = UILabel().then {
        $0.text = "필수 약관을 동의해야 원활한 서비스 이용이 가능해요"
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.numberOfLines = 0
    }

    let descLabel = UILabel().then {
        $0.text = "• 만 14세 이상만 가입 가능\n  석박지는 국내 대학생/대학원생을 위한 서비스이며, 본인인증을 통해 만14세 이상만 가입할 수 있습니다. \n\n• 본인 명의 가입 필수\n  석박지는 철저한 학교 인증과 안전한 익명 커뮤니티를 제공하기 위해 가입 시 본인인증 수단을 통해 본인 여부를 확인하고, 커뮤니티 이용 시 증명 자료 제출을 통해 재학 여부를 확인합니다. 두 정보가 일치하지 않을 경우 서비스를 이용할 수 없습니다."
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.numberOfLines = 0
    }

    // MARK: - Button
    let nextButton = UIButton().then {
        $0.setTitle("다음으로", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray200
        $0.setTitleColor(.gray500, for: .normal)
    }

    // MARK: - HeaderView
    let allAgreeCheckButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_check=off"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_check=on"), for: .selected)
        $0.adjustsImageWhenHighlighted = false
    }

    let allAgreeLabel = UILabel().then {
        $0.text = "약관 전체 동의"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }

    private let allAgreeView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }

    // MARK: - FooterView
    let finalAgreeCheckButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_check=off"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_check=on"), for: .selected)
        $0.adjustsImageWhenHighlighted = false
    }

    let finalAgreeLabel = UILabel().then {
        let fullText = "만 14세 이상이며 본인 명의로 가입을 진행하겠습니다"
        let attributedString = NSMutableAttributedString(string: fullText)
        let rangeText = (fullText as NSString).range(of: "만 14세 이상")
        attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: rangeText)
        let rangeText2 = (fullText as NSString).range(of: "본인 명의로 가입")
        attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: rangeText2)
        $0.attributedText = attributedString
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    }

    private let finalAgreeView = UIView().then {
        $0.backgroundColor = .gray50
    }

    let tableView = UITableView().then {
        $0.register(TOSTableViewCell.self, forCellReuseIdentifier: "TOSTableViewCell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.isScrollEnabled = false
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Views
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(allAgreeView)
        allAgreeView.addSubview(allAgreeCheckButton)
        allAgreeView.addSubview(allAgreeLabel)
        addSubview(tableView)
        addSubview(finalAgreeView)
        finalAgreeView.addSubview(finalAgreeCheckButton)
        finalAgreeView.addSubview(finalAgreeLabel)
        addSubview(descLabel)
        addSubview(nextButton)
    }

    // MARK: - Layout Setup
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(24)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(24)
        }

        allAgreeView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }

        allAgreeCheckButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview().inset(16)
            make.width.height.equalTo(20)
        }

        allAgreeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(allAgreeCheckButton.snp.trailing).offset(12)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(allAgreeView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(208)
        }

        finalAgreeView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }

        finalAgreeCheckButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(40)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        finalAgreeLabel.snp.makeConstraints { make in
            make.leading.equalTo(finalAgreeCheckButton.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }

        descLabel.snp.makeConstraints { make in
            make.top.equalTo(finalAgreeView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(80)
        }
    }
}

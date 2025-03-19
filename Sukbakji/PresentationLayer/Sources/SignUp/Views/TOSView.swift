//
//  TOSView.swift
//  Sukbakji
//
//  Created by 오현민 on 2/19/25.
//

import UIKit

class TOSView: UIView {
    // MARK: - DATA
    lazy var consent = ["서비스 이용약관 동의",
                        "전자금융거래 이용약관 동의",
                        "개인정보 수집 및 이용 동의",
                        "커뮤니티 이용규칙 확인"]
    
    // MARK: - Components
    private let titleLabel = UILabel().then {
        let fullText = "석박지를 사용하기 위해서\n아래의 약관 동의가 필요해요"
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let rangeText = (fullText as NSString).range(of: "약관 동의가 필요해요")
        attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: rangeText)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        $0.attributedText = attributedString
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    
    private let subtitlelabel = UILabel().then {
        $0.text = "필수 약관을 동의해야 원활한 서비스 이용이 가능해요"
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.numberOfLines = 0
    }
    private let descLabel = UILabel().then {
        $0.text = "• 만 14세 이상만 가입 가능\n  석박지는 국내 대학생/대학원생을 위한 서비스이며, 본인인증을 통해 만14세 이상만 가입할 수 있습니다. \n\n• 본인 명의 가입 필수\n  석박지는 철저한 학교 인증과 안전한 익명 커뮤니티를 제공하기 위해 가입 시 본인인증 수단을 통해 본인 여부를 확인하고, 커뮤니티 이용 시 증명 자료 제출을 통해 재학 여부를 확인합니다. 두 정보가 일치하지 않을 경우 서비스를 이용할 수 없습니다."
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.numberOfLines = 0
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("휴대폰 인증하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray200
        $0.setTitleColor(.gray500, for: .normal)
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let containerView = UIView()
    private let contentView = UIView()
    
    lazy var AllAgreeCheckButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_check=off"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_check=on"), for: .selected)
    }
    
    // MARK: - HeaderView
    private let AllAgreeLabel = UILabel().then {
        $0.text = "약관 전체 동의"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.numberOfLines = 0
    }
    private let AllAgreeView = UIView().then {
        $0.backgroundColor = .gray50
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    
    // MARK: - FooterView
    lazy var finalAgreeCheckButton = UIButton().then {
        $0.setImage(UIImage(named: "SBJ_check=off"), for: .normal)
        $0.setImage(UIImage(named: "SBJ_check=on"), for: .selected)
        //        $0.addTarget(self, action: #selector(finalAgreeCheckButtonTapped), for: .touchUpInside)
    }
    private let finalAgreeLabel = UILabel().then {
        let fullText = "만 14세 이상이며 본인 명의로 가입을 진행하겠습니다"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let rangeText = (fullText as NSString).range(of: "만 14세 이상")
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.orange700,
                                      range: rangeText)
        
        let rangeText2 = (fullText as NSString).range(of: "본인 명의로 가입")
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.orange700,
                                      range: rangeText2)
        
        $0.attributedText = attributedString
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.numberOfLines = 0
    }
    private let finalAgreeView = UIView().then {
        $0.backgroundColor = .gray50
    }
    
    lazy var tableView = UITableView().then {
        $0.register(TOSTableViewCell.self, forCellReuseIdentifier: "TOSTableViewCell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.isScrollEnabled = false
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        scrollView.addSubviews([contentView])
        contentView.addSubviews([containerView, AllAgreeView, tableView, finalAgreeView, descLabel, nextButton])
        containerView.addSubviews([titleLabel, subtitlelabel])
        AllAgreeView.addSubviews([AllAgreeCheckButton, AllAgreeLabel])
        finalAgreeView.addSubviews([finalAgreeCheckButton, finalAgreeLabel])
    }
    
    //MARK: - 레이아웃 설정
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
               make.bottom.equalTo(nextButton.snp.bottom).offset(20)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(109)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(20)
        }
        
        subtitlelabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(AllAgreeView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(consent.count * 52)
        }
        
        AllAgreeView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        AllAgreeCheckButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        AllAgreeLabel.snp.makeConstraints { make in
            make.leading.equalTo(AllAgreeCheckButton.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
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
            make.top.equalTo(finalAgreeView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-20)
        }

    }
}

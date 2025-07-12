//
//  ReviewWritingView.swift
//  Sukbakji
//
//  Created by jaegu park on 7/11/25.
//

import UIKit
import SnapKit
import Then

class ReviewWritingView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
    var navigationbarView = NavigationBarView(title: "연구실 후기 작성")
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let titleView = UIView().then {
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then {
        $0.text = "연구실에 대한 정보를\n석박지에서 공유해 보세요"
        $0.numberOfLines = 2
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let univView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    let univImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_FavBoard")
    }
    let univLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let univLabel2 = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .orange700
    }
    let professorView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray100.cgColor
    }
    let professorImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Myinfo")
    }
    let professorLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let keywordView = UIView().then {
        $0.backgroundColor = .clear
    }
    let keywordLabel = UILabel().then {
        $0.text = "키워드 선택"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let leadershipLabel = UILabel().then {
        $0.text = "지도력은 어떤가요?"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let leadershipButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitle("좋았어요", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setBackgroundColor(.gray50, for: .normal)
    }
    let leadershipButton2 = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitle("보통이에요", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setBackgroundColor(.gray50, for: .normal)
    }
    let leadershipButton3 = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitle("아쉬워요", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setBackgroundColor(.gray50, for: .normal)
    }
    lazy var leadershipStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    let salaryLabel = UILabel().then {
        $0.text = "인건비는 어떤가요?"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let salaryButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitle("높아요", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setBackgroundColor(.gray50, for: .normal)
    }
    let salaryButton2 = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitle("보통이에요", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setBackgroundColor(.gray50, for: .normal)
    }
    let salaryButton3 = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitle("낮아요", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setBackgroundColor(.gray50, for: .normal)
    }
    lazy var salaryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    let autonomyLabel = UILabel().then {
        $0.text = "자율성은 어떤가요?"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let autonomyButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitle("높아요", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setBackgroundColor(.gray50, for: .normal)
    }
    let autonomyButton2 = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitle("보통이에요", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setBackgroundColor(.gray50, for: .normal)
    }
    let autonomyButton3 = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitle("낮아요", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setBackgroundColor(.gray50, for: .normal)
    }
    lazy var autonomyStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    let reviewView = UIView().then {
        $0.backgroundColor = .clear
    }
    let reviewLabel = UILabel().then {
        $0.text = "한줄평"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let reviewTextView = UITextView().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
        $0.configurePlaceholder("연구실 분위기, 지도자의 인품 등 후기를 알려 주세요", insets: UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16))
    }
    let cautionView = UIView().then {
        $0.backgroundColor = .clear
    }
    let cautionImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_NoResults")
    }
    let cautionLabel = UILabel().then {
        $0.text = "연구실 후기 작성시 유의사항"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let cautionLabel2 = UILabel().then {
        $0.text = "석박지는 투명하고 정확한 연구실 후기 제공을 위해 커뮤니티 이용규칙을 제정하여 운영하고 있습니다. 위반 시 게시물이 삭제되고 서비스 이용이 일정기간 제한될 수 있습니다."
        $0.numberOfLines = 3
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.textColor = .gray600
    }
    let writingButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitleColor(.gray500, for: .disabled)
        $0.setTitle("작성하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.gray200, for: .normal)
        $0.setBackgroundColor(.gray200, for: .disabled)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        leadershipStackView.addArrangedSubViews([leadershipButton, leadershipButton2, leadershipButton3])
        salaryStackView.addArrangedSubViews([salaryButton, salaryButton2, salaryButton3])
        autonomyStackView.addArrangedSubViews([autonomyButton, autonomyButton2, autonomyButton3])
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        addSubview(navigationbarView)
        addSubview(backgroundLabel)
        
        contentView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        
        contentView.addSubview(univView)
        univView.addSubview(univImageView)
        univView.addSubview(univLabel)
        univView.addSubview(univLabel2)
        
        contentView.addSubview(professorView)
        professorView.addSubview(professorImageView)
        professorView.addSubview(professorLabel)
        
        contentView.addSubview(keywordView)
        keywordView.addSubview(keywordLabel)
        keywordView.addSubview(leadershipLabel)
        keywordView.addSubview(leadershipStackView)
        keywordView.addSubview(salaryLabel)
        keywordView.addSubview(salaryStackView)
        keywordView.addSubview(autonomyLabel)
        keywordView.addSubview(autonomyStackView)
        
        contentView.addSubview(reviewView)
        reviewView.addSubview(reviewLabel)
        reviewView.addSubview(reviewTextView)
        
        contentView.addSubview(cautionView)
        cautionView.addSubview(cautionImageView)
        cautionView.addSubview(cautionLabel)
        cautionView.addSubview(cautionLabel2)
        
        contentView.addSubview(writingButton)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(writingButton.snp.bottom).offset(100)
        }
        
        navigationbarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(88)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(52)
        }
        let fullText = titleLabel.text ?? ""
        let changeText = "연구실에 대한 정보"
        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        titleLabel.attributedText = attributedString
        
        univView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(54)
        }
        
        univImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(20)
        }
        
        univLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(univImageView.snp.trailing).offset(8)
            $0.height.equalTo(19)
        }
        
        univLabel2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(univLabel.snp.trailing).offset(8)
            $0.height.equalTo(19)
        }
        
        professorView.snp.makeConstraints {
            $0.top.equalTo(univView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(54)
        }
        
        professorImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.width.equalTo(20)
        }
        
        professorLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(professorImageView.snp.trailing).offset(8)
            $0.height.equalTo(19)
        }
        
        keywordView.snp.makeConstraints {
            $0.top.equalTo(professorView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(288)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        keywordLabel.addImageAboveLabel(referenceView: professorView, spacing: 20)
        
        leadershipLabel.snp.makeConstraints {
            $0.top.equalTo(keywordLabel.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(19)
        }
        
        leadershipButton.snp.makeConstraints {
            $0.width.equalTo(57)
        }
        leadershipButton2.snp.makeConstraints {
            $0.width.equalTo(66)
        }
        leadershipButton3.snp.makeConstraints {
            $0.width.equalTo(57)
        }
        
        leadershipStackView.snp.makeConstraints {
            $0.top.equalTo(leadershipLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(20)
            $0.width.equalTo(196)
        }
        
        salaryLabel.snp.makeConstraints {
            $0.top.equalTo(leadershipStackView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(19)
        }
        
        salaryButton.snp.makeConstraints {
            $0.width.equalTo(47)
        }
        salaryButton2.snp.makeConstraints {
            $0.width.equalTo(66)
        }
        salaryButton3.snp.makeConstraints {
            $0.width.equalTo(47)
        }
        
        salaryStackView.snp.makeConstraints {
            $0.top.equalTo(salaryLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(20)
            $0.width.equalTo(176)
        }
        
        autonomyLabel.snp.makeConstraints {
            $0.top.equalTo(salaryStackView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(19)
        }
        
        autonomyButton.snp.makeConstraints {
            $0.width.equalTo(47)
        }
        autonomyButton2.snp.makeConstraints {
            $0.width.equalTo(66)
        }
        autonomyButton3.snp.makeConstraints {
            $0.width.equalTo(47)
        }
        
        autonomyStackView.snp.makeConstraints {
            $0.top.equalTo(autonomyLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(20)
            $0.width.equalTo(176)
        }
        
        reviewView.snp.makeConstraints {
            $0.top.equalTo(keywordView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(213)
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        reviewLabel.addImageAboveLabel(referenceView: keywordView, spacing: 20)
        
        reviewTextView.snp.makeConstraints {
            $0.top.equalTo(reviewLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(120)
        }
        reviewTextView.errorfix()
        reviewTextView.addTFUnderline()
        
        cautionView.snp.makeConstraints {
            $0.top.equalTo(reviewView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        cautionImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.height.width.equalTo(20)
        }
        
        cautionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(cautionImageView.snp.trailing).offset(8)
            $0.height.equalTo(19)
        }
        
        cautionLabel2.snp.makeConstraints {
            $0.top.equalTo(cautionImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(60)
        }
        
        writingButton.snp.makeConstraints {
            $0.top.equalTo(cautionView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
}

//
//  PostWritingView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/29/25.
//

import UIKit
import Then
import SnapKit

class PostWritingView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    let contentsView = UIView()
    var navigationbarView = NavigationBarView(title: "게시물 작성")
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let mainView = UIView().then {
        $0.backgroundColor = .white
    }
    let mainLabel = UILabel().then {
        $0.textColor = .gray900
        $0.numberOfLines = 2
        $0.text = "석박지에서\n이야기를 나눠 보세요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    let selectView = UIView().then {
        $0.backgroundColor = .white
    }
    let selectLabel = UILabel().then {
        $0.text = "게시판 선택"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let menuFirstButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
        $0.isEnabled = false
    }
    let selectFirstLabel = UILabel().then {
        $0.text = "박사"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let menuSecondButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
    }
    let selectSecondLabel = UILabel().then {
        $0.text = "석사"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let menuThirdButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
    }
    let selectThirdLabel = UILabel().then {
        $0.text = "입학예정"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let menuFourthButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
    }
    let selectFourthLabel = UILabel().then {
        $0.text = "자유"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let categoryView = UIView().then {
        $0.backgroundColor = .white
    }
    let categoryLabel = UILabel().then {
        $0.text = "카테고리"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let categoryTextField = UITextField().then {
        $0.backgroundColor = .gray100
        $0.placeholder = "게시판 카테고리를 선택해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let dropButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Down2"), for: .normal)
    }
    let warningCategoryImage = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningCategoryLabel = UILabel().then {
        $0.text = "카테고리는 필수 선택입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    let supportFieldView = UIView().then {
        $0.backgroundColor = .white
    }
    let supportFieldLabel = UILabel().then {
        $0.text = "지원분야"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let supportFieldTextField = UITextField().then {
        $0.backgroundColor = .gray100
        $0.placeholder = "지원분야를 선택해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let dropButton2 = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Down2"), for: .normal)
    }
    let warningSupportFieldImage = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningSupportFieldLabel = UILabel().then {
        $0.text = "지원분야는 필수 선택입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    let jobView = UIView().then {
        $0.backgroundColor = .white
    }
    let jobLabel = UILabel().then {
        $0.text = "직무"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let jobTextField = UITextField().then {
        $0.backgroundColor = .gray100
        $0.placeholder = "직무를 입력해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Delete"), for: .normal)
    }
    let warningJobImage = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningJobLabel = UILabel().then {
        $0.text = "직무는 필수 입력입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    let infoView = UIView().then {
        $0.backgroundColor = .clear
    }
    let hiringTypeLabel = UILabel().then {
        $0.text = "채용형태"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let hiringTypeFirstButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
        $0.isEnabled = false
    }
    let hiringTypeFirstLabel = UILabel().then {
        $0.text = "신입"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let hiringTypeSecondButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
    }
    let hiringTypeSecondLabel = UILabel().then {
        $0.text = "경력"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let finalEducationLabel = UILabel().then {
        $0.text = "최종학력"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let finalEducationFirstButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
        $0.isEnabled = false
    }
    let finalEducationFirstLabel = UILabel().then {
        $0.text = "박사"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let finalEducationSecondButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
        $0.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .disabled)
    }
    let finalEducationSecondLabel = UILabel().then {
        $0.text = "석사"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let titleView = UIView().then {
        $0.backgroundColor = .white
    }
    let titleLabel = UILabel().then {
        $0.text = "제목"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let titleTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "제목을 입력해 주세요"
        $0.setPlaceholderColor(.gray500)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let deleteButton2 = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Delete"), for: .normal)
    }
    let warningTitleImage = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningTitleLabel = UILabel().then {
        $0.text = "제목은 필수 입력입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    let contentLabel = UILabel().then {
        $0.text = "내용"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let contentTextView = UITextView().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
        $0.configurePlaceholder("내용을 입력해주세요", insets: UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16))
    }
    let warningContentImage = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Warning")
    }
    let warningContentLabel = UILabel().then {
        $0.text = "내용은 필수 입력입니다"
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.textColor = .warning400
    }
    let warningView = UIView().then {
        $0.backgroundColor = .white
    }
    let warningImage = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_NoResults")
    }
    let warningLabel = UILabel().then {
        $0.text = "질문 게시판 유의사항"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let warningSubLabel = UILabel().then {
        $0.text = "답변 등록시 수정 및 삭제가 불가능하니 유의해 주세요."
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray600
    }
    let buttonView = ButtonView()
    
    lazy var menuButtons: [UIButton: String] = [
        menuFirstButton: "박사",
        menuSecondButton: "석사",
        menuThirdButton: "진학예정",
        menuFourthButton: "자유"
    ]
    lazy var hiringTypeButtons: [UIButton: String] = [
        hiringTypeFirstButton: "신입",
        hiringTypeSecondButton: "경력"
    ]
    lazy var finalEduButtons: [UIButton: String] = [
        finalEducationFirstButton: "박사",
        finalEducationSecondButton: "석사"
    ]
    
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

        addSubview(scrollView)
        scrollView.addSubview(contentsView)
        
        addSubview(navigationbarView)
        addSubview(backgroundLabel)
        
        contentsView.addSubview(mainView)
        mainView.addSubview(mainLabel)
        
        contentsView.addSubview(selectView)
        selectView.addSubview(selectLabel)
        selectView.addSubview(menuFirstButton)
        selectView.addSubview(selectFirstLabel)
        selectView.addSubview(menuSecondButton)
        selectView.addSubview(selectSecondLabel)
        selectView.addSubview(menuThirdButton)
        selectView.addSubview(selectThirdLabel)
        selectView.addSubview(menuFourthButton)
        selectView.addSubview(selectFourthLabel)
        
        contentsView.addSubview(categoryView)
        categoryView.addSubview(categoryLabel)
        categoryView.addSubview(categoryTextField)
        categoryView.addSubview(dropButton)
        categoryView.addSubview(warningCategoryImage)
        categoryView.addSubview(warningCategoryLabel)
        
        contentsView.addSubview(supportFieldView)
        supportFieldView.addSubview(supportFieldLabel)
        supportFieldView.addSubview(supportFieldTextField)
        supportFieldView.addSubview(dropButton2)
        supportFieldView.addSubview(warningSupportFieldImage)
        supportFieldView.addSubview(warningSupportFieldLabel)
        
        contentsView.addSubview(jobView)
        jobView.addSubview(jobLabel)
        jobView.addSubview(jobTextField)
        jobView.addSubview(deleteButton)
        jobView.addSubview(warningJobImage)
        jobView.addSubview(warningJobLabel)
        
        contentsView.addSubview(infoView)
        infoView.addSubview(hiringTypeLabel)
        infoView.addSubview(hiringTypeFirstButton)
        infoView.addSubview(hiringTypeFirstLabel)
        infoView.addSubview(hiringTypeSecondButton)
        infoView.addSubview(hiringTypeSecondLabel)
        infoView.addSubview(finalEducationLabel)
        infoView.addSubview(finalEducationFirstButton)
        infoView.addSubview(finalEducationFirstLabel)
        infoView.addSubview(finalEducationSecondButton)
        infoView.addSubview(finalEducationSecondLabel)
        
        contentsView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(titleTextField)
        titleView.addSubview(deleteButton2)
        titleView.addSubview(warningTitleImage)
        titleView.addSubview(warningTitleLabel)
        
        contentsView.addSubview(contentView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(contentTextView)
        contentView.addSubview(warningContentImage)
        contentView.addSubview(warningContentLabel)
        
        contentsView.addSubview(warningView)
        warningView.addSubview(warningImage)
        warningView.addSubview(warningLabel)
        warningView.addSubview(warningSubLabel)
        
        addSubview(buttonView)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(warningView.snp.bottom).offset(160)
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
        
        mainView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(88)
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        let fullText = mainLabel.text ?? ""
        let changeText = "석박지"
        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        mainLabel.attributedText = attributedString
        
        selectView.snp.makeConstraints {
            $0.top.equalTo(mainView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(85)
        }
        
        selectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        selectLabel.addImageAboveLabel(referenceView: mainView, spacing: 20)
        
        menuFirstButton.snp.makeConstraints {
            $0.top.equalTo(selectLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(22)
            $0.height.width.equalTo(24)
        }
        
        selectFirstLabel.snp.makeConstraints {
            $0.centerY.equalTo(menuFirstButton)
            $0.leading.equalTo(menuFirstButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        menuSecondButton.snp.makeConstraints {
            $0.centerY.equalTo(menuFirstButton)
            $0.leading.equalTo(selectFirstLabel.snp.trailing).offset(18)
            $0.height.width.equalTo(24)
        }
        
        selectSecondLabel.snp.makeConstraints {
            $0.centerY.equalTo(menuFirstButton)
            $0.leading.equalTo(menuSecondButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        menuThirdButton.snp.makeConstraints {
            $0.centerY.equalTo(menuFirstButton)
            $0.leading.equalTo(selectSecondLabel.snp.trailing).offset(18)
            $0.height.width.equalTo(24)
        }
        
        selectThirdLabel.snp.makeConstraints {
            $0.centerY.equalTo(menuFirstButton)
            $0.leading.equalTo(menuThirdButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        menuFourthButton.snp.makeConstraints {
            $0.centerY.equalTo(menuFirstButton)
            $0.leading.equalTo(selectThirdLabel.snp.trailing).offset(18)
            $0.height.width.equalTo(24)
        }
        
        selectFourthLabel.snp.makeConstraints {
            $0.centerY.equalTo(menuFirstButton)
            $0.leading.equalTo(menuFourthButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(selectView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        categoryLabel.addImageAboveLabel(referenceView: selectView, spacing: 20)
        
        categoryTextField.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        categoryTextField.errorfix()
        categoryTextField.addTFUnderline()
        categoryTextField.setLeftPadding(16)
        categoryTextField.isEnabled = false
        
        dropButton.snp.makeConstraints {
            $0.centerY.equalTo(categoryTextField)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(36)
        }
        
        warningCategoryImage.snp.makeConstraints {
            $0.top.equalTo(categoryTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(28)
            $0.height.width.equalTo(12)
        }
        warningCategoryImage.isHidden = true
        
        warningCategoryLabel.snp.makeConstraints {
            $0.centerY.equalTo(warningCategoryImage)
            $0.leading.equalTo(warningCategoryImage.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningCategoryLabel.isHidden = true
        
        supportFieldView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        supportFieldLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        supportFieldLabel.addImageAboveLabel(referenceView: categoryView, spacing: 20)
        
        supportFieldTextField.snp.makeConstraints {
            $0.top.equalTo(supportFieldLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        supportFieldTextField.errorfix()
        supportFieldTextField.addTFUnderline()
        supportFieldTextField.setLeftPadding(16)
        supportFieldTextField.isEnabled = false
        
        dropButton2.snp.makeConstraints {
            $0.centerY.equalTo(supportFieldTextField)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(36)
        }
        
        warningSupportFieldImage.snp.makeConstraints {
            $0.top.equalTo(supportFieldTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(28)
            $0.height.width.equalTo(12)
        }
        warningSupportFieldImage.isHidden = true
        
        warningSupportFieldLabel.snp.makeConstraints {
            $0.centerY.equalTo(warningSupportFieldImage)
            $0.leading.equalTo(warningSupportFieldImage.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningSupportFieldLabel.isHidden = true
        
        jobView.snp.makeConstraints {
            $0.top.equalTo(supportFieldView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        jobLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        jobLabel.addImageAboveLabel(referenceView: supportFieldView, spacing: 20)
        
        jobTextField.snp.makeConstraints {
            $0.top.equalTo(jobLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        jobTextField.errorfix()
        jobTextField.addTFUnderline()
        jobTextField.setLeftPadding(16)
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(jobTextField)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(36)
        }
        
        warningJobImage.snp.makeConstraints {
            $0.top.equalTo(jobTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(28)
            $0.height.width.equalTo(12)
        }
        warningJobImage.isHidden = true
        
        warningJobLabel.snp.makeConstraints {
            $0.centerY.equalTo(warningJobImage)
            $0.leading.equalTo(warningJobImage.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningJobLabel.isHidden = true
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(jobView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        hiringTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        hiringTypeLabel.addImageAboveLabel(referenceView: jobView, spacing: 20)
        
        hiringTypeFirstButton.snp.makeConstraints {
            $0.top.equalTo(hiringTypeLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(22)
            $0.height.width.equalTo(24)
        }
        
        hiringTypeFirstLabel.snp.makeConstraints {
            $0.centerY.equalTo(hiringTypeFirstButton)
            $0.leading.equalTo(hiringTypeFirstButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        hiringTypeSecondButton.snp.makeConstraints {
            $0.centerY.equalTo(hiringTypeFirstButton)
            $0.leading.equalTo(hiringTypeFirstLabel.snp.trailing).offset(18)
            $0.height.width.equalTo(24)
        }
        
        hiringTypeSecondLabel.snp.makeConstraints {
            $0.centerY.equalTo(hiringTypeFirstButton)
            $0.leading.equalTo(hiringTypeSecondButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        finalEducationLabel.snp.makeConstraints {
            $0.top.equalTo(hiringTypeFirstButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        finalEducationLabel.addImageAboveLabel(referenceView: hiringTypeFirstButton, spacing: 30)
        
        finalEducationFirstButton.snp.makeConstraints {
            $0.top.equalTo(finalEducationLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(22)
            $0.height.width.equalTo(24)
        }
        
        finalEducationFirstLabel.snp.makeConstraints {
            $0.centerY.equalTo(finalEducationFirstButton)
            $0.leading.equalTo(finalEducationFirstButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        finalEducationSecondButton.snp.makeConstraints {
            $0.centerY.equalTo(finalEducationFirstButton)
            $0.leading.equalTo(finalEducationFirstLabel.snp.trailing).offset(18)
            $0.height.width.equalTo(24)
        }
        
        finalEducationSecondLabel.snp.makeConstraints {
            $0.centerY.equalTo(finalEducationFirstButton)
            $0.leading.equalTo(finalEducationSecondButton.snp.trailing).offset(6)
            $0.height.equalTo(19)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        titleLabel.addImageAboveLabel(referenceView: infoView, spacing: 20)
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        titleTextField.errorfix()
        titleTextField.addTFUnderline()
        titleTextField.setLeftPadding(16)
        
        deleteButton2.snp.makeConstraints {
            $0.centerY.equalTo(titleTextField)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(36)
        }
        
        warningTitleImage.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(28)
            $0.height.width.equalTo(12)
        }
        warningTitleImage.isHidden = true
        
        warningTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(warningTitleImage)
            $0.leading.equalTo(warningTitleImage.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningTitleLabel.isHidden = true
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        contentLabel.addImageAboveLabel(referenceView: titleView, spacing: 20)
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(120)
        }
        contentTextView.errorfix()
        contentTextView.addTFUnderline()
        
        warningContentImage.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(28)
            $0.height.width.equalTo(12)
        }
        warningContentImage.isHidden = true
        
        warningContentLabel.snp.makeConstraints {
            $0.centerY.equalTo(warningContentImage)
            $0.leading.equalTo(warningContentImage.snp.trailing).offset(4)
            $0.height.equalTo(12)
        }
        warningContentLabel.isHidden = true
        
        warningView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        warningImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.height.width.equalTo(20)
        }
        
        warningLabel.snp.makeConstraints {
            $0.centerY.equalTo(warningImage)
            $0.leading.equalTo(warningImage.snp.trailing).offset(8)
            $0.height.equalTo(19)
        }
        
        warningSubLabel.snp.makeConstraints {
            $0.top.equalTo(warningLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(17)
        }
        
        buttonView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
}

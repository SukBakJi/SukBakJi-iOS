//
//  LabSearchView.swift
//  Sukbakji
//
//  Created by jaegu park on 6/18/25.
//

import UIKit
import SnapKit
import Then

class LabSearchView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
    let searchView = UIView().then {
        $0.backgroundColor = .white
    }
    let labSearchTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "지도교수명을 입력해 주세요"
        $0.setPlaceholderColor(.gray300)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
        $0.layer.cornerRadius = 12
    }
    let searchImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_SearchImage")
    }
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Delete"), for: .normal)
    }
    let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.gray900, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
    }
    
    let recentView = UIView().then {
        $0.backgroundColor = .white
    }
    let noResultLabel = UILabel().then {
        $0.text = "최근에 검색한 결과가 없어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .gray500
    }
    let recentLabel = UILabel().then {
        $0.text = "최근 검색어"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let labRecentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(LabRecentCollectionViewCell.self, forCellWithReuseIdentifier: LabRecentCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        cv.allowsSelection = false
        
        return cv
    }()
    
    let resultView = UIView().then {
        $0.backgroundColor = .white
    }
    let countLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    let resultLabel = UILabel().then {
        $0.text = "검색 결과"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .gray900
    }
    let labSearchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(LabSearchCollectionViewCell.self, forCellWithReuseIdentifier: LabSearchCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        
        return cv
    }()
    let moreButton = UIButton().then {
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.setImage(UIImage(named: "Sukbakji_Down2"), for: .normal)
        $0.setTitle("연구실 정보 더보기 ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 11)
        $0.setTitleColor(.gray900, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    
    let noResultView = UIView().then {
        $0.backgroundColor = .white
    }
    let searchWarningImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_NoResults")
    }
    let searchWarningLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let searchLabel = UILabel().then {
        $0.text = "이렇게 검색해 보는 건 어때요?"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray500
    }
    let items: [(icon: String, title: String, subtitle: String)] = [
        ("Sukbakji_LabSearch", "정확한 대학교명", "석박지대학교"),
        ("Sukbakji_LabSearch2", "다시 확인해 보는 교수명", "석박지 교수"),
        ("Sukbakji_LabSearch3", "철자가 맞는 연구실 이름", "석박지 연구실"),
        ("Sukbakji_LabSearch4", "알맞은 연구 주제명", "석박지는 어떻게 담겨야 할까?")
    ]
    lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .leading
        $0.distribution = .equalSpacing
    }
    
    let adView = UIView().then {
        $0.backgroundColor = .clear
    }
    let adImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Background")
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
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        addSubview(searchView)
        searchView.addSubview(labSearchTextField)
        searchView.addSubview(searchImageView)
        searchView.addSubview(deleteButton)
        searchView.addSubview(cancelButton)
        
        contentView.addSubview(recentView)
        recentView.addSubview(noResultLabel)
        recentView.addSubview(recentLabel)
        recentView.addSubview(labRecentCollectionView)
        
        contentView.addSubview(resultView)
        resultView.addSubview(countLabel)
        resultView.addSubview(backgroundLabel)
        resultView.addSubview(resultLabel)
        resultView.addSubview(labSearchCollectionView)
        contentView.addSubview(moreButton)
        
        items.forEach { item in
            let itemView = createItemView(icon: item.icon, title: item.title, subtitle: item.subtitle)
            stackView.addArrangedSubview(itemView)
        }
        
        contentView.addSubview(noResultView)
        noResultView.addSubview(searchWarningImageView)
        noResultView.addSubview(searchWarningLabel)
        noResultView.addSubview(searchLabel)
        noResultView.addSubview(stackView)
        
        addSubview(adView)
        adView.addSubview(adImageView)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(moreButton.snp.bottom).offset(120)
        }
        
        searchView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(115)
        }
        
        cancelButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(48)
            $0.width.equalTo(48)
        }
        
        labSearchTextField.snp.makeConstraints {
            $0.centerY.equalTo(cancelButton)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(cancelButton.snp.leading)
            $0.height.equalTo(48)
        }
        labSearchTextField.setLeftPadding(52)
        labSearchTextField.errorfix()
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(cancelButton)
            $0.leading.equalToSuperview().offset(40)
            $0.height.width.equalTo(24)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(cancelButton)
            $0.trailing.equalTo(cancelButton.snp.leading).inset(-10)
            $0.height.width.equalTo(24)
        }
        
        recentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(115)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(103)
        }
        
        recentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(19)
        }
        
        labRecentCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        noResultLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(17)
        }
        
        adView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(124)
        }
        
        adImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(100)
        }
        adImageView.isHidden = true
        
        resultView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(115)
            $0.leading.trailing.equalToSuperview()
        }
        resultView.isHidden = true
        
        countLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(17)
        }
        
        backgroundLabel.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(backgroundLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(19)
        }
        
        labSearchCollectionView.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalTo(resultView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(33)
            $0.width.equalTo(136)
        }
        moreButton.isHidden = true
    }
    
    private func createItemView(icon: String, title: String, subtitle: String) -> UIView {
        let container = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 16
            $0.alignment = .center
        }
        
        let iconView = UIImageView().then {
            $0.image = UIImage(named: icon)
            $0.contentMode = .scaleAspectFit
        }
        iconView.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        
        let textStack = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 6
        }
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = UIFont(name: "Pretendard-Medium", size: 12)
            $0.textColor = .gray900
        }
        
        let subtitleLabel = UILabel().then {
            $0.text = subtitle
            $0.font = UIFont(name: "Pretendard-Regular", size: 11)
            $0.textColor = .gray600
        }
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)
        
        container.addArrangedSubview(iconView)
        container.addArrangedSubview(textStack)
        
        return container
    }
    
    func changeColor(_ keyword: String) {
        searchWarningLabel.text = "\(keyword)에 대한 검색 결과 없어요"
        let fullText = searchWarningLabel.text ?? ""
        let changeText = keyword
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        searchWarningLabel.attributedText = attributedString
    }
}

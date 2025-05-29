//
//  BoardMasterView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class BoardMasterView: UIView {
    
    let boardSearchTextField = UITextField().then {
        $0.backgroundColor = .gray50
        $0.placeholder = "게시판에서 궁금한 내용을 검색해 보세요!"
        $0.setPlaceholderColor(.gray300)
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
        $0.layer.cornerRadius = 12
    }
    let searchImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_SearchImage")
    }
    let masterMenuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MasterMenuCollectionViewCell.self, forCellWithReuseIdentifier: MasterMenuCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        cv.allowsSelection = false
        
        return cv
    }()
    let titleLabel = UILabel().then {
        $0.textColor = .gray900
        $0.numberOfLines = 2
        $0.text = "질문 게시판에서\n이야기를 나눠 보세요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    let masterPostTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(MasterPostTableViewCell.self, forCellReuseIdentifier: MasterPostTableViewCell.identifier)
        $0.allowsSelection = false
    }
    let writingButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Write"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
        changeColor("질문 게시판")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        addSubview(boardSearchTextField)
        addSubview(searchImageView)
        addSubview(masterMenuCollectionView)
        addSubview(titleLabel)
        addSubview(masterPostTableView)
        addSubview(writingButton)
    }
    
    private func setConstraints() {
        boardSearchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(55)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        boardSearchTextField.setLeftPadding(52)
        boardSearchTextField.errorfix()
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(boardSearchTextField)
            $0.leading.equalToSuperview().offset(40)
            $0.height.width.equalTo(24)
        }
        
        masterMenuCollectionView.snp.makeConstraints {
            $0.top.equalTo(boardSearchTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        masterMenuCollectionView.showsHorizontalScrollIndicator = false
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(masterMenuCollectionView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        
        masterPostTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.bottom.equalToSuperview().offset(92)
        }
        
        writingButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(120)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(60)
        }
    }
    
    func changeColor(_ boardName: String) {
        titleLabel.text = "\(boardName)에서\n이야기를 나눠 보세요"
        let fullText = titleLabel.text ?? ""
        let changeText = boardName
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: nsRange)
        }
        titleLabel.attributedText = attributedString
    }
}

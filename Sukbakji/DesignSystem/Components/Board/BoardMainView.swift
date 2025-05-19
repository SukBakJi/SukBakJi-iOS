//
//  BoardMainView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/16/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class BoardMainView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
    let titleView = UIView().then {
        $0.backgroundColor = .orange400
    }
    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.text = "석박지에서\n함께 소통해 보세요!📢"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
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
    let hotBoardButton = BoardMainButton(title: "HOT 게시판", icon: UIImage(named: "Sukbakji_BoardMain1"))
    let myPostButton = BoardMainButton(title: "내가 쓴 글", icon: UIImage(named: "Sukbakji_BoardMain2"))
    let scrapButton = BoardMainButton(title: "스크랩", icon: UIImage(named: "Sukbakji_BoardMain3"))
    let myCommentButton = BoardMainButton(title: "댓글 단 글", icon: UIImage(named: "Sukbakji_BoardMain4"))
    lazy var firstRow = UIStackView().then {
        $0.addArrangedSubview(hotBoardButton)
        $0.addArrangedSubview(myPostButton)
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    lazy var secondRow = UIStackView().then {
        $0.addArrangedSubview(scrapButton)
        $0.addArrangedSubview(myCommentButton)
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    lazy var mainStackView = UIStackView().then {
        $0.addArrangedSubview(firstRow)
        $0.addArrangedSubview(secondRow)
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    let qnaView = UIView().then {
        $0.backgroundColor = .gray50
    }
    let qnaLabel = UILabel().then {
        $0.text = "최신 질문글"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let qnaImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_MentorProgress")
    }
    let qnaButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_More"), for: .normal)
        $0.setTitle("더보기 ", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.setTitleColor(.gray500, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    let noQnA = UILabel().then {
        $0.text = "아직 최신 질문글이 없어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .gray500
    }
    let noQnALabel = UILabel().then {
        $0.text = "게시판을 탐색하고 질문글을 등록해 보세요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 11)
        $0.textColor = .gray500
    }
    let qnaContainerView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1.2
        $0.layer.borderColor = UIColor.gray100.cgColor
        $0.layer.masksToBounds = true
    }
    let qnaTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(BoardQnATableViewCell.self, forCellReuseIdentifier: BoardQnATableViewCell.identifier)
        $0.allowsSelection = false
    }
    let favBoardView = UIView().then {
        $0.backgroundColor = .clear
    }
    let favBoardLabel = UILabel().then {
        $0.text = "즐겨찾는 게시판"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let favBoardImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Favorite")
    }
    let noFavBoard = UILabel().then {
        $0.text = "아직 즐겨찾는 게시판이 없어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.textColor = .gray500
    }
    let noFavBoardLabel = UILabel().then {
        $0.text = "게시판을 탐색하고 즐겨찾기를 등록해 보세요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 11)
        $0.textColor = .gray500
    }
    let favBoardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FavoriteBoardCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteBoardCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        cv.allowsSelection = false
        
        return cv
    }()
    let favBoardProgressView = UIProgressView().then {
        $0.progressTintColor = UIColor.orange400
        $0.trackTintColor = .gray100
        $0.progress = 0.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        
        contentView.addSubview(boardSearchTextField)
        contentView.addSubview(searchImageView)
        contentView.addSubview(mainStackView)
        
        contentView.addSubview(qnaView)
        qnaView.addSubview(qnaLabel)
        qnaView.addSubview(qnaImageView)
        qnaView.addSubview(qnaButton)
        qnaView.addSubview(noQnA)
        qnaView.addSubview(noQnALabel)
        qnaView.addSubview(qnaContainerView)
        qnaContainerView.addSubview(qnaTableView)
        
        contentView.addSubview(favBoardView)
        favBoardView.addSubview(favBoardLabel)
        favBoardView.addSubview(favBoardImageView)
        favBoardView.addSubview(noFavBoard)
        favBoardView.addSubview(noFavBoardLabel)
        favBoardView.addSubview(favBoardCollectionView)
        favBoardView.addSubview(favBoardProgressView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(favBoardView.snp.bottom).offset(130)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(41)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(116)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(52)
        }
        
        boardSearchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(133)
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
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(boardSearchTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(168)
        }
        
        qnaView.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(245)
        }
        
        qnaLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        qnaImageView.snp.makeConstraints {
            $0.centerY.equalTo(qnaLabel)
            $0.leading.equalTo(qnaLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(21)
        }
        
        qnaButton.snp.makeConstraints {
            $0.centerY.equalTo(qnaLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(26)
            $0.width.equalTo(64)
        }
        
        noQnA.snp.makeConstraints {
            $0.top.equalTo(qnaLabel.snp.bottom).offset(52)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(17)
        }
        
        noQnALabel.snp.makeConstraints {
            $0.top.equalTo(noQnA.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(13)
        }
        
        qnaContainerView.snp.makeConstraints {
            $0.top.equalTo(qnaLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        qnaTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        qnaTableView.isScrollEnabled = false
        
        favBoardView.snp.makeConstraints {
            $0.top.equalTo(qnaView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(226)
        }
        
        favBoardLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        favBoardImageView.snp.makeConstraints {
            $0.centerY.equalTo(favBoardLabel)
            $0.leading.equalTo(favBoardLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(21)
        }
        
        noFavBoard.snp.makeConstraints {
            $0.top.equalTo(favBoardLabel.snp.bottom).offset(52)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(17)
        }
        
        noFavBoardLabel.snp.makeConstraints {
            $0.top.equalTo(noFavBoard.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(13)
        }
        
        favBoardCollectionView.snp.makeConstraints {
            $0.top.equalTo(favBoardLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(196)
        }
        
        favBoardProgressView.snp.makeConstraints {
            $0.top.equalTo(favBoardCollectionView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.height.equalTo(2)
        }
    }
}

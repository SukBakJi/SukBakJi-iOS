//
//  BoardFreeView.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class BoardFreeView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
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
    let favBoardView = UIView().then {
        $0.backgroundColor = .clear
    }
    let favBoardLabel = UILabel().then {
        $0.text = "즐겨찾는 게시판"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let favBoardImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_FavBoard")
    }
    let freeFavoriteBoardTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(FreeFavBoardTableViewCell.self, forCellReuseIdentifier: FreeFavBoardTableViewCell.identifier)
        $0.allowsSelection = false
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
    let layerView = UIView().then {
        $0.backgroundColor = .gray100
    }
    let makeBoardView = UIView().then {
        $0.backgroundColor = .clear
    }
    let makeBoard = UILabel().then {
        $0.text = "마음에 드는 게시판이 없다면?"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .gray900
    }
    let makeBoardLabel = UILabel().then {
        $0.text = "직접 게시판을 만들고 관심사를 공유해 보세요!"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .gray800
    }
    let makeBoardImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_MakeBoard")
    }
    let makeBoardButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("게시판 만들러 가기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.orange600, for: .normal)
    }
    let writingButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Write"), for: .normal)
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
        
        contentView.addSubview(boardSearchTextField)
        contentView.addSubview(searchImageView)
        
        contentView.addSubview(favBoardView)
        favBoardView.addSubview(favBoardLabel)
        favBoardView.addSubview(favBoardImageView)
        favBoardView.addSubview(freeFavoriteBoardTableView)
        favBoardView.addSubview(noFavBoard)
        favBoardView.addSubview(noFavBoardLabel)
        
        contentView.addSubview(layerView)
        
        contentView.addSubview(makeBoardView)
        makeBoardView.addSubview(makeBoard)
        makeBoardView.addSubview(makeBoardLabel)
        makeBoardView.addSubview(makeBoardImageView)
        makeBoardView.addSubview(makeBoardButton)
        
        addSubview(writingButton)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(makeBoardView.snp.bottom).offset(140)
        }
        
        boardSearchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(55)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        boardSearchTextField.setLeftPadding(52)
        boardSearchTextField.errorfix()
        boardSearchTextField.isUserInteractionEnabled = false
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(boardSearchTextField)
            $0.leading.equalToSuperview().offset(40)
            $0.height.width.equalTo(24)
        }
        
        favBoardView.snp.makeConstraints {
            $0.top.equalTo(boardSearchTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        favBoardLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        favBoardImageView.snp.makeConstraints {
            $0.centerY.equalTo(favBoardLabel)
            $0.leading.equalTo(favBoardLabel.snp.trailing).offset(4)
            $0.height.width.equalTo(20)
        }
        
        freeFavoriteBoardTableView.snp.makeConstraints {
            $0.top.equalTo(boardSearchTextField.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        noFavBoard.snp.makeConstraints {
            $0.top.equalToSuperview().offset(48)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(17)
        }
        
        noFavBoardLabel.snp.makeConstraints {
            $0.top.equalTo(noFavBoard.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(13)
        }
        
        layerView.snp.makeConstraints {
            $0.top.equalTo(favBoardView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        makeBoardView.snp.makeConstraints {
            $0.top.equalTo(layerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(332)
        }
        
        makeBoard.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(21)
        }
        
        makeBoardLabel.snp.makeConstraints {
            $0.top.equalTo(makeBoard.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(17)
        }
        
        makeBoardImageView.snp.makeConstraints {
            $0.top.equalTo(makeBoardLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(180)
        }
        
        makeBoardButton.snp.makeConstraints {
            $0.top.equalTo(makeBoardImageView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        
        writingButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(120)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(60)
        }
    }
}

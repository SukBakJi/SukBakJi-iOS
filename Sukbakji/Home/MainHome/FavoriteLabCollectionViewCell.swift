//
//  FavoriteLabCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 7/16/24.
//

import UIKit

class FavoriteLabCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var firstMajorView: UIView!
    @IBOutlet weak var secondMajorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 15
        layer.masksToBounds = false
        
        firstMajorView.layer.cornerRadius = 5
        secondMajorView.layer.cornerRadius = 5
    }
}

extension FavoriteLabViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = FavoriteLabCV.indexPathsForVisibleItems
        guard !visibleCells.isEmpty else { return }
        
        // 현재 보이는 셀의 중앙 인덱스를 구함
        let firstVisibleIndex = visibleCells.min()?.row ?? 0
        let lastVisibleIndex = visibleCells.max()?.row ?? 0
        let currentIndex = (firstVisibleIndex + lastVisibleIndex) / 2
        
        // ProgressView 업데이트
        let progress = Float(currentIndex) / Float(5 - 1)
        FavoriteLabPV.setProgress(progress, animated: true)
        
        // 컬렉션 뷰 끝에 도달했는지 확인
        let contentOffsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let scrollViewWidth = scrollView.frame.size.width
        
        if contentOffsetX + scrollViewWidth >= contentWidth {
            FavoriteLabPV.setProgress(1.0, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 172)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoriteLabCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteLab_CollectionViewCell", for: indexPath) as! FavoriteLabCollectionViewCell
        
        return cell
    }
}

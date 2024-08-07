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
            let contentOffsetX = scrollView.contentOffset.x
            let contentWidth = scrollView.contentSize.width
            let scrollViewWidth = scrollView.frame.size.width
            
            // 현재 스크롤 위치에 따라 진행도 계산
            let progress = Float(contentOffsetX / (contentWidth - scrollViewWidth))
            
            // ProgressView 업데이트
            FavoriteLabPV.setProgress(progress, animated: true)
            
            // 컬렉션 뷰 끝에 도달했는지 확인
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

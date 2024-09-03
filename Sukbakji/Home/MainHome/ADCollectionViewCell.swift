//
//  ADCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 8/5/24.
//

import UIKit

class ADCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setADView()
    }
    
    func setADView() {
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 15
        layer.masksToBounds = false
    }
}

extension ADViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 26
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 342, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ADCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AD_CollectionViewCell", for: indexPath) as! ADCollectionViewCell
        
        return cell
    }
}

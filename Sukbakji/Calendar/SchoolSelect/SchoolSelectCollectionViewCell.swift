//
//  SchoolSelectCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 8/1/24.
//

import UIKit

class SchoolSelectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var schoolView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        schoolView.layer.cornerRadius = 15
    }
}

extension SchoolSelectViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 136, height: 29)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SchoolSelectCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchoolSelect_CollectionViewCell", for: indexPath) as! SchoolSelectCollectionViewCell
        
        return cell
    }
}

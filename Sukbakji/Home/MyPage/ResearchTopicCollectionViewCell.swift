//
//  ResearchTopicCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 8/5/24.
//

import UIKit

class ResearchTopicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topicView: UIView!
    @IBOutlet weak var topicLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topicView.layer.cornerRadius = 15
    }
}

extension EditInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userData?.researchTopics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let str = userData?.researchTopics?[indexPath.item].count ?? 0
        return CGSize(width: 40 + str * 12, height: 29)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ResearchTopicCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResearchTopic_CollectionViewCell", for: indexPath) as! ResearchTopicCollectionViewCell
        
        let topicData = userData?.researchTopics?[indexPath.item]
        
        cell.topicLabel.text = "#\(topicData ?? "")"
        
        return cell
    }
}

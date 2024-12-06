//
//  ResearchTopicCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 8/5/24.
//

import UIKit

class ResearchTopicCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ResearchTopicCollectionViewCell.self)
    
    @IBOutlet weak var topicView: UIView!
    @IBOutlet weak var topicLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topicView.layer.cornerRadius = 15
    }
    
    func prepare(topics: String) {
        
    }
}

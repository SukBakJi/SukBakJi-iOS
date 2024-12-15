//
//  DateCollectionViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 7/18/24.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var ddayLabel: UILabel!
    @IBOutlet weak var univLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionView()
    }
    
    func setCollectionView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 8
        layer.masksToBounds = false
    }
}

extension DateViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SchoolCalendarVC") as? SchoolCalendarViewController else {
            return
        }
        self.present(nextVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if allDetailDatas.count == 0 {
            return 1
        } else {
            return allDetailDatas.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 108)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DateCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Date_CollectionViewCell", for: indexPath) as! DateCollectionViewCell
        
        if allDetailDatas.count == 0 {
            cell.noResultLabel.isHidden = false
        } else {
            let detailData = allDetailDatas[indexPath.item]
            cell.noResultLabel.isHidden = true
            cell.ddayLabel.isHidden = false
            cell.univLabel.isHidden = false
            cell.contentLabel.isHidden = false
            cell.ddayLabel.text = "D-\(detailData.dday)"
            if detailData.univId == 1 {
                cell.univLabel.text = "서울대학교"
            } else if detailData.univId == 1 {
                cell.univLabel.text = "연세대학교"
            } else if detailData.univId == 1 {
                cell.univLabel.text = "고려대학교"
            } else {
                cell.univLabel.text = "카이스트"
            }
            cell.contentLabel.text = "\(detailData.content)"
        }
        
        return cell
    }
}

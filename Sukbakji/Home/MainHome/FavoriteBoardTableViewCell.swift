//
//  FavoriteBoardTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 7/16/24.
//

import UIKit

class FavoriteBoardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelView: UIView!

    @IBOutlet weak var labelLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

extension FavoriteBoardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoriteBoardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteBoard_TableViewCell", for: indexPath) as! FavoriteBoardTableViewCell
        
        let detailData = allDatas[indexPath.row]
        
        if allDatas.count == 0 {
            FavoriteBoardTV.isHidden = true
            noFavLabel.isHidden = false
            letsFavLabel.isHidden = false
        } else {
            noFavLabel.isHidden = true
            letsFavLabel.isHidden = true
            cell.labelLabel.text = detailData.boardName
            cell.contentLabel.text = detailData.title
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

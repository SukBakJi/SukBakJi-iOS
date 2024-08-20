//
//  HotFeedTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 7/16/24.
//

import UIKit

class HotFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelHotView: UIView!
    @IBOutlet weak var labelTypeView: UIView!
    
    @IBOutlet weak var boardName: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelHotView.layer.cornerRadius = 5
        labelTypeView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension HotFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HotFeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HotFeed_TableViewCell", for: indexPath) as! HotFeedTableViewCell
        
        let detailData = allDatas[indexPath.section]
        
        cell.boardName.text = "\(detailData.boardName)"
        cell.titleLabel.text = "\(detailData.title)"
        cell.contentLabel.text = "\(detailData.content)"
        cell.commentCount.text = "\(detailData.commentCount)"
        cell.viewCount.text = "\(detailData.views)"
        
        cell.selectionStyle = .none
        
        return cell
    }
}

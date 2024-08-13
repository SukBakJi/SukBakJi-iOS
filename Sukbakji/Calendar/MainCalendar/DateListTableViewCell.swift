//
//  DateListTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 8/4/24.
//

import UIKit

class DateListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var univLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allDateDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DateListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DateList_TableViewCell", for: indexPath) as! DateListTableViewCell
        
        let detailDatas = allDateDatas[indexPath.section]
        
        cell.contentLabel.text = detailDatas.content
        if detailDatas.univId == 1 {
            cell.univLabel.text = "서울대학교"
        } else if detailDatas.univId == 2 {
            cell.univLabel.text = "연세대학교"
        } else if detailDatas.univId == 3 {
            cell.univLabel.text = "고려대학교"
        } else if detailDatas.univId == 4 {
            cell.univLabel.text = "카이스트"
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

//
//  MentoringRoomTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 9/9/24.
//

import UIKit

class MentoringRoomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var univLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var profLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

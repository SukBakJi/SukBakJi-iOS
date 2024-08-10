//
//  SchoolSelectTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 8/1/24.
//

import UIKit

class SchoolSelectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func select_Tapped(_ sender: Any) {
        selectButton.isSelected.toggle()
        let selectImage = selectButton.isSelected ? "Sukbakji_Check2" : "Sukbakji_Check"
        selectButton.setImage(UIImage(named: selectImage), for: .normal)
        selectButton.tintColor = .clear
    }
}

extension SchoolSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SchoolSelectTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SchoolSelect_TableViewCell", for: indexPath) as! SchoolSelectTableViewCell
        
        cell.selectionStyle = .none
        
        return cell
    }
}

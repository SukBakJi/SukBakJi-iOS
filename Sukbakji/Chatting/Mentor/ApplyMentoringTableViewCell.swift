//
//  ApplyMentoringTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 8/12/24.
//

import UIKit

class ApplyMentoringTableViewCell: UITableViewCell {
    
    @IBOutlet weak var univName: UILabel!
    @IBOutlet weak var deptName: UILabel!
    @IBOutlet weak var profName: UILabel!
    @IBOutlet weak var firstTopic: UILabel!
    @IBOutlet weak var secondTopic: UILabel!
    @IBOutlet weak var mentoringButton: UIButton!
    
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ApplyMentoringViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allDetailDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ApplyMentoringTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ApplyMentoring_TableViewCell", for: indexPath) as! ApplyMentoringTableViewCell
        
        cell.mentoringButton.tag = indexPath.section
        cell.mentoringButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        let detailData = allDetailDatas[indexPath.section]
        
        cell.univName.text = detailData.univName
        cell.deptName.text = "\(detailData.deptName)부"
        cell.profName.text = "\(detailData.profName) 교수님"
        cell.firstTopic.text = "#\(detailData.researchTopic[0])"
        cell.secondTopic.text = "#\(detailData.researchTopic[1])"
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let detailData = allDetailDatas[sender.tag]
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MentoringPostVC") as? MentoringPostViewController else { return }
        nextVC.mentorId = detailData.mentorId
        self.present(nextVC, animated: true)
    }
}

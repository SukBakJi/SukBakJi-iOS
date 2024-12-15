//
//  SchoolCalendarTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 8/5/24.
//

import UIKit

class SchoolCalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var univName: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var buttonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        deleteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func buttonTapped() {
        buttonAction?()
    }
}

extension SchoolCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allDetailDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SchoolCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SchoolCalendar_TableViewCell", for: indexPath) as! SchoolCalendarTableViewCell
        
        cell.buttonAction = { [weak self] in
            self?.handleButtonTap(for: indexPath)
        }
        
        let detailData = allDetailDatas[indexPath.section]
        
//        if detailData.univId == 1{
//            cell.univName.text = "서울대학교"
//        } else if detailData.univId == 2{
//            cell.univName.text = "연세대학교"
//        } else if detailData.univId == 3{
//            cell.univName.text = "고려대학교"
//        } else {
//            cell.univName.text = "카이스트"
//        }
//        cell.seasonLabel.text = detailData.season
//        cell.methodLabel.text = detailData.method
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func handleButtonTap(for indexPath: IndexPath) {
        // API 호출을 위한 파라미터 생성
        let detailData = allDetailDatas[indexPath.section]
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SchoolDeleteAlertVC") as? SchoolDeleteAlertViewController else { return }
        nextVC.modalPresentationStyle = .overCurrentContext
        
        nextVC.memberId = allDatas?.memberId
//        nextVC.method = detailData.method
//        nextVC.season = detailData.season
//        nextVC.univId = detailData.univId
        
        DispatchQueue.main.async {
            self.present(nextVC, animated: false, completion: nil)
        }
    }
}

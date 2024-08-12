//
//  SchoolSelectTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 8/1/24.
//

import UIKit

class SchoolSelectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var uniLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension SchoolSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SchoolSelectTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SchoolSelect_TableViewCell", for: indexPath) as! SchoolSelectTableViewCell
        
        cell.selectButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        if indexPath == selectedIndex {
            cell.selectButton.isSelected = true
            cell.selectButton.setImage(UIImage(named: "Sukbakji_Check2"), for: .normal)
            cell.selectButton.tintColor = .clear
        } else {
            cell.selectButton.isSelected = false
            cell.selectButton.setImage(UIImage(named: "Sukbakji_Check"), for: .normal)
            cell.selectButton.tintColor = .clear
        }
        
//        let detailData = allUniDatas[indexPath.row]
        
//        cell.uniLabel.text = detailData.name
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? SchoolSelectTableViewCell,
           let indexPath = SchoolTV.indexPath(for: cell) {
            // 이미 선택된 버튼을 다시 클릭했는지 확인
            if selectedIndex == indexPath {
                selectedIndex = nil // 버튼을 다시 클릭하면 선택을 해제
                setButton.isEnabled = false
                setButton.backgroundColor = UIColor(hexCode: "EFEFEF")
                setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
                setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .selected)
            } else {
                selectedIndex = indexPath // 선택된 버튼 인덱스 업데이트
                setButton.isEnabled = true
                setButton.backgroundColor = UIColor(named: "Coquelicot")
                setButton.setTitleColor(.white, for: .normal)
                setButton.setTitleColor(.white, for: .selected)
            }
            UIView.animate(withDuration: 0.1) { // 효과 주기
                self.view.layoutIfNeeded()
            }
            SchoolTV.reloadData() // 테이블뷰 갱신하여 버튼 상태 반영
        }
    }
}

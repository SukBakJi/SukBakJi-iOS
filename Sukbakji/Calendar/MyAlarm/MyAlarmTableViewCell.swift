//
//  MyAlarmTableViewCell.swift
//  Sukbakji
//
//  Created by jaegu park on 8/5/24.
//

import UIKit

class MyAlarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var univView: UIView!
    @IBOutlet weak var univName: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var onoffSwitch: UISwitch!
    
    var buttonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        univView.layer.cornerRadius = 5
        
        onoffSwitch.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func buttonTapped() {
        buttonAction?()
    }
}

extension MyAlarmViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allDetailDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyAlarmTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyAlarm_TableViewCell", for: indexPath) as! MyAlarmTableViewCell
        
        cell.buttonAction = { [weak self] in
            self?.handleButtonTap(for: indexPath)
        }
        
        let detailData = allDetailDatas[indexPath.section]
        
        cell.univName.text = detailData.alarmUnivName
        cell.contentLabel.text = detailData.alarmName
        
        let dateData = detailData.alarmDate
        let yearstartIndex = dateData.startIndex
        let yearendIndex = dateData.index(yearstartIndex, offsetBy: 4)
        let yearsubstring = dateData[yearstartIndex..<yearendIndex]
        
        let monthstartIndex = dateData.index(dateData.startIndex, offsetBy: 5)
        let monthendIndex = dateData.index(monthstartIndex, offsetBy: 2)
        let monthsubstring = dateData[monthstartIndex..<monthendIndex]
        
        let daystartIndex = dateData.index(dateData.startIndex, offsetBy: 8)
        let dayendIndex = dateData.index(daystartIndex, offsetBy: 2)
        let daysubstring = dateData[daystartIndex..<dayendIndex]
        
        let timeData = detailData.alarmTime
        let timestartIndex = timeData.startIndex
        let timeendIndex = timeData.index(timestartIndex, offsetBy: 2)
        let timesubstring = timeData[timestartIndex..<timeendIndex]
        let isAfternoon = Int(timesubstring)
        let afterTime = (isAfternoon ?? 0) - 12
        
        let minuteendIndex = timeData.index(before: timeData.endIndex)
        let minutestartIndex = timeData.index(minuteendIndex, offsetBy: -2)
        let minutesubstring = timeData[minutestartIndex...minuteendIndex]
        
        if (isAfternoon ?? 0 <= 12) {
            cell.dateLabel.text = "\(yearsubstring)년 \(monthsubstring)월 \(daysubstring)일 오전 \(timeData)"
        } else {
            cell.dateLabel.text = "\(yearsubstring)년 \(monthsubstring)월 \(daysubstring)일 오후 \(afterTime)\(minutesubstring)"
        }
        
        if (detailData.onoff == 1) {
            cell.onoffSwitch.isOn = true
        } else {
            cell.onoffSwitch.isOn = false
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func handleButtonTap(for indexPath: IndexPath) {
        let detailData = allDetailDatas[indexPath.section]
        let parameters = AlarmPatchModel(alarmId: detailData.alarmId)
        if (detailData.onoff == 1) {
            APIAlarmPatch.instance.SendingPatchAlarmOff(parameters: parameters) { result in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    self.getAlarmList()
                }
            }
        } else if (detailData.onoff == 0) {
            APIAlarmPatch.instance.SendingPatchAlarmOn(parameters: parameters) { result in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    self.getAlarmList()
                }
            }
        }
    }
}

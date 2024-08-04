//
//  AlarmViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/22/24.
//

import UIKit
import DropDown

class AlarmViewController: UIViewController, dateProtocol {
    
    @IBOutlet weak var SchoolTF: UITextField!
    @IBOutlet weak var AlarmNameTF: UITextField!
    @IBOutlet weak var AlarmDateTF: UITextField!
    
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var DatePicker: UIPickerView!
    
    let drop = DropDown()
    let schoolName = ["   광운대학교", "   성신여자대학교", "   서경대학교", "   서울여자대학교", "   한성대학교"]
    
    var pickerHour = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var pickerMinute:[String] = []
    var pickerDay = ["오전", "오후"]
    
    var day: String = "오전"
    var hour: String = "8"
    var minute: String = "00"
    
    func dateSend(data: String) {
        AlarmDateTF.text = "   \(data)"
        dateLabel.text = "\(data)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SchoolTF.addBottomShadow()
        SchoolTF.isEnabled = false
        AlarmDateTF.isEnabled = false
        AlarmNameTF.addBottomShadow()
        AlarmDateTF.addBottomShadow()
        DatePicker.isHidden = true
        
        initUI()
        setDropdown()
        
        appendMinute()
        
        DatePicker.delegate = self
        DatePicker.dataSource = self
    }
    
    func appendMinute() {
        for i in 0..<60 {
            if i < 10 {
                pickerMinute.append("0\(i)")
            } else {
                pickerMinute.append("\(i)")
            }
        }
    }
    
    func initUI() {
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor(red: 236/255, green: 73/255, blue: 8/255, alpha: 1.0) // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0) // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor(red: 253/255, green: 233/255, blue: 230/255, alpha: 1.0) // 선택한 아이템 배경 색상
        DropDown.appearance().separatorColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
        DropDown.appearance().setupCornerRadius(5)
        DropDown.appearance().setupMaskedCorners(CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner))
        drop.dismissMode = .automatic // 팝업을 닫을 모드 설정
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 12)
    }
    
    func setDropdown() {
        // dataSource로 ItemList를 연결
        drop.dataSource = schoolName
        drop.cellHeight = 44
        // anchorView를 통해 UI와 연결
        drop.anchorView = self.SchoolTF
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        drop.bottomOffset = CGPoint(x: 0, y: 1.5 + SchoolTF.bounds.height)
        
        // Item 선택 시 처리
        drop.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self!.SchoolTF.text = " \(item)"
        }
        
        // 취소 시 처리
        drop.cancelAction = { [weak self] in
        }
    }
    
    @IBAction func drop_Tapped(_ sender: Any) {
        drop.show()
    }
    
    @IBAction func picker_Tapped(_ sender: Any) {
        DatePicker.isHidden = false
    }
    
    @IBAction func Date_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "AlarmDateVC") as? AlarmDateViewController else {
            return
        }
        nextVC.delegate = self
        self.present(nextVC, animated: false)
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

extension AlarmViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
                case 0:
                    return pickerDay.count
                case 1:
                    return pickerHour.count
                case 2:
                    return pickerMinute.count
                default:
                    return 0
                }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
            case 0:
                return "\(pickerDay[row])"
            case 1:
                return "\(pickerHour[row])"
            case 2:
                return "\(pickerMinute[row])"
            default:
                return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = view as! UILabel?
        if label == nil {
            label = UILabel()
            label?.textColor = UIColor.black
            label?.textAlignment = .center
        }
        switch component {
            case 0:
                label?.text = pickerDay[row]
                label?.font = UIFont(name:"Pretendard-Bold", size:20)
                return label!
            case 1:
                label?.text = pickerHour[row]
                label?.font = UIFont(name:"Pretendard-Medium", size:20)
                return label!
            case 2:
                label?.text = pickerMinute[row]
                label?.font = UIFont(name:"Pretendard-Medium", size:20)
                return label!
            default:
                return label!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            day = pickerDay[row]
        case 1:
            hour = pickerHour[row]
        case 2:
            minute = pickerMinute[row]
        default:
            timeButton.setTitle("오전 8:00", for: .normal)
        }
        
        timeButton.setTitle("\(day) \(hour):\(minute)", for: .normal)
    }
}

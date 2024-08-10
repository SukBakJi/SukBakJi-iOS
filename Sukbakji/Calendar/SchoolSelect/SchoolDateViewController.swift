//
//  SchoolDateViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/24/24.
//

import UIKit
import DropDown

class SchoolDateViewController: UIViewController {
    
    @IBOutlet weak var RecruitTF: UITextField!
    @IBOutlet weak var recruitFirstButton: UIButton!
    @IBOutlet weak var recruitSecondButton: UIButton!
    
    @IBOutlet weak var recruitDayLabel: UILabel!
    @IBOutlet weak var recruitTypeLabel: UILabel!
    
    @IBOutlet weak var warningImage: UIImageView!
    @IBOutlet weak var warningLabel: UILabel!
    
    let drop = DropDown()
    let recruitType = ["  일반전형", "  외국인전형", "  학부 대학원 연계과정"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RecruitTF.addBottomShadow()
        RecruitTF.isEnabled = false
        
        warningImage.isHidden = true
        warningLabel.isHidden = true
        
        initUI()
        setDropdown()
        
        recruitFirstButton.isEnabled = false
        recruitFirstButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        recruitSecondButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(self.didDismissDetailNotification(_:)),
                  name: NSNotification.Name("DismissOneMore"),
                  object: nil
        )
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if recruitFirstButton.image(for: .normal) == UIImage(named: "Sukbakji_RadioButton") && recruitSecondButton.image(for: .normal) == UIImage(named: "Sukbakji_RadioButton2") {
            recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
            recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
            recruitFirstButton.isEnabled = true
            recruitSecondButton.isEnabled = false
            recruitDayLabel.text = "2025년 후기"
        } else {
            recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
            recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
            recruitFirstButton.isEnabled = false
            recruitSecondButton.isEnabled = true
            recruitDayLabel.text = "2025년 전기"
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
        drop.dataSource = recruitType
        drop.cellHeight = 44
        // anchorView를 통해 UI와 연결
        drop.anchorView = self.RecruitTF
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        drop.bottomOffset = CGPoint(x: 0, y: 1.6 + RecruitTF.bounds.height)
        
        // Item 선택 시 처리
        drop.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self?.RecruitTF.text = " \(item)"
            self?.recruitTypeLabel.text = " \(item)"
            self?.recruitTypeLabel.textColor = UIColor(named: "Coquelicot")
        }
        
        // 취소 시 처리
        drop.cancelAction = { [weak self] in
            self?.RecruitTF.text = "일반전형"
        }
    }
    
    @IBAction func drop_Tapped(_ sender: Any) {
        drop.show()
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SchoolAlertVC") as? SchoolAlertViewController else {
            return
        }
        self.present(nextVC, animated: false)
    }
    
    @IBAction func next_Tapped(_ sender: Any) {
        if RecruitTF.text == "" {
            warningImage.isHidden = false
            warningLabel.isHidden = false
        }
    }
}

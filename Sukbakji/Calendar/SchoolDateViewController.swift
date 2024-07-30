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
    
    let drop = DropDown()
    let recruitType = ["   일반전형", "   외국인전형", "   학부 대학원 연계과정"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RecruitTF.addBottomShadow()
        RecruitTF.isEnabled = false
        
        initUI()
        setDropdown()
        
        recruitFirstButton.isEnabled = false
        recruitFirstButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        recruitSecondButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if recruitFirstButton.image(for: .normal) == UIImage(named: "Sukbakji_RadioButton") && recruitSecondButton.image(for: .normal) == UIImage(named: "Sukbakji_RadioButton2") {
            recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
            recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
            recruitFirstButton.isEnabled = true
            recruitSecondButton.isEnabled = false
        } else {
            recruitFirstButton.setImage(UIImage(named: "Sukbakji_RadioButton"), for: .normal)
            recruitSecondButton.setImage(UIImage(named: "Sukbakji_RadioButton2"), for: .normal)
            recruitFirstButton.isEnabled = false
            recruitSecondButton.isEnabled = true
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
        drop.bottomOffset = CGPoint(x: 0, y: 1.5 + RecruitTF.bounds.height)
        
        // Item 선택 시 처리
        drop.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self!.RecruitTF.text = " \(item)"
        }
        
        // 취소 시 처리
        drop.cancelAction = { [weak self] in
        }
    }
    
    @IBAction func drop_Tapped(_ sender: Any) {
        drop.show()
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

extension UITextField {
    func addBottomShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
}

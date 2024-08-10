//
//  EditInfoViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit
import DropDown

class EditInfoViewController: UIViewController {
    
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var belongTF: UITextField!
    @IBOutlet weak var researchTopicCV: UICollectionView!
    
    let drop = DropDown()
    let belongType = ["   학사 졸업 또는 재학", "   석사 재학", "   석사 졸업", "   박사 재학", "   박사 졸업", "   석박사 통합 재학"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        idTF.addBottomShadow()
        nameTF.addBottomShadow()
        belongTF.addBottomShadow()
        
        initUI()
        setDropdown()
        
        researchTopicCV.delegate = self
        researchTopicCV.dataSource = self
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
        drop.dataSource = belongType
        drop.cellHeight = 44
        // anchorView를 통해 UI와 연결
        drop.anchorView = self.belongTF
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        drop.bottomOffset = CGPoint(x: 0, y: 1.6 + belongTF.bounds.height)
        
        // Item 선택 시 처리
        drop.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self?.belongTF.text = " \(item)"
        }
        
        // 취소 시 처리
        drop.cancelAction = { [weak self] in
            self?.belongTF.text = "  학사 졸업 또는 재학"
        }
    }
    
    @IBAction func drop_Tapped(_ sender: Any) {
        drop.show()
    }
}

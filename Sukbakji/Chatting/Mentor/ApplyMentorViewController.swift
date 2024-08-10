//
//  ApplyMentorViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/10/24.
//

import UIKit

class ApplyMentorViewController: UIViewController {
    
    @IBOutlet weak var setButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingButton()
    }
    
    func settingButton() {
        setButton.isEnabled = false
        setButton.layer.masksToBounds = true
        setButton.layer.cornerRadius = 10
        setButton.backgroundColor = UIColor(hexCode: "EFEFEF")
        setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
    }
}

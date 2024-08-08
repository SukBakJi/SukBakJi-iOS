//
//  EditPWViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit

class EditPWViewController: UIViewController {
    
    @IBOutlet weak var currentPWTF: UITextField!
    @IBOutlet weak var newPWTF: UITextField!
    @IBOutlet weak var newPWAgainTF: UITextField!
    
    @IBOutlet weak var currentPWView: UIStackView!
    @IBOutlet weak var newPWView: UIStackView!
    @IBOutlet weak var newPWAgainView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPWTF.addBottomShadow()
        newPWTF.addBottomShadow()
        newPWAgainTF.addBottomShadow()
        
        currentPWView.isHidden = true
        newPWView.isHidden = true
        newPWAgainView.isHidden = true
    }
}

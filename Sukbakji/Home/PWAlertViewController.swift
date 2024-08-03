//
//  PWAlertViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit

class PWAlertViewController: UIViewController {
    
    @IBOutlet weak var PWAlertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PWAlertView.layer.cornerRadius = 10
    }
    
    @IBAction func ok_Button(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("CannotChangePW"), object: nil, userInfo: nil)
        self.presentingViewController?.dismiss(animated: false)
    }
}

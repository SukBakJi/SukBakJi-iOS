//
//  SchoolAlertViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/27/24.
//

import UIKit

class SchoolAlertViewController: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertView.layer.cornerRadius = 10
    }
    
    @IBAction func ok_Button(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("DismissOneMore"), object: nil, userInfo: nil)
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @IBAction func cancel_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
}

//
//  CalendarFBCViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/31/24.
//

import UIKit

class CalendarFBCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func setting_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "AlarmVC") as? AlarmViewController else {
            return
        }
        self.present(nextVC, animated: true)
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
}

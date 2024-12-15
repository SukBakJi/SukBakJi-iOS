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

        NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(self.didDismissDetailNotification(_:)),
                  name: NSNotification.Name("DismissTwo"),
                  object: nil
        )
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
        NotificationCenter.default.post(name: NSNotification.Name("AlarmComplete"), object: nil, userInfo: nil)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func myAlarm_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "MyAlarmVC") as? MyAlarmViewController else {
            return
        }
        self.present(nextVC, animated: true)
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

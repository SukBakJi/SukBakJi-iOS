//
//  MyAlarmViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/4/24.
//

import UIKit

class MyAlarmViewController: UIViewController {
    
    @IBOutlet weak var myAlarmTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myAlarmTV.delegate = self
        myAlarmTV.dataSource = self
        myAlarmTV.layer.masksToBounds = false// any value you want
        myAlarmTV.layer.shadowOpacity = 0.2// any value you want
        myAlarmTV.layer.shadowRadius = 2 // any value you want
        myAlarmTV.layer.shadowOffset = .init(width: 0, height: 0.5)
        myAlarmTV.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }

    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

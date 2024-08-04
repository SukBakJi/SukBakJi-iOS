//
//  SchoolCalendarViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/27/24.
//

import UIKit

class SchoolCalendarViewController: UIViewController {
    
    @IBOutlet weak var schoolCalendarTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        schoolCalendarTV.delegate = self
        schoolCalendarTV.dataSource = self
        schoolCalendarTV.layer.masksToBounds = false// any value you want
        schoolCalendarTV.layer.shadowOpacity = 0.2// any value you want
        schoolCalendarTV.layer.shadowRadius = 2 // any value you want
        schoolCalendarTV.layer.shadowOffset = .init(width: 0, height: 0.5)
        schoolCalendarTV.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

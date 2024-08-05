//
//  DateListViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/4/24.
//

import UIKit

class DateListViewController: UIViewController {
    
    @IBOutlet weak var dateListTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateListTV.delegate = self
        dateListTV.dataSource = self
        dateListTV.layer.masksToBounds = false// any value you want
        dateListTV.layer.shadowOpacity = 0.2// any value you want
        dateListTV.layer.shadowRadius = 2 // any value you want
        dateListTV.layer.shadowOffset = .init(width: 0, height: 0.5)
        dateListTV.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

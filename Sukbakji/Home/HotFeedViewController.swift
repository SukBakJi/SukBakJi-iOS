//
//  HotFeedViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/16/24.
//

import UIKit

class HotFeedViewController: UIViewController {
    
    @IBOutlet weak var HotFeedTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HotFeedTV.rowHeight = UITableView.automaticDimension
        HotFeedTV.estimatedRowHeight = UITableView.automaticDimension
        
        HotFeedTV.delegate = self
        HotFeedTV.dataSource = self
        HotFeedTV.layer.masksToBounds = false// any value you want
        HotFeedTV.layer.shadowOpacity = 0.2// any value you want
        HotFeedTV.layer.shadowRadius = 2 // any value you want
        HotFeedTV.layer.shadowOffset = .init(width: 0, height: 1)
        HotFeedTV.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
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

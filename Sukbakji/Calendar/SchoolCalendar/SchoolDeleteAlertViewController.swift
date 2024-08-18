//
//  SchoolDeleteAlertViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/27/24.
//

import UIKit

class SchoolDeleteAlertViewController: UIViewController {
    
    @IBOutlet weak var deleteView: UIView!
    
    var memberId: Int?
    var univId: Int?
    var season: String?
    var method: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        deleteView.layer.cornerRadius = 10
    }
    
    @IBAction func delete_Tapped(_ sender: Any) {
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
}

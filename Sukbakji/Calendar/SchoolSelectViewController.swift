//
//  SchoolSelectViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/18/24.
//

import UIKit

class SchoolSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func next_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SchoolDateVC") as? SchoolDateViewController else {
            return
        }
        self.present(nextVC, animated: false)
    }
}

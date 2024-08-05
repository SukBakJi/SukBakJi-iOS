//
//  SchoolSelectViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/18/24.
//

import UIKit

class SchoolSelectViewController: UIViewController {
    
    @IBOutlet weak var schoolCV: UICollectionView!
    @IBOutlet weak var SchoolTV: UITableView!
    @IBOutlet weak var noResultImage: UIImageView!
    @IBOutlet weak var noResultSV: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.schoolCV.dataSource = self
        self.schoolCV.delegate = self
        self.SchoolTV.dataSource = self
        self.SchoolTV.delegate = self
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

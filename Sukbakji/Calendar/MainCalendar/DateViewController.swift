//
//  DateViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/18/24.
//

import UIKit

class DateViewController: UIViewController {
    
    @IBOutlet weak var DateCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DateCV.delegate = self
        DateCV.dataSource = self
        
        DateCV.layer.masksToBounds = false// any value you want
        DateCV.layer.shadowOpacity = 0.2// any value you want
        DateCV.layer.shadowRadius = 2 // any value you want
        DateCV.layer.shadowOffset = .init(width: 0, height: 1)
    }

}

//
//  ADViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/5/24.
//

import UIKit

class ADViewController: UIViewController {
    
    @IBOutlet weak var ADCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ADCV.delegate = self
        ADCV.dataSource = self
        
        ADCV.layer.masksToBounds = false// any value you want
        ADCV.layer.shadowOpacity = 0.2// any value you want
        ADCV.layer.shadowRadius = 2 // any value you want
        ADCV.layer.shadowOffset = .init(width: 0, height: 0.2)
    }

}

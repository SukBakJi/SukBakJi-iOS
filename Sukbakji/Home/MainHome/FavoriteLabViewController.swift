//
//  FavoriteLabViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/16/24.
//

import UIKit

class FavoriteLabViewController: UIViewController {
    
    @IBOutlet weak var FavoriteLabCV: UICollectionView!
    @IBOutlet weak var FavoriteLabPV: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FavoriteLabCV.delegate = self
        FavoriteLabCV.dataSource = self
        
        FavoriteLabCV.layer.masksToBounds = false// any value you want
        FavoriteLabCV.layer.shadowOpacity = 0.2// any value you want
        FavoriteLabCV.layer.shadowRadius = 2 // any value you want
        FavoriteLabCV.layer.shadowOffset = .init(width: 0, height: 0.2)
        
        FavoriteLabPV.setProgress(0, animated: true)
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

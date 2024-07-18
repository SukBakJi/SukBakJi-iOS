//
//  FavoriteBoardViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/16/24.
//

import UIKit

class FavoriteBoardViewController: UIViewController {
    
    @IBOutlet weak var FavoriteBoardTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FavoriteBoardTV.delegate = self
        FavoriteBoardTV.dataSource = self
        FavoriteBoardTV.layer.masksToBounds = false// any value you want
        FavoriteBoardTV.layer.shadowOpacity = 0.2// any value you want
        FavoriteBoardTV.layer.shadowRadius = 2 // any value you want
        FavoriteBoardTV.layer.shadowOffset = .init(width: 0, height: 1)
        FavoriteBoardTV.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
}

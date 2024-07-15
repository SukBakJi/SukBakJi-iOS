//
//  HomeViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/15/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var UpComingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UpComingView.layer.cornerRadius = 10
        UpComingView.layer.masksToBounds = false// any value you want
        UpComingView.layer.shadowOpacity = 0.2// any value you want
        UpComingView.layer.shadowRadius = 2 // any value you want
        UpComingView.layer.shadowOffset = .init(width: 0, height: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

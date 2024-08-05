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
        UpComingView.layer.shadowOffset = .init(width: 0, height: 0.2)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func info_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MypageVC") as? MypageViewController else { return }
        
        self.present(nextVC, animated: true)
    }
}

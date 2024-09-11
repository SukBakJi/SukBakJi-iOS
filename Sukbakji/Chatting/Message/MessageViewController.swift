//
//  MessageViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import UIKit

class MessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func go_Chat(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as? ChatViewController else { return }
        
        self.present(nextVC, animated: true)
    }
}

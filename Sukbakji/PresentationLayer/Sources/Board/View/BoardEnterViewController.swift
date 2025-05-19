//
//  BoardEnterViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit

class BoardEnterViewController: UIViewController {
    
    private let boardEnterView = BoardEnterView()
    
    override func loadView() {
        self.view = boardEnterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

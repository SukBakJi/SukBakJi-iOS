//
//  BoardMasterViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/17/25.
//

import UIKit

class BoardMasterViewController: UIViewController {
    
    private let boardMasterView = BoardMasterView()
    
    override func loadView() {
        self.view = boardMasterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

//
//  DetailTOSViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 2/19/25.
//

import UIKit

class DetailTOSViewController: UIViewController {
    //MARK: - Views
    private lazy var detailTosView = DetailTOSView(tosText: <#T##String#>)
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = detailTosView
    }
    
}

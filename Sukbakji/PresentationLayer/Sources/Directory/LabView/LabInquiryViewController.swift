//
//  LabInquiryViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/4/25.
//

import UIKit

class LabInquiryViewController: UIViewController {
    
    private let labInquiryView = LabInquiryView()
    var labId: Int = 0
    
    init(labId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.labId = labId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = labInquiryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
}

//
//  DetailTOSViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 2/19/25.
//

import UIKit

class DetailTOSViewController: UIViewController {
    private let tosData: TOSData
    
    init(tosData: TOSData) {
        self.tosData = tosData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Views
    private lazy var detailTosView = DetailTOSView(tosData: tosData)
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = detailTosView
        self.title = tosData.title
         
    }
}

//
//  ApplyMentoringViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/10/24.
//

import UIKit

class ApplyMentoringViewController: UIViewController {
    
    @IBOutlet weak var MentoringTV: UITableView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var moreView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setMoreButton()
    }
    
    func setTableView() {
        MentoringTV.delegate = self
        MentoringTV.dataSource = self
        MentoringTV.layer.masksToBounds = true// any value you want
        MentoringTV.layer.shadowOpacity = 0.2// any value you want
        MentoringTV.layer.shadowRadius = 2 // any value you want
        MentoringTV.layer.shadowOffset = .init(width: 0, height: 0.2)
        MentoringTV.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    func setMoreButton() {
        moreButton.layer.masksToBounds = true
        moreButton.layer.cornerRadius = 15
        moreButton.layer.borderColor = UIColor(hexCode: "E1E1E1").cgColor
        moreButton.layer.borderWidth = 1.0
    }
    
    @IBAction func more_Tapped(_ sender: Any) {
        MentoringTV.isScrollEnabled = true
        moreView.isHidden = true
    }
}

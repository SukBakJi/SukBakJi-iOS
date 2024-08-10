//
//  SchoolSelectViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/18/24.
//

import UIKit

class SchoolSelectViewController: UIViewController {
    
    @IBOutlet weak var schoolCV: UICollectionView!
    @IBOutlet weak var SchoolTV: UITableView!
    @IBOutlet weak var noResultImage: UIImageView!
    @IBOutlet weak var noResultSV: UIStackView!
    
    @IBOutlet weak var schoolSearchTF: UITextField!
    @IBOutlet weak var setButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.schoolCV.dataSource = self
        self.schoolCV.delegate = self
        self.SchoolTV.dataSource = self
        self.SchoolTV.delegate = self
        
        self.SchoolTV.isHidden = true
        
        schoolSearchTF.errorfix()
        schoolSearchTF.addTarget(self, action: #selector(schoolSearch(_:)), for: .editingChanged)
        
        settingButton()
        
        NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(self.didDismissDetailNotification(_:)),
                  name: NSNotification.Name("DismissTwo"),
                  object: nil
        )
    }
    
    @objc func didDismissDetailNotification(_ notification: Notification) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func settingButton() {
        setButton.isEnabled = false
        setButton.layer.masksToBounds = true
        setButton.layer.cornerRadius = 10
        setButton.backgroundColor = UIColor(hexCode: "EFEFEF")
        setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
    }
    
    @objc func schoolSearch(_ textField: UITextField) {
        
        if schoolSearchTF.text == "ㅅ" {
            SchoolTV.isHidden = false
            setButton.isEnabled = true
            setButton.backgroundColor = UIColor(named: "Coquelicot")
            setButton.setTitleColor(.white, for: .normal)
            setButton.setTitleColor(.white, for: .selected)
        }
        else {
            SchoolTV.isHidden = true
            setButton.isEnabled = false
            setButton.backgroundColor = UIColor(hexCode: "EFEFEF")
            setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
            setButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .selected)
        }
        
        UIView.animate(withDuration: 0.1) { // 효과 주기
                self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func next_Tapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SchoolDateVC") as? SchoolDateViewController else {
            return
        }
        self.present(nextVC, animated: false)
    }
}

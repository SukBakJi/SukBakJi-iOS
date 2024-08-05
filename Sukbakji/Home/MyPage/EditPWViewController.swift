//
//  EditPWViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit

class EditPWViewController: UIViewController {
    
    @IBOutlet weak var currentPWTF: UITextField!
    @IBOutlet weak var newPWTF: UITextField!
    @IBOutlet weak var newPWAgainTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentPWTF.addBottomShadow()
        newPWTF.addBottomShadow()
        newPWAgainTF.addBottomShadow()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

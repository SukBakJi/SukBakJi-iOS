//
//  EditInfoViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/24.
//

import UIKit

class EditInfoViewController: UIViewController {
    
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var belongTF: UITextField!
    @IBOutlet weak var researchTopicCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        idTF.addBottomShadow()
        nameTF.addBottomShadow()
        belongTF.addBottomShadow()
        
        researchTopicCV.delegate = self
        researchTopicCV.dataSource = self
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

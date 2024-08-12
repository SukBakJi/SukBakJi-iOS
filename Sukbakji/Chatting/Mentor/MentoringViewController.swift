//
//  MentoringViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import UIKit

class MentoringViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func apply_Mentoring(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ApplyMentoringVC") as? ApplyMentoringViewController else { return }
        
        self.present(nextVC, animated: true)
    }
    
    @IBAction func apply_Mentor(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ApplyMentorVC") as? ApplyMentorViewController else { return }
        
        self.present(nextVC, animated: true)
    }
}

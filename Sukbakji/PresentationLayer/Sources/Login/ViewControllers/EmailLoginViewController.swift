//
//  EmailLoginViewControllers.swift
//  Sukbakji
//
//  Created by 오현민 on 7/16/24.
//

import UIKit


class EmailLoginViewController: UIViewController {
    private var emailView = EmailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = emailView
        self.title = "이메일로 로그인"
    }
}



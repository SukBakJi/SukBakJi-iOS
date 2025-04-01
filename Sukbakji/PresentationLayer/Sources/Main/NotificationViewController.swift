//
//  NotificationViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 4/1/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NotificationViewController: UIViewController {
    
    private let notificationView = NotificationView()
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = notificationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        notificationView.navigationbarView.delegate = self
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
}

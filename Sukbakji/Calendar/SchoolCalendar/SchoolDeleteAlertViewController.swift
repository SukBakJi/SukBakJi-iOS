//
//  SchoolDeleteAlertViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/27/24.
//

import UIKit

class SchoolDeleteAlertViewController: UIViewController {
    
    @IBOutlet weak var deleteView: UIView!
    
    var memberId: Int?
    var univId: Int?
    var season: String?
    var method: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        deleteView.layer.cornerRadius = 10
    }
    
    @IBAction func delete_Tapped(_ sender: Any) {
        let parameters = UniDeleteModel(memberId: memberId ?? 0, univId: univId ?? 0, season: season ?? "", method: method ?? "")
        APIUniDelete.instance.SendingUniDelete(parameters: parameters) { result in
            switch result {
            case .success:
                // 사용자에게 삭제 성공 알림
                print("University deletion successful.")
            case .failure(let error):
                // 사용자에게 오류 알림
                print("Failed to delete university: \(error.localizedDescription)")
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name("deleteUni"), object: nil, userInfo: nil)
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
}

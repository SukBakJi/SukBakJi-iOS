//
//  FavoriteBoardViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/16/24.
//

import UIKit
import RxAlamofire
import Alamofire
import RxSwift

class FavoriteBoardViewController: UIViewController {
    
    @IBOutlet weak var FavoriteBoardTV: UITableView!
    @IBOutlet weak var noFavLabel: UILabel!
    @IBOutlet weak var letsFavLabel: UILabel!
   
   private let disposeBag = DisposeBag()
    
    var allDatas: [FavoritesBoardResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFavoriteBoardTV()
    }
    
    func setFavoriteBoardTV() {
        FavoriteBoardTV.delegate = self
        FavoriteBoardTV.dataSource = self
        FavoriteBoardTV.layer.masksToBounds = true// any value you want
        FavoriteBoardTV.layer.shadowOpacity = 0.2// any value you want
        FavoriteBoardTV.layer.shadowRadius = 2 // any value you want
        FavoriteBoardTV.layer.shadowOffset = .init(width: 0, height: 0.5)
        FavoriteBoardTV.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getFavoriteBoard()
        }
    }
    
    func getFavoriteBoard() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        let url = APIConstants.community.path + "/favorite-post-list"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
       RxAlamofire.requestData(.get, url, headers: headers)
          .subscribe(onNext: { [weak self] (response, data) in
                do {
                    let decodedData = try JSONDecoder().decode(FavoritesBoardResultModel.self, from: data)
                    self?.allDatas = decodedData.result
                    
                    DispatchQueue.main.async {
                        self?.FavoriteBoardTV.reloadData()
                    }
                } catch let error {
                   print("Decoding error: \(error)")
               }
           }, onError: { error in
               print("Error: \(error)")
           })
           .disposed(by: disposeBag)
    }
}

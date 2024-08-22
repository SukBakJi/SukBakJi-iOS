//
//  FavoriteBoardViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/16/24.
//

import UIKit
import Alamofire

class FavoriteBoardViewController: UIViewController {
    
    @IBOutlet weak var FavoriteBoardTV: UITableView!
    @IBOutlet weak var noFavLabel: UILabel!
    @IBOutlet weak var letsFavLabel: UILabel!
    
    var allDatas: [FavoritesBoardResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.getFavoriteBoard()
    }
    
    func getFavoriteBoard() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            print("Failed to retrieve password.")
            return
        }
        
        let url = APIConstants.communityURL + "/favorite-post-list"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(FavoritesBoardResultModel.self, from: data)
                    self.allDatas = decodedData.result
                    DispatchQueue.main.async {
                        self.FavoriteBoardTV.reloadData()
                    }
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

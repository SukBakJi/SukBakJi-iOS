//
//  FavoriteLabViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 7/16/24.
//

import UIKit
import Alamofire

class FavoriteLabViewController: UIViewController {
    
    @IBOutlet weak var FavoriteLabCV: UICollectionView!
    @IBOutlet weak var FavoriteLabPV: UIProgressView!
    
    @IBOutlet weak var noFavLabel: UILabel!
    @IBOutlet weak var letsFavLabel: UILabel!
    
    var allDatas: [FavoritesLabResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FavoriteLabCV.delegate = self
        FavoriteLabCV.dataSource = self
        
        FavoriteLabCV.layer.masksToBounds = false// any value you want
        FavoriteLabCV.layer.shadowOpacity = 0.2// any value you want
        FavoriteLabCV.layer.shadowRadius = 2 // any value you want
        FavoriteLabCV.layer.shadowOffset = .init(width: 0, height: 0.2)
        
        FavoriteLabPV.setProgress(0, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getFavoriteLab()
    }
    
    func getFavoriteLab() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            print("Failed to retrieve password.")
            return
        }
        
        let url = APIConstants.labURL + "/mypage/favorite-labs"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(FavoritesLabResultModel.self, from: data)
                    self.allDatas = decodedData.result
                    DispatchQueue.main.async {
                        self.FavoriteLabCV.reloadData()
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

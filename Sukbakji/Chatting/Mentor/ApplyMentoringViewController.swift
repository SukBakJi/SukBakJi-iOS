//
//  ApplyMentoringViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 8/10/24.
//

import UIKit
import Alamofire

class ApplyMentoringViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabelOne: UILabel!
    @IBOutlet weak var titleLabelSecond: UILabel!
    @IBOutlet weak var titleLabelThird: UILabel!
    @IBOutlet weak var noResultImage: UIImageView!
    @IBOutlet weak var noResultSV: UIStackView!
    @IBOutlet weak var searchLabel: UILabel!
    
    @IBOutlet weak var MentoringTV: UITableView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var moreView: UIView!
    
    @IBOutlet weak var mentorSearchTF: UITextField!
    
    private var allDatas: MentorListResponse?
    var allDetailDatas: [MentorList] = []
    
    private var selectedIndex: IndexPath?
    
    private var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setMoreButton()
        
        hideKeyboardWhenTappedAround()
        
        setTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getMentorList()
        }
    }
    
    func setTextField() {
        mentorSearchTF.errorfix()
        mentorSearchTF.delegate = self
    }
    
    func setTableView() {
        MentoringTV.delegate = self
        MentoringTV.dataSource = self
        MentoringTV.layer.masksToBounds = true// any value you want
        MentoringTV.layer.shadowOpacity = 0.2// any value you want
        MentoringTV.layer.shadowRadius = 2 // any value you want
        MentoringTV.layer.shadowOffset = .init(width: 0, height: 0.2)
        MentoringTV.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    func setMoreButton() {
        moreButton.layer.masksToBounds = true
        moreButton.layer.cornerRadius = 15
        moreButton.layer.borderColor = UIColor(hexCode: "E1E1E1").cgColor
        moreButton.layer.borderWidth = 1.0
    }
    
    func getMentorList() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        let url = APIConstants.mentor.path
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(retrievedToken)",
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(MentorListResultModel.self, from: data)
                    self.allDatas = decodedData.result
                    self.allDetailDatas = self.allDatas?.mentorList ?? []
                    
                    DispatchQueue.main.async {
                        self.MentoringTV.reloadData()
                        
                        self.noResultImage.isHidden = true
                        self.noResultSV.isHidden = true
                        self.titleLabelOne.isHidden = false
                        self.titleLabelSecond.isHidden = false
                        self.titleLabelThird.isHidden = false
                        if self.allDetailDatas.count >= 4 {
                            self.moreView.isHidden = false
                        } else {
                            self.moreView.isHidden = true
                        }
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
    
    func getMentor() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }

        let url = APIConstants.mentor.path + "/search"
        
        let parameter: Parameters = [
            "keyword": "\(mentorSearchTF.text ?? "")"
        ]
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "Authorization": "Bearer \(retrievedToken)"
        ]
        
        AF.request(url, method: .get, parameters: parameter, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(MentorListResultModel.self, from: data)
                    self.allDatas = decodedData.result
                    self.allDetailDatas = self.allDatas?.mentorList ?? []
                    
                    DispatchQueue.main.async {
                        self.MentoringTV.reloadData()
                    
                        if (self.allDetailDatas.count == 0) {
                            self.noResultImage.isHidden = false
                            self.noResultSV.isHidden = false
                            self.searchLabel.text = self.mentorSearchTF.text
                        } else if (self.allDetailDatas.count >= 1) {
                            self.noResultImage.isHidden = true
                            self.noResultSV.isHidden = true
                        }
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchTimer?.invalidate() // 이전 타이머를 취소
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if updatedText.isEmpty {
            getMentorList()
            return true
        }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] _ in
            self?.getMentor()
        })
        
        return true
    }
    
    @IBAction func more_Tapped(_ sender: Any) {
        MentoringTV.isScrollEnabled = true
        moreView.isHidden = true
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

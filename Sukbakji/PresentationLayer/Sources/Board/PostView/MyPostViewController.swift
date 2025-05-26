//
//  MyPostViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MyPostViewController: UIViewController {

    private var myPostView = MyPostView(title: "")
    private let myPostViewModel = MyPostViewModel()
    var disposeBag = DisposeBag()
    
    private var isPost: Int = 0
    
    init(title: String, isPost: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.myPostView = MyPostView(title: title)
        self.isPost = isPost
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = myPostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setBind()
        setAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        myPostView.navigationbarView.delegate = self
    }
}

extension MyPostViewController {
    
    private func setBind() {
        if isPost == 0 {
            bindMyPostViewModel()
        } else if isPost == 1 {
            bindScrapViewModel()
        } else {
            bindMyCommentViewModel()
        }
    }
    
    private func setAPI() {
        if isPost == 0 {
            myPostViewModel.loadmyPostList()
        } else if isPost == 1 {
            myPostViewModel.loadScrapList()
        } else {
            myPostViewModel.loadMyCommentList()
        }
    }
    
    private func bindMyPostViewModel() {
        self.myPostView.myPostTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        myPostViewModel.myPostList
            .bind(to: myPostView.myPostTableView.rx.items(cellIdentifier: MyPostTableViewCell.identifier, cellType: MyPostTableViewCell.self)) { row, post, cell in
                cell.prepare(myPost: post)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindScrapViewModel() {
        self.myPostView.myPostTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        myPostViewModel.scrapList
            .bind(to: myPostView.myPostTableView.rx.items(cellIdentifier: MyPostTableViewCell.identifier, cellType: MyPostTableViewCell.self)) { row, post, cell in
                cell.prepare(myPost: post)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindMyCommentViewModel() {
        self.myPostView.myPostTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        myPostViewModel.myCommentList
            .bind(to: myPostView.myPostTableView.rx.items(cellIdentifier: MyPostTableViewCell.identifier, cellType: MyPostTableViewCell.self)) { row, post, cell in
                cell.prepare(myPost: post)
            }
            .disposed(by: disposeBag)
    }
}

extension MyPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 137
    }
}

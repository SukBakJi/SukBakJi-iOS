//
//  PostListViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/14/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PostListViewController: UIViewController {
    
    private var postListView = PostListView(title: "", buttonTitle: "", buttonHidden: true)
    private let hotPostViewModel = HotPostViewModel()
    var disposeBag = DisposeBag()
    
    private var isPost: Int = 0
    
    init(title: String, buttonTitle: String, isPost: Int, isHidden: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.postListView = PostListView(title: title, buttonTitle: buttonTitle, buttonHidden: isHidden)
        self.isPost = isPost
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = postListView
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
        postListView.optionNavigationbarView.delegate = self
        
        if isPost == 0 {
            postListView.noticeButton.addTarget(self, action: #selector(clickNoticeButton), for: .touchUpInside)
        }
    }
}
    
extension PostListViewController {
    
    private func setBind() {
        if isPost == 0 {
            bindHotPostViewModel()
        }
    }
    
    private func setAPI() {
        if isPost == 0 {
            hotPostViewModel.loadHotPost()
        }
    }
    
    private func bindHotPostViewModel() {
        self.postListView.postListTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        hotPostViewModel.hotPostList
            .bind(to: postListView.postListTableView.rx.items(cellIdentifier: PostListTableViewCell.identifier, cellType: PostListTableViewCell.self)) { row, post, cell in
                cell.hotPrepare(hotPost: post)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func clickNoticeButton() {
        let noticeView = NoticeView(title: "스크랩 20개 이상 또는 조회수 100회 이상인 게시글의 경우 HOT 게시판에 선정되어 게시됩니다")
        self.view.addSubview(noticeView)
        noticeView.alpha = 0
        noticeView.snp.makeConstraints { $0.edges.equalToSuperview() }
        UIView.animate(withDuration: 0.3) { noticeView.alpha = 1 }
    }
}

extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
}

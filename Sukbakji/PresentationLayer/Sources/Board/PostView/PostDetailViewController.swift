//
//  PostDetailViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 5/15/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PostDetailViewController: UIViewController {
    
    private var postDetailView = PostDetailView(title: "")
    private let postViewModel = PostViewModel()
    var disposeBag = DisposeBag()
    
    var postId: Int = 0
    
    init(title: String, postId: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.postDetailView = PostDetailView(title: title)
        self.postId = postId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = postDetailView
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
        postDetailView.optionNavigationbarView.delegate = self
    }
}

extension PostDetailViewController {
    
    private func setCommentsData() {
        postDetailView.commentListTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        self.postViewModel.postCommentList
            .observe(on: MainScheduler.instance)
            .bind(to: postDetailView.commentListTableView.rx.items(cellIdentifier: CommentListTableViewCell.identifier, cellType: CommentListTableViewCell.self)) { index, item, cell in
                let isLast = index == self.postViewModel.postCommentList.value.count - 1
                cell.prepare(comment: item, isLast: isLast)
            }
            .disposed(by: disposeBag)
    }
    
    private func setBind() {
        postViewModel.postDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                self?.postViewModel.postCommentList.accept(detail.comments)
                self?.postDetailView.labelLabel.text = detail.menu
                self?.postDetailView.titleLabel.text = detail.title
                self?.postDetailView.contentLabel.text = detail.content
                self?.postDetailView.commentLabel.text = "댓글 \(detail.commentCount)"
                self?.postDetailView.viewLabel.text = "조회수 \(detail.views)"
                self?.setCommentsData()
            })
            .disposed(by: disposeBag)
        
        postViewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { message in
                AlertController(message: message).show()
            })
            .disposed(by: disposeBag)
    }
    
    private func setAPI() {
        postViewModel.loadPostDatil(postId: postId)
    }
}

extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }
}

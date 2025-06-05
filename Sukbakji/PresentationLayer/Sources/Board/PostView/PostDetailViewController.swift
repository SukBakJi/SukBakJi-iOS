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

class PostDetailViewController: UIViewController, CommentCellDelegate {
    
    private let memberId = UserDefaults.standard.integer(forKey: "memberID")
    
    private var postDetailView = PostDetailView(title: "")
    private let postViewModel = PostViewModel()
    private let favScrapViewModel = FavScrapViewModel()
    private let reportViewModel = ReportViewModel()
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
        setDelegate()
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
        
        postDetailView.scrapButton.addTarget(self, action: #selector(scrapButton), for: .touchUpInside)
        postDetailView.commentInputView.inputTextField.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        postDetailView.commentInputView.sendButton.addTarget(self, action: #selector(clickSendButton), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(commentSettingComplete), name: .isCommentComplete, object: nil)
    }
    
    @objc func textFieldEdited(_ textField: UITextField) {
        postDetailView.commentInputView.inputTextField.updateUnderlineColor(to: .blue400)
    }
}

extension PostDetailViewController {
    
    private func setDelegate() {
        postDetailView.commentListTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setBind() {
        self.postViewModel.postCommentList
            .observe(on: MainScheduler.instance)
            .bind(to: postDetailView.commentListTableView.rx.items(cellIdentifier: CommentListTableViewCell.identifier, cellType: CommentListTableViewCell.self)) { index, item, cell in
                let isLast = index == self.postViewModel.postCommentList.value.count - 1
                cell.prepare(comment: item, isLast: isLast)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
        
        postViewModel.postDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                self?.postViewModel.postCommentList.accept(detail.comments)
                self?.postDetailView.labelLabel.text = detail.menu
                self?.postDetailView.titleLabel.text = detail.title
                self?.postDetailView.contentLabel.text = detail.content
                self?.postDetailView.commentLabel.text = "댓글 \(detail.commentCount)"
                self?.postDetailView.viewLabel.text = "조회수 \(detail.views)"
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
        setBind()
        postViewModel.loadPostDetail(postId: postId)
        favScrapViewModel.loadScrapList(postId: postId, scrapButton: postDetailView.scrapButton)
    }
    
    @objc private func scrapButton() {
        let isCurrentlyScrapped = postDetailView.scrapButton.image(for: .normal) == UIImage(named: "Sukbakji_Bookmark2")
        let newImageName = isCurrentlyScrapped ? "Sukbakji_Bookmark" : "Sukbakji_Bookmark2"
        postDetailView.scrapButton.setImage(UIImage(named: newImageName), for: .normal)
        favScrapViewModel.scrapPost(postId: postId)
    }
    
    @objc private func clickSendButton() {
        postViewModel.enrollComment(postId: postId, content: postDetailView.commentInputView.inputTextField.text)
        postDetailView.commentInputView.inputTextField.text = ""
    }
    
    @objc private func commentSettingComplete() {
        postViewModel.loadPostDetail(postId: postId)
    }
    
    func didTapMoreButton(cell: CommentListTableViewCell) {
        guard let indexPath = postDetailView.commentListTableView.indexPath(for: cell) else { return }
        self.postViewModel.selectCommentItem = postViewModel.postCommentList.value[indexPath.row]

        let alert = UIAlertController(title: postDetailView.optionNavigationbarView.titleLabel.text,
                                          message: nil,
                                          preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "수정하기", style: .default) { _ in
            
        }
        let report = UIAlertAction(title: "신고하기", style: .default) { _ in
            let reasonAlert = UIAlertController(title: "신고하기", message: nil, preferredStyle: .actionSheet)
            
            let reasons = [
                "욕설/비하",
                "유출/사칭/사기",
                "상업적 광고 및 판매",
                "음란물/불건전한 대화 및 만남",
                "게시판 주제에 부적절함",
                "정당/정치인 비하 및 선거운동",
                "낚시/도배"
            ]
            
            for reason in reasons {
                reasonAlert.addAction(UIAlertAction(title: reason, style: .default) { _ in
                    self.reportViewModel.loadReportComment(commentId: self.postViewModel.selectCommentItem!.commentId, reason: reason)
                })
            }
            
            reasonAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            if let popover = reasonAlert.popoverPresentationController {
                popover.sourceView = cell
                popover.sourceRect = cell.bounds
            }
            
            self.present(reasonAlert, animated: true)
        }
        let delete = UIAlertAction(title: "삭제하기", style: .destructive)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        if self.postViewModel.selectCommentItem?.memberId == memberId {
            alert.addAction(edit)
            alert.addAction(delete)
        } else {
            alert.addAction(report)
        }
        
        alert.addAction(cancel)

        if let popover = alert.popoverPresentationController {
            popover.sourceView = cell
            popover.sourceRect = cell.bounds
        }

        present(alert, animated: true)
    }
}

extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }
}

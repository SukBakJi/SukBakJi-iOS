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
    var writerId: Int = 0
    
    private weak var currentResponderView: UIView?
    
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
        hideKeyboardWhenTappedAround()
        setDelegate()
        setAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarVC = self.tabBarController as? MainTabViewController {
            tabBarVC.customTabBarView.isHidden = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        postDetailView.optionNavigationbarView.delegate = self
        postDetailView.commentInputView.inputTextField.delegate = self
        
        postDetailView.optionNavigationbarView.optionButton.addTarget(self, action: #selector(option_Tapped), for: .touchUpInside)
        postDetailView.scrapButton.addTarget(self, action: #selector(scrap_Tapped), for: .touchUpInside)
        postDetailView.commentEditView.editButton.addTarget(self, action: #selector(updateComment), for: .touchUpInside)
        postDetailView.commentInputView.sendButton.addTarget(self, action: #selector(send_Tapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(commentSettingComplete), name: .isCommentComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postDeleteComplete), name: .isPostDeleteComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let targetView = currentResponderView else { return }
        
        UIView.animate(withDuration: duration) {
            targetView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
        }
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let targetView = currentResponderView else { return }
        
        UIView.animate(withDuration: duration) {
            targetView.transform = .identity
        }
    }
}

extension PostDetailViewController {
    
    private func setAPI() {
        setBind()
        postViewModel.loadPostDetail(postId: postId)
        favScrapViewModel.loadScrapList(postId: postId, scrapButton: postDetailView.scrapButton)
    }
    
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
                self?.writerId = detail.memberId
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
    
    func didTapMoreButton(cell: CommentListTableViewCell) {
        guard let indexPath = postDetailView.commentListTableView.indexPath(for: cell) else { return }
        self.postViewModel.selectCommentItem = postViewModel.postCommentList.value[indexPath.row]

        let alert = UIAlertController(title: postDetailView.optionNavigationbarView.titleLabel.text,
                                          message: nil,
                                          preferredStyle: .actionSheet)
        
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
            self.present(reasonAlert, animated: true)
        }
        let edit = UIAlertAction(title: "수정하기", style: .default) { _ in
            self.postDetailView.commentEditView.isHidden = false
            self.postDetailView.commentEditView.inputTextView.text = self.postViewModel.selectCommentItem?.content
            self.currentResponderView = self.postDetailView.commentEditView
            self.postDetailView.commentEditView.inputTextView.becomeFirstResponder()
        }
        let delete = UIAlertAction(title: "삭제하기", style: .default) { _ in
            let alert = UIAlertController(title: nil, message: "서비스 준비 중입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        if self.postViewModel.selectCommentItem?.memberId == memberId {
            alert.addAction(edit)
            alert.addAction(delete)
        } else {
            alert.addAction(report)
        }
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    @objc private func option_Tapped() {
        let alert = UIAlertController(title: postDetailView.optionNavigationbarView.titleLabel.text,
                                          message: nil,
                                          preferredStyle: .actionSheet)
        
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
                    self.reportViewModel.loadReportPost(postId: self.postId, reason: reason)
                })
            }
            reasonAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
            self.present(reasonAlert, animated: true)
        }
        let edit = UIAlertAction(title: "수정하기", style: .default) { _ in
            let alert = UIAlertController(title: nil, message: "서비스 준비 중입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
        let delete = UIAlertAction(title: "삭제하기", style: .default) { _ in
            let deleteView = BoardDeleteView(title: "게시물 삭제하기", content: "게시물을 삭제할까요? 삭제 후 복구되지 않습니다", viewModel: self.postViewModel, postId: self.postId)
            
            self.view.addSubview(deleteView)
            deleteView.alpha = 0
            deleteView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.3) {
                deleteView.alpha = 1
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        if self.writerId == memberId {
            alert.addAction(edit)
            alert.addAction(delete)
        } else {
            alert.addAction(report)
        }
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    @objc private func scrap_Tapped() {
        let isCurrentlyScrapped = postDetailView.scrapButton.image(for: .normal) == UIImage(named: "Sukbakji_Bookmark2")
        let newImageName = isCurrentlyScrapped ? "Sukbakji_Bookmark" : "Sukbakji_Bookmark2"
        postDetailView.scrapButton.setImage(UIImage(named: newImageName), for: .normal)
        favScrapViewModel.scrapPost(postId: postId)
    }
    
    @objc private func send_Tapped() {
        postViewModel.enrollComment(postId: postId, content: postDetailView.commentInputView.inputTextField.text)
        postDetailView.commentInputView.inputTextField.text = ""
    }
    
    @objc private func commentSettingComplete() {
        postViewModel.loadPostDetail(postId: postId)
    }
    
    @objc private func postDeleteComplete() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func updateComment() {
        postViewModel.loadEditComment(commentId: postViewModel.selectCommentItem!.commentId, content: postDetailView.commentEditView.inputTextView.text)
    }
}

extension PostDetailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == postDetailView.commentInputView.inputTextField {
            currentResponderView = postDetailView.commentInputView
        }
        postDetailView.commentInputView.inputTextField.updateUnderlineColor(to: .blue400)
        postDetailView.commentInputView.inputTextField.becomeFirstResponder()
    }
}

extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }
}

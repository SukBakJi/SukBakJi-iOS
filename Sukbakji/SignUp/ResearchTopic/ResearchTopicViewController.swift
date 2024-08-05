//
//  ResearchTopicViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 7/27/24.
//

import UIKit

class ResearchTopicViewController: UIViewController {
    // MARK: - ImageView
    private let progressBar = UIImageView().then {
        $0.image = UIImage(named: "ProgressBar_2")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let topicDot = UIImageView().then {
        $0.image = UIImage(named: "dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let deletedAlert = UIImageView().then {
        $0.image = UIImage(named: "deletedAlert")
        $0.alpha = 0
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // MARK: - Label
    private let titleLabel = UILabel().then {
        $0.text = "연구하고 싶은 주제가 무엇인가요?"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let subtitlelabel = UILabel().then {
        $0.text = "검색을 통해 최대 5개를 선택해 주세요"
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.numberOfLines = 0
    }
    private let topicLabel = UILabel().then {
        $0.text = "연구 주제"
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let descLabel = UILabel().then {
        $0.text = "연구 주제를 검색 후 선택해 주세요 (최대 5개)"
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.numberOfLines = 0
    }
    // MARK: - Button
    private let nextButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray200
        $0.setTitleColor(.gray500, for: .normal)
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    private let plusButton = UIButton().then {
        $0.setImage(UIImage(named: "plusButton"), for: .normal)
        $0.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    // MARK: - view
    private let containerView = UIView()
    private let underLine = UIView().then {
        $0.backgroundColor = .gray300
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setUpNavigationBar()
        setupViews()
        setupLayout()
        updateCollectionViewHeight()
    }
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "회원가입"
    }
    
    // MARK: - Screen transition
    @objc private func nextButtonTapped() {
        let SuccessSignUpVC = successSignUpViewController()
        self.navigationController?.pushViewController(SuccessSignUpVC, animated: true)
        
    }
    @objc private func plusButtonTapped() {
        let SelectResearchTopicVC = SelectResearchTopicViewController()
        self.navigationController?.pushViewController(SelectResearchTopicVC, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    // MARK: - addView
    func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitlelabel)
        
        view.addSubview(progressBar)
        view.addSubview(topicDot)
        view.addSubview(topicLabel)
        
        view.addSubview(collectionView)
        view.addSubview(underLine)
        view.addSubview(plusButton)
        
        view.addSubview(nextButton)
        view.addSubview(deletedAlert)
    }
    // MARK: - setLayout
    func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(82)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(20)
        }
        
        subtitlelabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        progressBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(containerView.snp.bottom).offset(8)
        }
        
        topicDot.snp.makeConstraints { make in
            make.top.equalTo(topicLabel.snp.top)
            make.leading.equalTo(topicLabel.snp.trailing).offset(4)
        }
        
        topicLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(progressBar.snp.bottom).offset(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topicLabel.snp.bottom).offset(15)
            make.leading.equalTo(underLine.snp.leading)
            make.width.equalTo(342)
            make.height.equalTo(40) // 임시 높이
        }
        underLine.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(342)
            make.height.equalTo(1)
        }
        
        plusButton.snp.makeConstraints { make in
            make.bottom.equalTo(underLine)
            make.trailing.equalTo(underLine)
            make.width.height.equalTo(44)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(80)
            make.trailing.leading.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        deletedAlert.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    
    // MARK: - CollectionView
    //let tagList = ["#HCI", "#인공지능", "#모빌리티", "#사용성평가", "#디자인"]
    var tagList = ["#HCI", "#인공지능", "#모빌리티", "#사용성평가", "#디자인"]
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 13
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
        
        $0.isScrollEnabled = false
        $0.collectionViewLayout = layout
        $0.backgroundColor = .clear
        $0.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
    }
    // 콜렉션뷰 높이 구하기
    func calculateCollectionViewHeight() -> CGFloat {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        return contentHeight + 10
    }
    // 구한 높이 + 10으로 콜렉션뷰 높이 바꿔주기
    func updateCollectionViewHeight() {
        let height = calculateCollectionViewHeight()
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
    
}

extension ResearchTopicViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell",
                                                      for: indexPath) as! TagCell
        cell.tagLabel.text = tagList[indexPath.item]
        cell.removeButton.tag = indexPath.item
        cell.removeButton.addTarget(self, action: #selector(removeButtonTapped(_:)), for:.touchUpInside)
        return cell
    }
    
    @objc func removeButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        tagList.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        updateCollectionViewHeight()
        showImageView()
    }
    
    private func showImageView() {
        UIView.animate(withDuration: 0, animations: {
                   self.deletedAlert.alpha = 1 // 이미지뷰를 표시
               }) { _ in
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                       UIView.animate(withDuration: 0.5) {
                           self.deletedAlert.alpha = 0 // 이미지뷰를 서서히 숨김
                       }
                   }
               }
           
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel().then {
            $0.font = .systemFont(ofSize: 14)
            $0.text = tagList[indexPath.item]
            $0.sizeToFit()
        }
        let size = label.frame.size
        
        return CGSize(width: size.width + 52 , height: size.height + 12)
    }
}


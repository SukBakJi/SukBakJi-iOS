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
    private let topicsViewLabel = UILabel().then {
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
    private let topicsView = UIView().then {
        //$0.backgroundColor = .green
        $0.frame.size.width = UIScreen.main.bounds.size.width - 48
        $0.frame.size.height = 88
        $0.layer.addBorder([.bottom], color: .gray300, width: 1)
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
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTopicsViewHeight()
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
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitlelabel)
        
        view.addSubview(containerView)
        view.addSubview(progressBar)
        
        view.addSubview(collectionView)
        
        view.addSubview(topicLabel)
        view.addSubview(topicDot)
        view.addSubview(topicsView)
        topicsView.addSubview(collectionView)
        //view.addSubview(topicsViewLabel)
        view.addSubview(plusButton)
        view.addSubview(nextButton)
    }
    
    // MARK: - setLayout
    func updateTopicsViewHeight() {
        topicsView.snp.remakeConstraints { make in
            make.top.equalTo(topicLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(collectionView.contentSize.height)
        }
        print(collectionView.contentSize.height)
    }
    func setupLayout() {
        let leftPadding = 24
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(82)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalToSuperview().inset(20)
        }
        
        subtitlelabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        progressBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(containerView.snp.bottom).offset(8)
        }
        
        topicLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(leftPadding)
            make.top.equalTo(progressBar.snp.bottom).offset(40)
        }
        
        topicDot.snp.makeConstraints { make in
            make.top.equalTo(topicLabel.snp.top)
            make.leading.equalTo(topicLabel.snp.trailing).offset(4)
        }
        
        topicsView.snp.makeConstraints { make in
            make.top.equalTo(topicLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(leftPadding)
            //make.height.equalTo(0)
        }
        
        //        topicsViewLabel.snp.makeConstraints { make in
        //            make.centerY.equalTo(topicsView)
        //            make.leading.equalTo(topicsView.snp.leading).offset(16)
        //        }
        
        plusButton.snp.makeConstraints { make in
            make.bottom.equalTo(topicsView)
            make.trailing.equalTo(topicsView)
            make.width.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(80)
            make.trailing.leading.equalToSuperview().inset(leftPadding)
            make.height.equalTo(48)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(topicsView)
            
        }
    }
    
    
    // MARK: - CollectionView
    let tagList = ["#HCI", "#인공지능", "#모빌리티", "#사용성평가", "#디자인"]
    
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
        
        $0.isScrollEnabled = false
        $0.collectionViewLayout = layout
        $0.backgroundColor = .systemBackground
        $0.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
    }
}

extension ResearchTopicViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        cell.tagLabel.text = tagList[indexPath.item]
        return cell
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

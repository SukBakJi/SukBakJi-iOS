//
//  SelectResearchTopicViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 7/27/24.
//

import UIKit

class SelectResearchTopicViewController: UIViewController {
    
    // MARK: - ImageView
    private let messagesImageView = UIImageView().then {
        $0.image = UIImage(named: "Messages")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let searchIcon = UIImageView().then {
        $0.image = UIImage(named: "search")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Label
    private let titleLabel = UILabel().then {
        $0.text = "연구 주제를 입력해 주세요"
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 0
    }
    private let subtitlelabel = UILabel().then {
        $0.text = "최대 5개까지 선택할 수 있어요"
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.numberOfLines = 0
    }
    
    // MARK: - view
    private let containerView = UIView()
    
    // MARK: - SearchBar
    private let searchBar = UISearchBar().then {
        $0.placeholder = "연구 주제를 입력해 주세요"
        $0.backgroundColor = .clear
        $0.backgroundImage = UIImage(named: "SearchBar")
        $0.tintColor = .gray300
        $0.setImage(UIImage(named: "clear"), for: .clear, state: .normal)
    }
    
    private func setupSearchBar() {
        // UISearchBar의 searchField를 커스터마이즈
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 0.0))
            // Placeholder 스타일 설정
            textField.attributedPlaceholder = NSAttributedString(
                string: textField.placeholder ?? "",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor(named: "Gray-300") ?? .lightGray,
                    NSAttributedString.Key.font: UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
                ]
            )
            
            // 텍스트 색상, 폰트, 배경색 설정
            textField.textColor = .black
            textField.font = UIFont(name: "Pretendard-Medium", size: 14)
            textField.backgroundColor = .gray50
            
            
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpNavigationBar()
        setupViews()
        setupLayout()
        setupSearchBar()
    }
    
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "연구 주제"
        
        let rightButtonItem = UIBarButtonItem(title: "완료",
                                              style: .plain,
                                              target: self,
                                              action: #selector(completedTouched))
        rightButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc func completedTouched() {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - addView
    func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitlelabel)
        view.addSubview(messagesImageView)
        
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        view.addSubview(searchIcon)
        
        view.addSubview(tableView)
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
        
        messagesImageView.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(150)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview()
            make.top.equalTo(containerView.snp.bottom).offset(-5)
            make.height.equalTo(35)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.leading.equalTo(searchBar.snp.leading).offset(16)
            make.width.height.equalTo(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    // MARK: - TabelView
    var DummyTopics = ["HCI", "인공지능", "모빌리티", "사용성평가", "디자인"]
    
    let tableView = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.isScrollEnabled = false
    }
    
    // MARK: - CollectionView
    var DummyTags = ["#HCI", "#인공지능", "#모빌리티", "#사용성평가", "#디자인"]
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 13
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
        layout.scrollDirection = .horizontal
        
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
        $0.backgroundColor = .clear
        $0.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
    }
    
}

// MARK: - CollectionView extension
extension SelectResearchTopicViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DummyTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell",
                                                            for: indexPath) as? TagCell else { return UICollectionViewCell() }
        cell.tagLabel.text = DummyTags[indexPath.item]
        cell.removeButton.tag = indexPath.item
        cell.removeButton.addTarget(self, action: #selector(removeButtonTapped(_:)), for:.touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel().then {
            $0.font = .systemFont(ofSize: 14)
            $0.text = DummyTags[indexPath.item]
            $0.sizeToFit()
        }
        let size = label.frame.size
        
        return CGSize(width: size.width + 52 , height: size.height + 12)
    }
    
    @objc func removeButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        DummyTags.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
    }
    
}

// MARK: - TableView extension
extension SelectResearchTopicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DummyTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.topicLabel.text = DummyTopics[indexPath.item]
        cell.checkButton.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func checkButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
}

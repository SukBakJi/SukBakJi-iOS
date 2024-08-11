//
//  SelectResearchTopicViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 7/27/24.
//

import UIKit
import SnapKit

class SelectResearchTopicViewController: UIViewController {
    private var searchWorkItem: DispatchWorkItem?
    private var searchBarTopConstraint: Constraint?
    var completionHandler: (([String]) -> Void)?
    
    // MARK: - ImageView
    private let messagesImageView = UIImageView().then {
        $0.image = UIImage(named: "SBJ_Messages")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let searchIcon = UIImageView().then {
        $0.image = UIImage(named: "SBJ_search")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let maximumAlert = UIImageView().then {
        $0.image = UIImage(named: "SBJ_maximumAlert")
        $0.alpha = 0
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let noticeIcon = UIImageView().then {
        $0.image = UIImage(named: "SBJ_notice_Big")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
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
    private let noticeLabel = UILabel().then {
        //        let fullText = "키워드에 대한 검색 결과 없어요"
        //        let attributedString = NSMutableAttributedString(string: fullText)
        //
        //        let rangeText = (fullText as NSString).range(of: "키워드")
        //        attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: rangeText)
        //$0.attributedText = attributedString
        $0.textAlignment = .center
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.numberOfLines = 1
        $0.isHidden = true
    }
    // MARK: - view
    private let containerView = UIView()
    
    // MARK: - SearchBar
    private let searchBar = UISearchBar().then {
        $0.placeholder = "연구 주제를 입력해 주세요"
        $0.backgroundColor = .clear
        $0.backgroundImage = UIImage(named: "SBJ_SearchBar")
        $0.tintColor = .gray300
        $0.setImage(UIImage(named: "SBJ_clear"), for: .clear, state: .normal)
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
        
        setDelegate()
        setUpNavigationBar()
        setupViews()
        setupLayout()
        setupSearchBar()
    }
    
    // MARK: - Delegate
    private func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "연구 주제"
        
        let rightButtonItem = UIBarButtonItem(title: "완료",
                                              style: .plain,
                                              target: self,
                                              action: #selector(topicSaveButtonTapped))
        rightButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    // 완료버튼
    @objc func topicSaveButtonTapped() {
        completionHandler?(selectedTags)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - functional
    private func updateNotice(enabled: Bool, searchText: String) {
        if enabled {
            let fullText = "\(searchText)에 대한 검색 결과가 없어요"
            let attributedString = NSMutableAttributedString(string: fullText)
            
            let rangeText = (fullText as NSString).range(of: searchText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange700, range: rangeText)
            
            noticeLabel.attributedText = attributedString
            
            noticeIcon.isHidden = false
            noticeLabel.isHidden = false
        } else {
            noticeIcon.isHidden = true
            noticeLabel.isHidden = true
        }
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
        view.addSubview(maximumAlert)
        
        view.addSubview(noticeIcon)
        view.addSubview(noticeLabel)
    }
    
    // MARK: - setLayout
    private func updateSearchBarConstraint() {
        searchBarTopConstraint?.update(offset: collectionView.isHidden ? 0 : 41)
    }
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
            searchBarTopConstraint = make.top.equalTo(containerView.snp.bottom).constraint
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
        
        maximumAlert.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(59)
            make.centerX.equalToSuperview()
        }
        
        noticeIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(84)
            make.width.height.equalTo(32)
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noticeIcon.snp.bottom).offset(20)
        }
    }
    // MARK: - TabelView
    struct SearchResultItem {
        let title: String
        var isSelected: Bool
    }
    var searchResults: [SearchResultItem] = []
    
    
    let tableView = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.isScrollEnabled = true
    }
    
    // MARK: - CollectionView
    var selectedTags: [String] = []
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 13
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
        layout.scrollDirection = .horizontal
        
        $0.isHidden = true
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
        return selectedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell",
                                                            for: indexPath) as? TagCell else { return UICollectionViewCell() }
        cell.tagLabel.text = "#\(selectedTags[indexPath.item])"
        cell.removeButton.tag = indexPath.item
        cell.removeButton.addTarget(self, action: #selector(removeButtonTapped(_:)), for:.touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel().then {
            $0.font = UIFont(name: "Pretendard-Medium", size: 14)
            $0.text = "#\(selectedTags[indexPath.item])"
            $0.sizeToFit()
        }
        let size = label.frame.size
        
        return CGSize(width: size.width + 52 , height: size.height + 12)
    }
    
    @objc func removeButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let removedTag = selectedTags[index]
        
        // 배열에서 먼저 요소를 제거
        if index < selectedTags.count {
            selectedTags.remove(at: index)
        }
        // 테이블뷰의 해당 항목 체크 해제
        if let tableIndex = searchResults.firstIndex(where: { $0.title == removedTag }) {
            searchResults[tableIndex].isSelected = false
            if let cell = tableView.cellForRow(at: IndexPath(row: tableIndex, section: 0)) as? SearchTableViewCell {
                cell.checkButton.isSelected = false
            }
        }
        
        // 이후에 컬렉션뷰를 업데이트
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }, completion: { _ in
            // 인덱스가 꼬이지 않도록 새로고침
            self.collectionView.reloadData()
        })
        
        // 만약 선택된 태그가 모두 제거되었다면 컬렉션뷰를 숨기고 서치바 위치 업데이트
        if selectedTags.isEmpty {
            collectionView.isHidden = true
            updateSearchBarConstraint()
        }
    }
    
    
}

// MARK: - TableView extension
extension SelectResearchTopicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let item = searchResults[indexPath.item]
        cell.topicLabel.text = item.title
        cell.checkButton.isSelected = item.isSelected
        cell.checkButton.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func checkButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? SearchTableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        sender.isSelected.toggle()
        let selectedTopic = searchResults[indexPath.item].title
        
        if sender.isSelected {
            searchResults[indexPath.item].isSelected = true
            collectionView.isHidden = false
            if selectedTags.count < 5 {
                selectedTags.append(selectedTopic)
            } else {
                sender.isSelected = false
                showImageView()
            }
        } else {
            searchResults[indexPath.item].isSelected = false
            if let index = selectedTags.firstIndex(of: selectedTopic) {
                selectedTags.remove(at: index)
            }
        }
        if selectedTags.isEmpty{
            collectionView.isHidden = true
            updateSearchBarConstraint()
            collectionView.reloadData()
        }
        updateSearchBarConstraint()
        collectionView.reloadData()
    }
    
    private func showImageView() {
        UIView.animate(withDuration: 0, animations: {
            self.maximumAlert.alpha = 1 // 이미지뷰를 표시
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.5) {
                    self.maximumAlert.alpha = 0 // 이미지뷰를 서서히 숨김
                }
            }
        }
    }
}


// MARK: - searchBar extension
extension SelectResearchTopicViewController: UISearchBarDelegate {
    // 사용자가 텍스트 입력 시
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            loadResult(searchText)
        } else {
            self.searchResults = []
            self.tableView.reloadData()
        }
    }
    
    func loadResult(_ searchText: String) {
        searchWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let researchTopicDataManager = ResearchTopicDataManager()
            
            researchTopicDataManager.ResearchTopicDataManager(searchText) {
                [weak self] ResearchTopicModel in
                guard let self = self else { return }
                
                if let model = ResearchTopicModel, model.code == "COMMON200" {
                    // 검색 결과 없는 경우
                    if model.result?.researchTopics?.isEmpty == true {
                        print("검색결과없음")
                        updateNotice(enabled: true, searchText: searchText)
                    } else {
                        self.updateNotice(enabled: false, searchText: searchText)
                    }
                    
                    // 기존 선택 상태 유지
                    let selectedTitles = Set(self.selectedTags)
                    self.searchResults = model.result?.researchTopics?.map {
                        SearchResultItem(title: $0, isSelected: selectedTitles.contains($0))
                    } ?? []
                    
                    self.tableView.reloadData()
                } else {
                    print("검색 실패")
                }
            }
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: workItem)
    }
}

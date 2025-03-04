//
//  ResearchTopicViewController.swift
//  Sukbakji
//
//  Created by 오현민 on 7/27/24.
//

import UIKit

class ResearchTopicViewController: UIViewController {
    
    var userName: String?
    var degreeLevel: DegreeLevel?
    
    // MARK: - ErrorState
    private let ErrorIcon = UIImageView().then {
        $0.image = UIImage(named: "SBJ_ErrorCircle")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let ErrorLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .warning400
        $0.font = UIFont(name: "Pretendard-Regular", size: 10)
        $0.numberOfLines = 0
    }
    private let ErrorView = UIView().then {
        $0.isHidden = true
    }
    // MARK: - ImageView
    private let progressBar = UIImageView().then {
        $0.image = UIImage(named: "SBJ_ProgressBar_2")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let topicDot = UIImageView().then {
        $0.image = UIImage(named: "SBJ_dot-badge")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let deletedAlert = UIImageView().then {
        $0.image = UIImage(named: "SBJ_deletedAlert")
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
        $0.setImage(UIImage(named: "SBJ_plusButton"), for: .normal)
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
        
        setDelegate()
        setUpNavigationBar()
        setupViews()
        setupLayout()
        updateCollectionViewHeight()
    }
    // MARK: - Delegate
    private func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "회원가입"
    }
    
    // MARK: - Screen transition
    @objc private func nextButtonTapped() {
        if validateField() {
            let userDataManager = UserDataManager()
            
            let input = PostProfileRequestDTO(name: userName,
                                        degreeLevel: degreeLevel!,
                                        researchTopics: selectedTags)
            
            print("전송된 데이터: \(input)")
            userDataManager.PostProfileDataManager(input) {
                [weak self] ProfileModel in
                guard let self = self else { return }
                
                // 응답
                if let model = ProfileModel, model.code == "COMMON200" {
                    navigateToSuccessPage()
                    print("마이페이지 설정 성공 : \(input)")
                }
                else {
                    print("마이페이지 설정 실패")
                }
            }
        }
    }
    
    @objc private func plusButtonTapped() {
        let selectResearchTopicVC = SelectResearchTopicViewController()
        
        // 현재 선택된 주제를 뒷페이지로 전달
        selectResearchTopicVC.selectedTags = selectedTags
        
        selectResearchTopicVC.completionHandler = { [weak self] data in
            self?.selectedTags = data
            self?.collectionView.reloadData()
            self?.updateCollectionViewHeight()
            self?.validateField()
            print("받은 데이터 : \(data)")
        }
        
        self.navigationController?.pushViewController(selectResearchTopicVC, animated: true)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }

    
    private func navigateToSuccessPage() {
        let SuccessSignUpVC = successSignUpViewController()
        self.navigationController?.pushViewController(SuccessSignUpVC, animated: true)
    }
    
    // MARK: - Funtional
    private func updateNextButton(enabled: Bool) {
        if enabled {
            nextButton.backgroundColor = .orange700
            nextButton.setTitleColor(.white, for: .normal)
        } else {
            nextButton.backgroundColor = .gray200
            nextButton.setTitleColor(.gray500, for: .normal)
        }
    }
    
    private func noticeDelete() {
        UIView.animate(withDuration: 0, animations: {
            self.deletedAlert.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.5) {
                    self.deletedAlert.alpha = 0
                }
            }
        }
    }
    //MARK: - validate
    private func validateField() -> Bool {
        if !selectedTags.isEmpty {
            ErrorView.isHidden = true
            descLabel.isHidden = true
            updateNextButton(enabled: true)
            return true
        } else {
            ErrorLabel.text = "연구 주제는 필수 입력입니다"
            ErrorView.isHidden = false
            descLabel.isHidden = false
            updateNextButton(enabled: false)
            return false
        }
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
        view.addSubview(descLabel)
        view.addSubview(underLine)
        view.addSubview(plusButton)
        
        view.addSubview(ErrorView)
        ErrorView.addSubview(ErrorIcon)
        ErrorView.addSubview(ErrorLabel)
        
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
            make.top.equalTo(topicLabel.snp.bottom).offset(30)
            make.leading.equalTo(underLine.snp.leading)
            make.width.equalTo(300)
            make.height.equalTo(44)
        }
        underLine.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(342)
            make.height.equalTo(1)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(underLine.snp.leading).offset(16)
            make.bottom.equalTo(underLine.snp.top).offset(-13.5)
        }
        
        plusButton.snp.makeConstraints { make in
            make.bottom.equalTo(underLine)
            make.trailing.equalTo(underLine)
            make.width.height.equalTo(44)
        }
        
        ErrorView.snp.makeConstraints { make in
            make.top.equalTo(underLine.snp.bottom).offset(6)
            make.leading.equalTo(underLine.snp.leading).offset(4)
            make.height.equalTo(12)
        }
        
        ErrorIcon.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(12)
        }
        
        ErrorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(ErrorIcon.snp.trailing).offset(4)
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
    var selectedTags: [String] = []
    
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
        return contentHeight + 3
    }
    func updateCollectionViewHeight() {
        let height = calculateCollectionViewHeight()
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
    
}

extension ResearchTopicViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        // 이후에 컬렉션뷰를 업데이트
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }, completion: { _ in
            // 인덱스가 꼬이지 않도록 새로고침
            self.collectionView.reloadData()
        })
        
        validateField()
        updateCollectionViewHeight()
        noticeDelete()
    }
    
    
    
}


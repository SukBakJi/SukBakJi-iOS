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
        $0.setImage(UIImage(named: "search"), for: .search, state: .normal)
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
        
        setUpNavigationBar()
        setupViews()
        setupLayout()
        setupSearchBar()
    }
    
    // MARK: - navigationBar Title
    private func setUpNavigationBar(){
        self.title = "연구 주제"
        
        let rightButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
        rightButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    // MARK: - addView
    func setupViews() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitlelabel)
        
        view.addSubview(containerView)
        view.addSubview(messagesImageView)
        
        view.addSubview(searchBar)
        view.addSubview(searchIcon)
    }
    
    // MARK: - setLayout
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
        
        messagesImageView.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(150)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.leading.equalTo(searchBar.snp.leading).offset(16)
            make.width.height.equalTo(24)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(leftPadding)
            make.height.equalTo(48)
        }
    }
    
}

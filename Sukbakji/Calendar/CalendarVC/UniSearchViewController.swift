//
//  UniSearchViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 12/18/24.
//

import UIKit
import SnapKit
import Alamofire
import Then
import RxSwift
import RxCocoa

class UniSearchViewController: UIViewController, UITextFieldDelegate {
    
    let univSearchViewModel = UnivSearchViewModel()

    private let navigationbarView = NavigationBarView(title: "대학교 선택")
    
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray200
    }
    private let uniSelectLabel = UILabel().then {
        $0.text = "대학교를 선택해 주세요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let stepImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_Progress1")
    }
    private let selectImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_CalendarImage")
    }
    private let uniSearchTextField = UITextField().then {
        $0.backgroundColor = .gray50
         $0.placeholder = "대학교명을 입력해 주세요"
         $0.setPlaceholderColor(UIColor(hexCode: "9F9F9F"))
         $0.font = UIFont(name: "Pretendard-Medium", size: 14)
         $0.textColor = .black
    }
    private let searchImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_SearchImage")
    }
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Delete"), for: .normal)
    }
    private var univSearchTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(UnivSearchTableViewCell.self, forCellReuseIdentifier: UnivSearchTableViewCell.identifier)
    }
    private let searchWarningImageView = UIImageView().then {
        $0.image = UIImage(named: "Sukbakji_NoResults")
    }
    private let searchWarningLabel = UILabel().then {
        $0.text = "석박지대학교에 대한 검색 결과가 없어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = .black
    }
    private let nextButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8

        $0.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
        $0.setTitle("다음으로", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(UIColor(hexCode: "EFEFEF"), for: .normal)
    }
    
    private let selectedIndex = BehaviorRelay<IndexPath?>(value: nil)
    
    private var searchTimer: Timer?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationbarView.delegate = self
        self.view.addSubview(navigationbarView)
        navigationbarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
           make.height.equalTo(95)
        }
        
        self.view.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationbarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.view.addSubview(uniSelectLabel)
        uniSelectLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.view.addSubview(stepImageView)
        stepImageView.snp.makeConstraints { make in
            make.top.equalTo(uniSelectLabel.snp.bottom).offset(49)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        self.view.addSubview(selectImageView)
        selectImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(22)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(100)
            make.width.equalTo(93)
        }
        
        self.view.addSubview(uniSearchTextField)
        uniSearchTextField.snp.makeConstraints { make in
            make.top.equalTo(stepImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        uniSearchTextField.setLeftPadding(52)
        uniSearchTextField.errorfix()
        
        self.view.addSubview(searchImageView)
        searchImageView.snp.makeConstraints { make in
            make.centerY.equalTo(uniSearchTextField)
            make.leading.equalToSuperview().offset(40)
            make.height.width.equalTo(24)
        }
        
        self.view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(uniSearchTextField)
            make.trailing.equalToSuperview().inset(34)
            make.height.width.equalTo(24)
        }
        deleteButton.isHidden = true
        
        self.view.addSubview(univSearchTableView)
        univSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(uniSearchTextField.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        bindTableView()
        
        self.view.addSubview(searchWarningImageView)
        searchWarningImageView.snp.makeConstraints { make in
            make.top.equalTo(uniSearchTextField.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(32)
        }
        
        self.view.addSubview(searchWarningLabel)
        searchWarningLabel.snp.makeConstraints { make in
            make.top.equalTo(searchWarningImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(21)
        }
        let fullText = searchWarningLabel.text ?? ""
        let changeText = "석박지대학교"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: changeText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "Coquelicot")!, range: nsRange)
        }
        searchWarningLabel.attributedText = attributedString
        
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
    }
    
    private func bindTableView() {
        univSearchViewModel.univSearchItems
            .bind(to: univSearchTableView.rx.items(cellIdentifier: UnivSearchTableViewCell.identifier, cellType: UnivSearchTableViewCell.self)) { [weak self] row, title, cell in
                            guard let self = self else { return }

                let isSelected = self.selectedIndex.value == IndexPath(row: row, section: 0)

                cell.bind(isSelected: isSelected) {
                    if self.selectedIndex.value == IndexPath(row: row, section: 0) {
                        // 이미 선택된 버튼 클릭 시 선택 해제
                        self.selectedIndex.accept(nil)
                        self.nextButton.isEnabled = false
                        self.nextButton.backgroundColor = UIColor(hexCode: "EFEFEF")
                        self.nextButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
                        self.nextButton.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .selected)
                        self.uniSearchTextField.text = ""
                    } else {
                        // 새로 선택된 버튼 설정
                        self.selectedIndex.accept(IndexPath(row: row, section: 0))
                        self.nextButton.isEnabled = true
                        self.nextButton.backgroundColor = UIColor(named: "Coquelicot")
                        self.nextButton.setTitleColor(.white, for: .normal)
                        self.nextButton.setTitleColor(.white, for: .selected)
                        self.uniSearchTextField.text = title.name
                    }
                }
            }
            .disposed(by: disposeBag)

        // 선택 상태가 변경되었을 때 테이블 뷰 리로드
        selectedIndex
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.univSearchTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setUnivSearchData() {
        univSearchTableView.delegate = nil
        univSearchTableView.dataSource = nil
        
        univSearchTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.univSearchViewModel.univSearchItems
            .observe(on: MainScheduler.instance)
            .bind(to: self.univSearchTableView.rx.items(cellIdentifier: UnivSearchTableViewCell.identifier, cellType: UnivSearchTableViewCell.self)) { index, item, cell in
                cell.prepare(uniSearchList: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUnivSearchAPI(keyword: String) {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendarSearch.path
        
        let params = [
            "keyword": keyword
        ] as [String : Any]
        
        APIService().getWithAccessTokenParameters(of: APIResponse<UniSearch>.self, url: url, parameters: params, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                let resultData = response.result.universityList
                self.univSearchViewModel.univSearchItems = Observable.just(resultData)
                self.setUnivSearchData()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchTimer?.invalidate() // 이전 타이머를 취소
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if updatedText.isEmpty {
            // 텍스트 필드가 비어 있으면 API 호출을 하지 않음
            return true
        }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] _ in
            self?.setUnivSearchAPI(keyword: self?.uniSearchTextField.text ?? "")
        })
        
        return true
    }
}

extension UniSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//
//  UnivSearchViewController.swift
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

class UnivSearchViewController: UIViewController, UITextFieldDelegate {
    
    let univSearchViewModel = UnivSearchViewModel()

    private let titleView = UIView()
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Back"), for: .normal)
    }
    private let titleLabel = UILabel().then {
        $0.text = "대학교 선택"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        $0.textColor = .black
    }
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
    
    private var univId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 탭 바 숨기기
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
           make.height.equalTo(95)
        }
        
        self.titleView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
            make.width.height.equalTo(48)
        }
        backButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
        
        self.titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        self.view.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.view.addSubview(uniSelectLabel)
        uniSelectLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        
        self.view.addSubview(stepImageView)
        stepImageView.snp.makeConstraints { make in
            make.top.equalTo(uniSelectLabel.snp.bottom).offset(39)
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
        selectImageView.alpha = 0.5
        
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
        searchWarningImageView.isHidden = true
        
        self.view.addSubview(searchWarningLabel)
        searchWarningLabel.snp.makeConstraints { make in
            make.top.equalTo(searchWarningImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(21)
        }
        searchWarningLabel.isHidden = true
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
        nextButton.addTarget(self, action: #selector(clickNextButton), for: .touchUpInside)
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
                        self.univId = title.id
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
                if resultData.isEmpty {
                    self.searchWarningImageView.isHidden = true
                    self.searchWarningLabel.isHidden = true
                } else {
                    self.searchWarningImageView.isHidden = false
                    self.searchWarningLabel.isHidden = false
                }
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
    
    @objc private func clickXButton() {
        let univStopView = UnivStopView(target: self, num: 2)
        
        self.view.addSubview(univStopView)
        univStopView.alpha = 0
        univStopView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            univStopView.alpha = 1
        }
    }
    
    @objc private func clickNextButton() {
        let univRecruitVC = UnivRecruitViewController(univName: uniSearchTextField.text ?? "", univId: univId ?? 0)
        self.navigationController?.pushViewController(univRecruitVC, animated: true)
    }
}

extension UnivSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

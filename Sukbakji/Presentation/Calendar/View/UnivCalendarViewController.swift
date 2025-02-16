//
//  UnivCalendarViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 1/2/25.
//

import UIKit
import SnapKit
import Alamofire
import Then
import RxSwift
import RxCocoa
import RxDataSources

class UnivCalendarViewController: UIViewController, UnivCalendarTableViewCellDeleteDelegate {
    
    private let memberId = UserDefaults.standard.integer(forKey: "memberID")
    
    private let univCalendarViewModel = UnivCalendarViewModel()
    
    private let navigationbarView = NavigationBarView(title: "대학별 일정")
    private let selectView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let allSelectButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Check"), for: .normal)
    }
    private let allSelectLabel = UILabel().then {
        $0.text = "전체선택 (0/5)"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .gray900
    }
    private let selectDeleteButton = UIButton().then {
        $0.setTitle("선택삭제", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.gray500, for: .normal)
    }
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    private var univCalendarTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(UnivCalendarTableViewCell.self, forCellReuseIdentifier: UnivCalendarTableViewCell.identifier)
    }
    private let selectComplateButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        
        $0.setTitleColor(.gray500, for: .normal)
        $0.setTitleColor(.gray500, for: .disabled)
        $0.setTitle("선택완료", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(.gray200, for: .normal)
        $0.setBackgroundColor(.gray200, for: .disabled)
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 탭 바 숨기기
        self.tabBarController?.tabBar.isHidden = true
    }
}
    
extension UnivCalendarViewController {

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
        
        self.view.addSubview(selectView)
        selectView.snp.makeConstraints { make in
            make.top.equalTo(navigationbarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.selectView.addSubview(allSelectButton)
        allSelectButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.height.width.equalTo(32)
        }
        
        self.selectView.addSubview(allSelectLabel)
        allSelectLabel.snp.makeConstraints { make in
            make.centerY.equalTo(allSelectButton)
            make.leading.equalTo(allSelectButton.snp.trailing).offset(2)
            make.height.equalTo(17)
        }
        
        self.selectView.addSubview(selectDeleteButton)
        selectDeleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(allSelectButton)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        
        self.selectView.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.view.addSubview(univCalendarTableView)
        univCalendarTableView.snp.makeConstraints { make in
            make.top.equalTo(selectView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.view.addSubview(selectComplateButton)
        selectComplateButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
    }
    
    private func setUnivCalendarData() {
        univCalendarTableView.delegate = nil
        univCalendarTableView.dataSource = nil
        
        univCalendarTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.univCalendarViewModel.univCalendarItems
            .observe(on: MainScheduler.instance)
            .bind(to: self.univCalendarTableView.rx.items(cellIdentifier: UnivCalendarTableViewCell.identifier, cellType: UnivCalendarTableViewCell.self)) { index, item, cell in
                cell.prepare(univListResult: item)
            }
            .disposed(by: disposeBag)
        
        self.univCalendarTableView.rx.modelSelected(UnivListResult.self)
            .subscribe(onNext: { [weak self] univCalendarItem in
                guard let self = self else { return }
                self.univCalendarViewModel.selectUnivCalendarItem = univCalendarItem
                let viewController = EditUnivCalendarViewController(univCalendarViewModel: self.univCalendarViewModel)
                let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 430, bottomSheetPanMinTopConstant: 150, isPannedable: true)
                self.present(bottomSheetVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setUnivListAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendarUniv.path
        
        APIService().getWithAccessToken(of: APIResponse<UnivList>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                let resultData = response.result.univList
                self.univCalendarViewModel.univCalendarItems.accept(resultData)
                self.setUnivCalendarData()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    func univDelete_Tapped(cell: UnivCalendarTableViewCell) {
        guard let indexPath = univCalendarTableView.indexPath(for: cell) else { return }
        let univCalendarItem = univCalendarViewModel.univCalendarItems.value[indexPath.row]
        let univId = univCalendarItem.univId
        let season = univCalendarItem.season
        let method = univCalendarItem.method
        
        let deleteView = DeleteView(title: "대학 일정 삭제하기", content: "선택한 대학 일정을 삭제할까요? 삭제 후 복구되지 않\n습니다.", myAlarmViewModel: MyAlarmViewModel(), univDelete: UnivDelete(memberId: memberId, univId: univId, season: season, method: method))
        
        self.view.addSubview(deleteView)
        deleteView.alpha = 0
        deleteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            deleteView.alpha = 1
        }
    }
}

extension UnivCalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
}

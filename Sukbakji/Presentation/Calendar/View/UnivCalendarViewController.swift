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

class UnivCalendarViewController: UIViewController, univCalendarDeleteDelegate {
    
    private let memberId = UserDefaults.standard.integer(forKey: "memberID")
    
    private let univCalendarViewModel = UnivCalendarViewModel()

    private let navigationbarView = NavigationBarView(title: "대학별 일정")
    private let allClickButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Check"), for: .normal)
    }
    private let allClickLabel = UILabel().then {
        $0.text = "전체선택 (0/5)"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = .black
    }
    private let clickDeleteButton = UIButton().then {
        $0.setTitle("선택삭제", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.setTitleColor(.gray400, for: .normal)
    }
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray200
    }
    private var univCalendarTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(UnivCalendarTableViewCell.self, forCellReuseIdentifier: UnivCalendarTableViewCell.identifier)
    }
    private let selectComplateButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8

        $0.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .normal)
        $0.setTitleColor(UIColor(hexCode: "9F9F9F"), for: .disabled)
        $0.setTitle("선택완료", for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.setBackgroundColor(UIColor(hexCode: "EFEFEF"), for: .normal)
        $0.setBackgroundColor(UIColor(hexCode: "EFEFEF"), for: .disabled)
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
        
        self.view.addSubview(allClickButton)
        allClickButton.snp.makeConstraints { make in
            make.top.equalTo(navigationbarView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.height.width.equalTo(32)
        }
        
        self.view.addSubview(allClickLabel)
        allClickLabel.snp.makeConstraints { make in
            make.centerY.equalTo(allClickButton)
            make.leading.equalTo(allClickButton.snp.trailing).offset(2)
            make.height.equalTo(17)
        }
        
        self.view.addSubview(clickDeleteButton)
        clickDeleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(allClickButton)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        
        self.view.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(allClickButton.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.view.addSubview(univCalendarTableView)
        univCalendarTableView.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(12)
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
        
        let deleteView = DeleteView(title: "대학 일정 삭제하기", content: "선택한 대학 일정을 삭제할까요? 삭제 후 복구되지 않습니다.", myAlarmViewModel: MyAlarmViewModel(), univDelete: UnivDelete(memberId: memberId, univId: univId, season: season, method: method))
        
        self.view.addSubview(deleteView)
        deleteView.alpha = 0
        deleteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            deleteView.alpha = 1
        }
    }
    
    private func univDeleteAPI(univId: Int, season: String, method: String) {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendarUniv.path
        
        let params = [
            "memberId": memberId,
            "univId": univId,
            "season": season,
            "method": method
        ] as [String : Any]
        
        APIService().getWithAccessTokenParameters(of: APIResponse<UnivDeleteResult>.self, url: url, parameters: params, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
}

extension UnivCalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
}

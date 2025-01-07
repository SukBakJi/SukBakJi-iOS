//
//  MyAlarmViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 1/5/25.
//

import UIKit
import SnapKit
import Alamofire
import Then
import RxSwift
import RxCocoa
import RxDataSources

class MyAlarmViewController: UIViewController {
    
    private let myAlarmViewModel = MyAlarmViewModel()

    private let navigationbarView = NavigationBarView(title: "내 알람")
    private let addAlarmButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Add"), for: .normal)
    }
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray200
    }
    private let dateLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let dateSelectButton = UIButton().then {
        $0.setImage(UIImage(named: "More 2"), for: .normal)
    }
    private var myAlarmTableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(MyAlarmTableViewCell.self, forCellReuseIdentifier: MyAlarmTableViewCell.identifier)
        $0.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    }
    
    private let disposeBag = DisposeBag()
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var calendarDate = Date()
    
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
        
        self.view.addSubview(addAlarmButton)
        addAlarmButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(47)
            make.trailing.equalToSuperview().inset(8)
            make.height.width.equalTo(48)
        }
        addAlarmButton.addTarget(self, action: #selector(bottomSheet_Tapped), for: .touchUpInside)
        
        self.view.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationbarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        configureDate()
        
        self.view.addSubview(dateSelectButton)
        dateSelectButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(dateLabel.snp.trailing).offset(2)
            make.height.equalTo(32)
        }
        
        self.view.addSubview(myAlarmTableView)
        myAlarmTableView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureDate() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        let date = self.dateFormatter.string(from: self.calendarDate)
        self.dateLabel.text = date
    }
    
    private func setAlarmData() {
        myAlarmTableView.delegate = nil
        myAlarmTableView.dataSource = nil
        
        myAlarmTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<AlarmListSection>(
            configureCell: { _, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyAlarmTableViewCell.identifier, for: indexPath) as? MyAlarmTableViewCell else {
                    return UITableViewCell()
                }
                cell.prepare(alarmListResult: item)
                return cell
            }
        )
        
        self.myAlarmViewModel.myAlarmItems
                .map { [AlarmListSection(items: $0)] } // 각 아이템을 섹션으로 만듦
                .observe(on: MainScheduler.instance)
                .bind(to: self.myAlarmTableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        
        self.myAlarmTableView.rx.modelSelected(AlarmListResult.self)
            .subscribe(onNext: { [weak self] myAlarmItem in
                guard let self = self else { return }
                self.myAlarmViewModel.selectMyAlarmItem = myAlarmItem
                let viewController = EditMyAlarmViewController(myAlarmViewModel: self.myAlarmViewModel)
                let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 430, bottomSheetPanMinTopConstant: 15, isPannedable: true)
                self.present(bottomSheetVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setUnivListAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendarAlarm.path
        
        APIService().getWithAccessToken(of: APIResponse<AlarmList>.self, url: url, AccessToken: retrievedToken) { response in
            switch response.code {
            case "COMMON200":
                let resultData = response.result.alarmList
                self.myAlarmViewModel.myAlarmItems = Observable.just(resultData)
                self.setAlarmData()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.message).show()
            }
        }
    }
    
    @objc private func bottomSheet_Tapped() {
        let viewController = EditMyAlarmViewController(myAlarmViewModel: self.myAlarmViewModel)
        let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 430, bottomSheetPanMinTopConstant: 15, isPannedable: true)
        self.present(bottomSheetVC, animated: true)
    }
}

extension MyAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

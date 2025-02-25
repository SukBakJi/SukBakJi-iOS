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

class MyAlarmViewController: UIViewController, MyAlarmTableViewCellSwitchDelegate {
    
    private let alarmViewModel = AlarmViewModel()
    
    private let navigationbarView = NavigationBarView(title: "내 알람")
    private let addAlarmButton = UIButton().then {
        $0.setImage(UIImage(named: "Sukbakji_Add"), for: .normal)
    }
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray100
    }
    private let dateLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    private let dateSelectButton = UIButton().then {
        $0.setImage(UIImage(named: "More 2"), for: .normal)
    }
    private var myAlarmTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(MyAlarmTableViewCell.self, forCellReuseIdentifier: MyAlarmTableViewCell.identifier)
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
        
        setMyAlarmAPI()
    }
}
    
extension MyAlarmViewController {
    
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
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
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
    
    @objc private func bottomSheet_Tapped() {
        let viewController = EditMyAlarmViewController(alarmViewModel: self.alarmViewModel)
        let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 430, bottomSheetPanMinTopConstant: 15, isPannedable: true)
        self.present(bottomSheetVC, animated: true)
    }
    
    func alarmSwitchToggled(cell: MyAlarmTableViewCell, isOn: Bool) {
        guard let indexPath = myAlarmTableView.indexPath(for: cell) else { return }
        let alarmItem = alarmViewModel.myAlarmItems.value[indexPath.row]
        
        if isOn {
            alarmOn(alarmId: alarmItem.alarmId)
            alarmViewModel.alarmSwitchToggled(at: indexPath.row, isOn: 1)
        } else {
            alarmOff(alarmId: alarmItem.alarmId)
            alarmViewModel.alarmSwitchToggled(at: indexPath.row, isOn: 0)
        }
    }
    
    func editToggled(cell: MyAlarmTableViewCell) {
        guard let indexPath = myAlarmTableView.indexPath(for: cell) else { return }
        let alarmItem = alarmViewModel.myAlarmItems.value[indexPath.row]
        
        self.alarmViewModel.selectMyAlarmItem = alarmItem
        let viewController = EditMyAlarmViewController(alarmViewModel: self.alarmViewModel)
        let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 430, bottomSheetPanMinTopConstant: 15, isPannedable: true)
        self.present(bottomSheetVC, animated: true)
    }
}

extension MyAlarmViewController {
    
    private func setAlarmData() {
        myAlarmTableView.delegate = nil
        myAlarmTableView.dataSource = nil
        
        myAlarmTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.alarmViewModel.myAlarmItems
            .observe(on: MainScheduler.instance)
            .bind(to: self.myAlarmTableView.rx.items(cellIdentifier: MyAlarmTableViewCell.identifier, cellType: MyAlarmTableViewCell.self)) { index, item, cell in
                cell.prepare(alarmList: item)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
        
        self.myAlarmTableView.rx.modelSelected(AlarmList.self)
            .subscribe(onNext: { [weak self] myAlarmItem in
                guard let self = self else { return }
                self.alarmViewModel.selectMyAlarmItem = myAlarmItem
                let viewController = EditMyAlarmViewController(alarmViewModel: self.alarmViewModel)
                let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 430, bottomSheetPanMinTopConstant: 15, isPannedable: true)
                self.present(bottomSheetVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setMyAlarmAPI() {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        let url = APIConstants.calendarAlarm.path
        
        APIService.shared.getWithToken(of: APIResponse<Alarm>.self, url: url, accessToken: retrievedToken)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                let resultData = response.result.alarmList
                self.alarmViewModel.myAlarmItems.accept(resultData)
                self.setAlarmData()
                self.view.layoutIfNeeded()
            }, onFailure: { error in
                print("❌ 오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func alarmOn(alarmId: Int) {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        let url = APIConstants.calendarAlarmOn.path
        
        let params = [
            "alarmId": alarmId
        ] as [String : Any]
        
        APIService.shared.patchWithToken(of: APIResponse<AlarmPatch>.self, url: url, parameters: params, accessToken: retrievedToken)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.view.layoutIfNeeded()
            }, onFailure: { error in
                print("❌ 오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func alarmOff(alarmId: Int) {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        let url = APIConstants.calendarAlarmOff.path
        
        let params = [
            "alarmId": alarmId
        ] as [String : Any]
        
        APIService.shared.patchWithToken(of: APIResponse<AlarmPatch>.self, url: url, parameters: params, accessToken: retrievedToken)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                self.view.layoutIfNeeded()
            }, onFailure: { error in
                print("❌ 오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

extension MyAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}

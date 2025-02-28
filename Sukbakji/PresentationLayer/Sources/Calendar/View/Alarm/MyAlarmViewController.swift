//
//  MyAlarmViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 1/5/25.
//

import UIKit
import SnapKit
import Alamofire
import RxSwift
import RxCocoa

class MyAlarmViewController: UIViewController, MyAlarmTableViewCellSwitchDelegate {
    
    private let myAlarmView = MyAlarmView()
    private let viewModel = AlarmViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = myAlarmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        setMyAlarmAPI()
    }
}
    
extension MyAlarmViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        myAlarmView.navigationbarView.delegate = self
        myAlarmView.addAlarmButton.addTarget(self, action: #selector(bottomSheet_Tapped), for: .touchUpInside)
    }
    
    @objc private func bottomSheet_Tapped() {
        let viewController = EditMyAlarmViewController(alarmViewModel: self.viewModel)
        let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 430, bottomSheetPanMinTopConstant: 15, isPannedable: true)
        self.present(bottomSheetVC, animated: true)
    }
    
    func alarmSwitchToggled(cell: MyAlarmTableViewCell, isOn: Bool) {
        guard let indexPath = myAlarmView.myAlarmTableView.indexPath(for: cell) else { return }
        let alarmItem = viewModel.myAlarmItems.value[indexPath.row]
        
        if isOn {
            alarmOn(alarmId: alarmItem.alarmId)
            viewModel.alarmSwitchToggled(at: indexPath.row, isOn: 1)
        } else {
            alarmOff(alarmId: alarmItem.alarmId)
            viewModel.alarmSwitchToggled(at: indexPath.row, isOn: 0)
        }
    }
    
    func editToggled(cell: MyAlarmTableViewCell) {
        guard let indexPath = myAlarmView.myAlarmTableView.indexPath(for: cell) else { return }
        let alarmItem = viewModel.myAlarmItems.value[indexPath.row]
        
        self.viewModel.selectMyAlarmItem = alarmItem
        let viewController = EditMyAlarmViewController(alarmViewModel: self.viewModel)
        let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 430, bottomSheetPanMinTopConstant: 15, isPannedable: true)
        self.present(bottomSheetVC, animated: true)
    }
}

extension MyAlarmViewController {
    
    private func setAlarmData() {
        myAlarmView.myAlarmTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.viewModel.myAlarmItems
            .observe(on: MainScheduler.instance)
            .bind(to: myAlarmView.myAlarmTableView.rx.items(cellIdentifier: MyAlarmTableViewCell.identifier, cellType: MyAlarmTableViewCell.self)) { index, item, cell in
                cell.prepare(alarmList: item)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
        
        myAlarmView.myAlarmTableView.rx.modelSelected(AlarmList.self)
            .subscribe(onNext: { [weak self] myAlarmItem in
                guard let self = self else { return }
                self.viewModel.selectMyAlarmItem = myAlarmItem
                let viewController = EditMyAlarmViewController(alarmViewModel: self.viewModel)
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
                self.viewModel.myAlarmItems.accept(resultData)
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

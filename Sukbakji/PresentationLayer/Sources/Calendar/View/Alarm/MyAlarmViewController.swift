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

class MyAlarmViewController: UIViewController, MyAlarmTableViewCellDelegate {
    
    private let myAlarmView = MyAlarmView()
    private let viewModel = AlarmViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = myAlarmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}
    
extension MyAlarmViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        myAlarmView.navigationbarView.delegate = self
        myAlarmView.addAlarmButton.addTarget(self, action: #selector(addAlarm_Tapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(alarmSettingComplete), name: .isAlarmComplete, object: nil)
    }
    
    private func setAPI() {
        bindViewModel()
        viewModel.fetchMyAlarms()
//        viewModel.loadTestData()
    }
    
    private func bindViewModel() {
        myAlarmView.myAlarmTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.alarmItems
            .observe(on: MainScheduler.instance)
            .bind(to: myAlarmView.myAlarmTableView.rx.items(cellIdentifier: MyAlarmTableViewCell.identifier, cellType: MyAlarmTableViewCell.self)) { index, item, cell in
                cell.prepare(alarmList: item)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
    }
    
    func editButton_Tapped(cell: MyAlarmTableViewCell) {
        guard let indexPath = myAlarmView.myAlarmTableView.indexPath(for: cell) else { return }
        self.viewModel.selectAlarmItem = viewModel.alarmItems.value[indexPath.row]
        let viewController = EditMyAlarmViewController(alarmViewModel: self.viewModel)
        let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 700, bottomSheetPanMinTopConstant: 15, isPannedable: true)
        self.present(bottomSheetVC, animated: true)
    }
    
    func alarmSwitch_Toggled(cell: MyAlarmTableViewCell, isOn: Bool) {
        guard let indexPath = myAlarmView.myAlarmTableView.indexPath(for: cell) else { return }
        self.viewModel.selectAlarmItem = viewModel.alarmItems.value[indexPath.row]
        viewModel.toggleAlarm(at: indexPath.row, isOn: isOn)
    }
    
    @objc private func addAlarm_Tapped() {
        let setAlarmVC = SetAlarmViewController()
        self.navigationController?.pushViewController(setAlarmVC, animated: true)
    }
    
    @objc private func alarmSettingComplete() {
        viewModel.fetchMyAlarms()
        UIView.animate(withDuration: 0.5, animations: {
            self.myAlarmView.alarmCompleteImageView.alpha = 1 // 나타나게
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.myAlarmView.alarmCompleteImageView.alpha = 0 // 투명하게
                }) { _ in
                    self.myAlarmView.alarmCompleteImageView.removeFromSuperview() // 뷰 제거
                }
            }
        }
    }
}

extension MyAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}

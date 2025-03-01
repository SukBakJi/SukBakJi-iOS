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

<<<<<<< HEAD:Sukbakji/Presentation/Calendar/View/MyAlarmViewController.swift
class MyAlarmViewController: UIViewController, myAlarmSwitchDelegate {

    private let myAlarmViewModel = MyAlarmViewModel()

=======
class MyAlarmViewController: UIViewController, MyAlarmTableViewCellSwitchDelegate {
    
<<<<<<< HEAD
    private let alarmViewModel = AlarmViewModel()
    
>>>>>>> 6fcfb270c8bf4b9973e1614c6c0270f98ac65669:Sukbakji/PresentationLayer/Sources/Calendar/View/Alarm/MyAlarmViewController.swift
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
    
=======
    private let myAlarmView = MyAlarmView()
    private let viewModel = AlarmViewModel()
>>>>>>> feat/calendar
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
//        myAlarmView.addAlarmButton.addTarget(self, action: #selector(addAlarm_Tapped), for: .touchUpInside)
    }
    
    private func setAPI() {
        bindViewModel()
        viewModel.fetchMyAlarms()
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
    
    func editButtonTapped(cell: MyAlarmTableViewCell) {
        guard let indexPath = myAlarmView.myAlarmTableView.indexPath(for: cell) else { return }
        self.viewModel.selectAlarmItem = viewModel.alarmItems.value[indexPath.row]
        let viewController = EditMyAlarmViewController(alarmViewModel: self.viewModel)
        let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 430, bottomSheetPanMinTopConstant: 15, isPannedable: true)
        self.present(bottomSheetVC, animated: true)
    }
    
    func alarmSwitchToggled(cell: MyAlarmTableViewCell, isOn: Bool) {
        guard let indexPath = myAlarmView.myAlarmTableView.indexPath(for: cell) else { return }
        viewModel.toggleAlarm(at: indexPath.row, isOn: isOn)
    }
    
//    @objc private func addAlarm_Tapped() {
//        let setAlarmVC = SetAlarmViewController()
//        self.navigationController?.pushViewController(setAlarmVC, animated: true)
//    }
}

extension MyAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}

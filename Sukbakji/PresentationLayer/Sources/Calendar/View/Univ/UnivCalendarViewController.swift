//
//  UnivCalendarViewController.swift
//  Sukbakji
//
//  Created by jaegu park on 1/2/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UnivCalendarViewController: UIViewController, UnivCalendarTableViewCellDeleteDelegate {
    
    private let memberId = UserDefaults.standard.integer(forKey: "memberID")
    private let univView = UnivView()
    private let viewModel = CalendarViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = univView
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

extension UnivCalendarViewController {
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        univView.navigationbarView.delegate = self
    }
    
    private func setAPI() {
        bindViewModel()
        viewModel.loadTestData()
//        viewModel.loadUnivList()
    }
    
    private func bindViewModel() {
        univView.univCalendarTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.viewModel.univList
            .observe(on: MainScheduler.instance)
            .bind(to: univView.univCalendarTableView.rx.items(cellIdentifier: UnivCalendarTableViewCell.identifier, cellType: UnivCalendarTableViewCell.self)) { index, item, cell in
                cell.prepare(univList: item)
                cell.delegate = self
                
                self.viewModel.selectedUnivAll
                    .bind { isSelected in
                        let imageName = isSelected ? "Sukbakji_Check2" : "Sukbakji_Check"
                        cell.selectButton.setImage(UIImage(named: imageName), for: .normal)
                        self.univView.allSelectButton.setImage(UIImage(named: imageName), for: .normal)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        univView.allSelectButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.toggleSelectState()
            }
            .disposed(by: disposeBag)
    }
    
    func univDelete_Tapped(cell: UnivCalendarTableViewCell) {
        guard let indexPath = univView.univCalendarTableView.indexPath(for: cell) else { return }
        let univCalendarItem = viewModel.univList.value[indexPath.row]
        let univId = univCalendarItem.univId
        let season = univCalendarItem.season
        let method = univCalendarItem.method
        
        let deleteView = DeleteView(title: "대학 일정 삭제하기", content: "선택한 대학 일정을 삭제할까요? 삭제 후 복구되지 않\n습니다.", alarmViewModel: AlarmViewModel(), univDelete: UnivDelete(memberId: memberId, univId: univId, season: season, method: method))
        
        self.view.addSubview(deleteView)
        deleteView.alpha = 0
        deleteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            deleteView.alpha = 1
        }
    }
    
    func editButton_Tapped(cell: UnivCalendarTableViewCell) {
        guard let indexPath = univView.univCalendarTableView.indexPath(for: cell) else { return }
        self.viewModel.selectUnivList = viewModel.univList.value[indexPath.row]
        let viewController = EditUnivCalendarViewController(calendarViewModel: self.viewModel)
        let bottomSheetVC = BottomSheetViewController(contentViewController: viewController, defaultHeight: 430, bottomSheetPanMinTopConstant: 380, isPannedable: true)
        self.present(bottomSheetVC, animated: true)
    }
}

extension UnivCalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
}

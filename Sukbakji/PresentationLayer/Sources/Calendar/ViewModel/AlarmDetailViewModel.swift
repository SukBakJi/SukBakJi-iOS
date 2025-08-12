//
//  AlarmDetailViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/12/25.
//

import RxSwift
import RxCocoa

protocol myAlarmSwitchDelegate: AnyObject {
    func alarmSwitchToggled(cell: MyAlarmTableViewCell, isOn: Bool)
    func editToggled(cell: MyAlarmTableViewCell)
}

final class AlarmDetailViewModel {
    private let useCase: CalendarUseCase
    private let disposeBag = DisposeBag()
    
    let alarmCreated = PublishSubject<Bool>()
    let alarmEdited = PublishSubject<Bool>()
    let alarmDeleted = PublishSubject<Bool>()
    
    init(useCase: CalendarUseCase = CalendarUseCase()) {
        self.useCase = useCase
    }
    
    func createAlarm(memberId: Int, univName: String, name: String, date: String, time: String) {
        useCase.createAlarm(memberId: memberId, univName: univName, name: name, date: date, time: time)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.alarmCreated.onNext(isSuccess)
                NotificationCenter.default.post(name: .isAlarmComplete, object: nil)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func editAlarm(memberId: Int, alarmId: Int, univName: String, name: String, date: String, time: String, onoff: Int) {
        useCase.editAlarm(alarmId: alarmId, memberId: memberId, univName: univName, name: name, date: date, time: time, onoff: onoff)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.alarmEdited.onNext(isSuccess)
                NotificationCenter.default.post(name: .isAlarmEditComplete, object: nil)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteAlarm(alarmId: Int) {
        useCase.deleteAlarm(alarmId: alarmId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.alarmDeleted.onNext(isSuccess)
                NotificationCenter.default.post(name: .isAlarmDeleteComplete, object: nil)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

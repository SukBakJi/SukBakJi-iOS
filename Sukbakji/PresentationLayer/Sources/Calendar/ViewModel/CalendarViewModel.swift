//
//  CalendarViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 2/21/25.
//

import RxSwift
import RxCocoa

class CalendarViewModel {
    private let calendarView = CalendarView()
    private let useCase: CalendarUseCase
    private let disposeBag = DisposeBag()
    
    let upComingSchedules = BehaviorRelay<[UpComingList]>(value: [])
    let dateSelectSchedules = BehaviorRelay<[DateSelectList]>(value: [])
    
    init(useCase: CalendarUseCase = CalendarUseCase()) {
        self.useCase = useCase
    }
    
    func loadUpComing() {
        useCase.fetchUpComing()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] schedules in
                self?.upComingSchedules.accept(schedules)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadDateSelect(date: String) {
        useCase.fetchDateSelect(date: date)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] schedules in
                self?.dateSelectSchedules.accept(schedules)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

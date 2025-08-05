//
//  CalendarUseCase.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/25.
//

import Foundation

class CalendarUseCase {
    private let calendarRepository: CalendarRepository
    
    init(calendarRepository: CalendarRepository = CalendarRepository.shared) {
        self.calendarRepository = calendarRepository
    }
}

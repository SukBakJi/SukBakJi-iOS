//
//  FCMUseCase.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/25.
//

import RxSwift

class FCMUseCase {
    private let fCMRepository: FCMRepository
    
    init(fCMRepository: FCMRepository = FCMRepository.shared) {
        self.fCMRepository = fCMRepository
    }
}

//
//  ResearchTopicViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ResearchTopicViewModel {
    var selectResearchTopicItem: String?
    var ResearchTopicItems = BehaviorRelay<[String]>(value: [])
}

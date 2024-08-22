//
//  DirectoryLabSearchModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryLabSearchModel (Request)
struct DirectoryLabSearchModel: Encodable {
    let topicName: String
}

// MARK: - DirectoryLabSearchGetModel
struct DirectoryLabSearchGetModel: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: [LabResult]
}

// MARK: - LabResult
struct LabResult: Decodable {
    let labId: Int
    let labName: String
    let universityName: String
    let departmentName: String
    let professorName: String
    let researchTopics: [String]
}

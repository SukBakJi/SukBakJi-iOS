//
//  ReportUseCase.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/25.
//

import RxSwift

class ReportUseCase {
    private let reportRepository: ReportRepository
    
    init(reportRepository: ReportRepository = ReportRepository.shared) {
        self.reportRepository = reportRepository
    }
    
    func reportPost(postId: Int, reason: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "postId": postId,
            "reason": reason
        ]
        
        return reportRepository.fetchReportPost(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func reportComment(commentId: Int, reason: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "commentId": commentId,
            "reason": reason
        ]
        
        return reportRepository.fetchReportComment(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func blockMember(targetMemberId: Int) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        return reportRepository.fetchBlockMember(token: token, targetMemberId: targetMemberId)
            .map { _ in true }
            .catchAndReturn(false)
    }
}

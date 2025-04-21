//
//  ReportViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 4/8/25.
//

import RxSwift
import RxCocoa

class ReportViewModel {
    let disposeBag = DisposeBag()
    
    let reportResult = PublishSubject<Bool>()
    let blockResult = PublishSubject<Bool>()
    
    func loadReportPost(postId: Int, reason: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        let params = [
            "postId": postId,
            "reason": reason
        ] as [String : Any]
        
        ReportRepository.shared.fetchReportPost(token: token, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] _ in
                self?.reportResult.onNext(true)
            }, onFailure: { [weak self] error in
                self?.reportResult.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func loadReportComment(commentId: Int, reason: String) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        let params = [
            "commentId": commentId,
            "reason": reason
        ] as [String : Any]
        
        ReportRepository.shared.fetchReportComment(token: token, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] _ in
                self?.reportResult.onNext(true)
            }, onFailure: { [weak self] error in
                self?.reportResult.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func loadBlockMemberId(targetMemberId: Int) {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        ReportRepository.shared.fetchBlockMember(token: token, targetMemberId: targetMemberId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] _ in
                self?.blockResult.onNext(true)
            }, onFailure: { [weak self] error in
                self?.blockResult.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}

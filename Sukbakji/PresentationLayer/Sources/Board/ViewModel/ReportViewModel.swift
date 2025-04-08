//
//  ReportViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 4/8/25.
//

import RxSwift
import RxCocoa

class ReportViewModel {
    private let disposeBag = DisposeBag()
    
    let reportResult = PublishSubject<Bool>()
    
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
            .subscribe(onSuccess: { response in
                self.reportResult.onNext(true)
            }, onFailure: { error in
                self.reportResult.onNext(false)
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
            .subscribe(onSuccess: { response in
                self.reportResult.onNext(true)
            }, onFailure: { error in
                self.reportResult.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}

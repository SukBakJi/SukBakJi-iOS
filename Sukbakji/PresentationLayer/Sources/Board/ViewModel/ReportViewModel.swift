//
//  ReportViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 4/8/25.
//

import RxSwift
import RxCocoa

final class ReportViewModel {
    private let useCase: ReportUseCase
    private let disposeBag = DisposeBag()
    
    let reportResult = PublishSubject<Bool>()
    let blockResult = PublishSubject<Bool>()
    
    init(useCase: ReportUseCase = ReportUseCase()) {
        self.useCase = useCase
    }
    
    func reportPost(postId: Int, reason: String) {
        useCase.reportPost(postId: postId, reason: reason)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.reportResult.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func reportComment(commentId: Int, reason: String) {
        useCase.reportComment(commentId: commentId, reason: reason)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.reportResult.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func blockMember(targetMemberId: Int) {
        useCase.blockMember(targetMemberId: targetMemberId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isSuccess in
                self?.reportResult.onNext(isSuccess)
            }, onFailure: { error in
                print("오류:", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

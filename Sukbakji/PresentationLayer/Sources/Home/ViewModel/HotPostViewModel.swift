//
//  HotPostViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import RxSwift
import RxCocoa

class HotPostViewModel {
    
    private let disposeBag = DisposeBag()
    
    let hotPostList = BehaviorRelay<[HotPost]>(value: [])
    let errorMessage = PublishSubject<String>()
    
    func loadHotPost() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return
        }
        
        HomeRepository.shared.fetchHotPost(token: token)
            .observe(on: MainScheduler.instance) // ✅ UI 업데이트를 위해 Main 스레드에서 실행
            .subscribe(onSuccess: { response in
                self.hotPostList.accept(response.result)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadTestData() {
        let testHotPostList: [HotPost] = [
            HotPost(postId: 0, menu: "1", boardName: "취업 정보", title: "궁금한 점이 있습니다. 답변 부탁드려요", content: "가고 싶은 연구실이 있는데 어떻게 컨택을 하면 좋을까요? 처음이라 어떻게 하면 좋을지 조언 부탁드립니다.", commentCount: 125, views: 1285),
            HotPost(postId: 0, menu: "1", boardName: "취업 정보", title: "궁금한 점이 있습니다. 답변 부탁드려요", content: "가고 싶은 연구실이 있는데 어떻게 컨택을 하면 좋을까요? 처음이라 어떻게 하면 좋을지 조언 부탁드립니다.", commentCount: 125, views: 1285)
        ]
        hotPostList.accept(testHotPostList)
    }
}

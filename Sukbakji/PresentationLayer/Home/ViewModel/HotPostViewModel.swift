//
//  HotPostViewModel.swift
//  Sukbakji
//
//  Created by jaegu park on 12/2/24.
//

import RxSwift
import RxCocoa

final class HotPostViewModel {
    
    private let disposeBag = DisposeBag()
    
    let hotPostList = PublishSubject<[HotPost]>()
    let errorMessage = PublishSubject<String>()
    
    func loadHotPost(token: String) {
        let url = APIConstants.communityHotPost.path
        
        HomeRepository.shared.fetchHotPost(token: token, url: url)
            .observe(on: MainScheduler.instance) // ✅ UI 업데이트를 위해 Main 스레드에서 실행
            .subscribe(onSuccess: { response in
                self.hotPostList.onNext(response.result)
            }, onFailure: { error in
                self.errorMessage.onNext("네트워크 오류 발생: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadTestData() {
        let testHotPostList: [HotPost] = [
            HotPost(postId: 0, menu: "1", boardName: "1", title: "1", content: "1", commentCount: 10, views: 10),
            HotPost(postId: 0, menu: "1", boardName: "1", title: "1", content: "1", commentCount: 10, views: 10)
        ]
        hotPostList.onNext(testHotPostList)
    }
}

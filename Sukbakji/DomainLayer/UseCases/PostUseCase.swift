//
//  PostUseCase.swift
//  Sukbakji
//
//  Created by jaegu park on 5/25/25.
//

import RxSwift

class PostUseCase {
    private let boardRepository: BoardRepository
    
    init(boardRepository: BoardRepository = BoardRepository.shared) {
        self.boardRepository = boardRepository
    }
    
    func fetchPostDetail(postId: Int) -> Single<PostDetail> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return boardRepository.fetchPostDetail(token: token, postId: postId)
                    .map { $0.result }
    }
}

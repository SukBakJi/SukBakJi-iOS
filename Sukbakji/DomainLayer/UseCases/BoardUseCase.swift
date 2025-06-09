//
//  BoardUseCase.swift
//  Sukbakji
//
//  Created by jaegu park on 6/3/25.
//

import RxSwift

class BoardUseCase {
    private let boardRepository: BoardRepository
    
    init(boardRepository: BoardRepository = BoardRepository.shared) {
        self.boardRepository = boardRepository
    }
    
    func fetchBoardsFavorite() -> Single<[Favorite]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return boardRepository.fetchBoardsFavorite(token: token)
                    .map { $0.result }
    }
    
    func fetchBoardSearch(keyword: String, menu: String, boardName: String) -> Single<[MyPost]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return boardRepository.fetchBoardSearch(token: token, keyword: keyword, menu: menu, boardName: boardName)
            .map { $0.result }
    }
}

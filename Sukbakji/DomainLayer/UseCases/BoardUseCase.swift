//
//  BoardUseCase.swift
//  Sukbakji
//
//  Created by jaegu park on 5/25/25.
//

import RxSwift

class BoardUseCase {
    private let boardRepository: BoardRepository
    
    init(boardRepository: BoardRepository = BoardRepository.shared) {
        self.boardRepository = boardRepository
    }
    
    // 최근 질문리스트
    func fetchLatestQnA() -> Single<[QnA]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return boardRepository.fetchLatestQnA(token: token)
            .map { $0.result }
    }
    
    // 게시판
    func createBoard(boardName: String, description: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "boardName": boardName,
            "description": description
        ]
        
        return boardRepository.fetchCreateBoard(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func fetchBoardMenu(menu: String) -> Single<[String]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return boardRepository.fetchBoardsMenu(token: token, menu: menu)
            .map { $0 }
    }
    
    func fetchSearchBoard(keyword: String, menu: String, boardName: String) -> Single<[MyPost]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return boardRepository.fetchSearchBoard(token: token, keyword: keyword, menu: menu, boardName: boardName)
            .map { $0.result }
    }
    
    
    // 게시물
    func fetchPostList(menu: String, boardName: String) -> Single<[Post]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return boardRepository.fetchPostList(token: token, menu: menu, boardName: boardName)
                    .map { $0.result }
    }
    
    func fetchPostDetail(postId: Int) -> Single<PostDetail> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return boardRepository.fetchPostDetail(token: token, postId: postId)
                    .map { $0.result }
    }
    
    func createPost(menu: String, boardName: String, title: String, content: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "menu": menu,
            "boardName": boardName,
            "title": title,
            "content": content
        ]
        
        return boardRepository.fetchCreatePost(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func deletePost(postId: Int) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "postId": postId
        ]
        
        return boardRepository.fetchDeletePost(token: token, postId: postId, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func createComment(postId: Int, content: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "postId": postId,
            "content": content
        ]
        
        return boardRepository.fetchCreateComment(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func editComment(commentId: Int, content: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "commentId": commentId,
            "content": content
        ]
        
        return boardRepository.fetchEditComment(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    
    func fetchMyPostList() -> Single<[MyPost]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return boardRepository.fetchMyPostList(token: token)
                    .map { $0.result }
    }
    
    func fetchMyCommentList() -> Single<[MyPost]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return boardRepository.fetchMyCommentList(token: token)
                    .map { $0.result }
    }
    
    
    // 즐겨찾기
    func fetchFavoriteBoard() -> Single<[Favorite]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return boardRepository.fetchFavoriteBoard(token: token)
                    .map { $0.result }
    }
    
    func favoriteBoard(boardId: Int, isFav: Bool) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        return boardRepository.favoriteBoardToggle(token: token, boardId: boardId, isFav: isFav)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    
    // 스크랩
    func fetchScrap() -> Single<[MyPost]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return boardRepository.fetchScrapList(token: token)
            .map { $0.result }
    }
    
    func createScrap(postId: Int) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        return boardRepository.fetchScrapToggle(token: token, postId: postId)
            .map { _ in true }
            .catchAndReturn(false)
    }
}

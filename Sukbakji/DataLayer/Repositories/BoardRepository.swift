//
//  BoardRepository.swift
//  Sukbakji
//
//  Created by jaegu park on 5/15/25.
//

import Foundation
import RxSwift

class BoardRepository {
    static let shared = BoardRepository()
    
    func fetchLatestQnA(token: String) -> Single<APIResponse<[QnA]>> {
        let url = APIConstants.communityLastestQuestions.path
        return APIService.shared.getWithToken(of: APIResponse<[QnA]>.self, url: url, accessToken: token)
    }
    
    func fetchBoardsMenu(token: String, menu: String) -> Single<[String]> {
        let url = APIConstants.boardsMenu(menu).path
        return APIService.shared.getWithToken(of: [String].self, url: url, accessToken: token)
    }
    
    func fetchPostList(token: String, menu: String, boardName: String) -> Single<APIResponse<[Post]>> {
        let url = APIConstants.postsList.path
        let params = ["menu": menu,
                      "boardName": boardName]
        return APIService.shared.getWithTokenAndParams(of: APIResponse<[Post]>.self, url: url, parameters: params, accessToken: token)
    }
    
    func fetchPostDetail(token: String, postId: Int) -> Single<APIResponse<PostDetail>> {
        let url = APIConstants.postsId(postId).path
        let params = ["postId": postId]
        return APIService.shared.getWithTokenAndParams(of: APIResponse<PostDetail>.self, url: url, parameters: params, accessToken: token)
    }
    
    func fetchMyPostList(token: String) -> Single<APIResponse<[MyPost]>> {
        let url = APIConstants.communityPostList.path
        return APIService.shared.getWithToken(of: APIResponse<[MyPost]>.self, url: url, accessToken: token)
    }
    
    func fetchScrapList(token: String) -> Single<APIResponse<[MyPost]>> {
        let url = APIConstants.communityScrapList.path
        return APIService.shared.getWithToken(of: APIResponse<[MyPost]>.self, url: url, accessToken: token)
    }
    
    func fetchMyCommentList(token: String) -> Single<APIResponse<[MyPost]>> {
        let url = APIConstants.communityCommentList.path
        return APIService.shared.getWithToken(of: APIResponse<[MyPost]>.self, url: url, accessToken: token)
    }
    
    func favoriteBoardAddRemove(token: String, boardId: Int, isFavorite: Bool) -> Single<APIResponse<String>> {
        let url = isFavorite ? APIConstants.boardFavoriteAdd(boardId).path : APIConstants.boardFavoriteAdd(boardId).path
        return APIService.shared.patchWithToken(of: APIResponse<String>.self, url: url, parameters: nil, accessToken: token)
    }
}

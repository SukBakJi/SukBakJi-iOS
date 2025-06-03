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
    
    func fetchBoardSearch(token: String, keyword: String, menu: String, boardName: String) -> Single<APIResponse<[MyPost]>> {
        let url = APIConstants.communitySearch.path
        let params = ["keyword": keyword,
                      "menu": menu,
                      "boardName": boardName]
        return APIService.shared.getWithTokenAndParams(of: APIResponse<[MyPost]>.self, url: url, parameters: params, accessToken: token)
    }
    
    func fetchBoardEnroll(token: String, parameters: [String: Any]?) -> Single<APIResponse<String>> {
        let url = APIConstants.boardCreate.path
        return APIService.shared.postWithToken(of: APIResponse<String>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func fetchPostEnroll(token: String, parameters: [String: Any]?) -> Single<APIResponse<Post>> {
        let url = APIConstants.postsCreate.path
        return APIService.shared.postWithToken(of: APIResponse<Post>.self, url: url, parameters: parameters, accessToken: token)
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
    
    func fetchCommentEnroll(token: String, parameters: [String: Any]?) -> Single<APIResponse<CommentPost>> {
        let url = APIConstants.commentsCreate.path
        return APIService.shared.postWithToken(of: APIResponse<CommentPost>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func favoriteBoardToggle(token: String, boardId: Int, isFav: Bool) -> Single<APIResponse<String>> {
        let url = isFav ? APIConstants.boardFavoriteAdd(boardId).path : APIConstants.boardFavoriteAdd(boardId).path
        let params = ["boardId": boardId]
        return APIService.shared.postWithToken(of: APIResponse<String>.self, url: url, parameters: params, accessToken: token)
    }
    
    func fetchScrapToggle(token: String, postId: Int) -> Single<APIResponse<String>> {
        let url = APIConstants.scrapsToggle(postId).path
        let params = ["postId": postId]
        return APIService.shared.postWithToken(of: APIResponse<String>.self, url: url, parameters: params, accessToken: token)
    }
}

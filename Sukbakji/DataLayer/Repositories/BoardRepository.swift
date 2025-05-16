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
    
    func fetchPostList(token: String, menu: String, boardName: String) -> Single<APIResponse<[PostList]>> {
        let url = APIConstants.postsList.path
        let params = ["menu": menu,
                      "boardName": boardName]
        return APIService.shared.getWithTokenAndParams(of: APIResponse<[PostList]>.self, url: url, parameters: params, accessToken: token)
    }
    
    func favoriteBoardAddRemove(token: String, boardId: Int, isFavorite: Bool) -> Single<APIResponse<String>> {
        let url = isFavorite ? APIConstants.boardFavoriteAdd(boardId).path : APIConstants.boardFavoriteAdd(boardId).path
        return APIService.shared.patchWithToken(of: APIResponse<String>.self, url: url, parameters: nil, accessToken: token)
    }
}

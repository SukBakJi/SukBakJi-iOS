//
//  HomeReactor.swift
//  Sukbakji
//
//  Created by jaegu park on 9/1/25.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

final class HomeReactor: Reactor {
    enum Action {
        case viewWillAppear
    }
    enum Mutation {
        case setLoading(Bool)
        case setFavBoards([FavoriteBoard])
        case setHotPosts([HotPost])
        case setFavLabs([FavoriteLab])
        case setError(String?)
    }
    struct State {
        var favBoards: [FavoriteBoard] = []
        var hotPosts: [HotPost] = []
        var favLabs: [FavoriteLab] = []
        var isLoading: Bool = false
        var errorMessage: String? = nil
        // 파생 상태(VC if/else 제거)
        var isFavBoardEmpty: Bool { favBoards.isEmpty }
        var isHotPostEmpty: Bool { hotPosts.isEmpty }
        var isFavLabEmpty: Bool { favLabs.isEmpty }
    }

    let initialState = State()
    private let homeUseCase: HomeUseCase
    private let dirUseCase: DirectoryUseCase

    init(homeUseCase: HomeUseCase, dirUseCase: DirectoryUseCase) {
        self.homeUseCase = homeUseCase
        self.dirUseCase = dirUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let start = Observable.just(Mutation.setLoading(true))
            let boards = homeUseCase.fetchFavoriteBoard().asObservable()
                .map(Mutation.setFavBoards)
                .catch { .just(.setError($0.localizedDescription)) }
            let posts = homeUseCase.fetchHotPost().asObservable()
                .map(Mutation.setHotPosts)
                .catch { .just(.setError($0.localizedDescription)) }
            let labs = dirUseCase.fetchLabFavorite().asObservable()
                .map(Mutation.setFavLabs)
                .catch { .just(.setError($0.localizedDescription)) }
            let end = Observable.just(Mutation.setLoading(false))
            return .concat([start, .merge(boards, posts, labs), end])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var s = state
        switch mutation {
        case let .setLoading(f): s.isLoading = f
        case let .setFavBoards(v): s.favBoards = v
        case let .setHotPosts(v):  s.hotPosts = v
        case let .setFavLabs(v):   s.favLabs = v
        case let .setError(msg):   s.errorMessage = msg
        }
        return s
    }
}

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}


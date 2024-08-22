//
//  ScrappedBoardViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/27/24.
//

import SwiftUI
import Alamofire

struct ScrappedBoardViewController: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var hasScrappedPosts: Bool = true
    @State private var scrappedPosts: [BoardBookmarkedResult] = []
    @State private var isLoading: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // Back Button
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("BackButton")
                            .frame(width: Constants.nav, height: Constants.nav)
                    }

                    Spacer()

                    Text("스크랩")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Constants.Gray900)

                    Spacer()

                    Image("")
                        .frame(width: Constants.nav, height: Constants.nav)
                }

                Divider()

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if hasScrappedPosts {
                    ScrollView {
                        ForEach(scrappedPosts, id: \.postID) { post in
                            ContainerDummyBoard(
                                boardName: post.boardName,
                                title: post.title,
                                content: post.content,
                                commentCount: post.commentCount,
                                views: post.views,
                                postId: post.postID
                            )
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        EmptyScrappedBoard()
                        Spacer()
                    }
                }
            }
            .onAppear {
                loadScrappedPosts()
            }
        }
        .navigationBarBackButtonHidden()
    }

    func loadScrappedPosts() {
        BookmarkedBoardApi() { result in
            switch result {
            case .success(let posts):
                self.scrappedPosts = posts.reversed() // Show the latest scrapped post at the top
                self.hasScrappedPosts = !posts.isEmpty
            case .failure(let error):
                print("Error loading scrapped posts: \(error.localizedDescription)")
                self.hasScrappedPosts = false
            }
            self.isLoading = false
        }
    }

    func BookmarkedBoardApi(completion: @escaping (Result<[BoardBookmarkedResult], Error>) -> Void) {
        let url = APIConstants.communityURL + "/scrap-list"

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]

        NetworkManager.shared.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoardBookmarkedModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        completion(.success(data.result))
                    } else {
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: data.message])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

struct EmptyScrappedBoard: View {
    var body: some View {
        VStack {
            Text("아직 스크랩한 게시물이 없어요")
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Constants.Gray500)
                .padding(.bottom, 8)
            
            Text("게시판을 탐색하고 석박지 커뮤니티에서 소통해 보세요!")
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.Gray500)
            
        }
    }
}

#Preview {
    ScrappedBoardViewController()
}

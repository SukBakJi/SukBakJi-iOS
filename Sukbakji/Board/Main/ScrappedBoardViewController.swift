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
    @State private var hasScrappedPosts: Bool = true // State variable to track if there are scrapped posts
    @State private var scrappedPosts: [BoardBookmarkedResult] = [] // 스크랩된 글 목록을 저장할 상태 변수
    @State private var isLoading: Bool = true // 로딩 상태를 추적하는 상태 변수
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // 뒤로가기 버튼
                    Button(action: {
                        // 뒤로가기 버튼 클릭 시 동작할 코드
                        self.presentationMode.wrappedValue.dismiss()
                        print("뒤로가기 버튼 tapped")
                    }) {
                        Image("BackButton")
                            .frame(width: Constants.nav, height: Constants.nav)
                    }
                    
                    Spacer()
                    
                    Text("스크랩")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.Gray900)
                    
                    Spacer()
                    
                    // 더보기 버튼
                    Image("")
                        .frame(width: Constants.nav, height: Constants.nav)
                    
                }
                
                Divider()
                
                if isLoading {
                    // 로딩 중일 때 표시할 뷰
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if hasScrappedPosts {
                    ScrollView {
                        // 게시판 글 목록
                        ForEach(scrappedPosts, id: \.postID) { post in
                            ContainerDummyBoard(boardName: post.boardName)
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
//        guard let accessTokenData = KeychainHelper.standard.read(service: "access-token", account: "user"),
//              let accessToken = String(data: accessTokenData, encoding: .utf8) else {
//            print("토큰이 없습니다.")
//            self.isLoading = false
//            self.hasScrappedPosts = false
//            return
//        }
//        
//        BookmarkedBoardApi(userToken: accessToken) { result in
//            switch result {
//            case .success(let posts):
//                self.scrappedPosts = posts
//                self.hasScrappedPosts = !posts.isEmpty
//            case .failure(let error):
//                print("Error loading scrapped posts: \(error.localizedDescription)")
//                self.hasScrappedPosts = false
//            }
//            self.isLoading = false
//        }
        guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self), !accessToken.isEmpty else {
            print("토큰이 없습니다.")
            self.isLoading = false
            return
        }
        
        BookmarkedBoardApi(userToken: accessToken) { result in
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
    
    func BookmarkedBoardApi(userToken: String, completion: @escaping (Result<[BoardBookmarkedResult], Error>) -> Void) {
        // API 엔드포인트 URL
        let url = APIConstants.communityURL + "/scrap-list"

        // 요청 헤더에 Authorization 추가
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(userToken)"
        ]
        
        AF.request(url,
                   method: .get,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: BoardBookmarkedModel.self) { response in
            switch response.result {
            case .success(let data):
                if data.isSuccess {
                    // 성공적으로 데이터를 받아왔을 때, 결과를 반환
                    completion(.success(data.result))
                } else {
                    // API 호출은 성공했으나, 서버에서 에러 코드를 반환한 경우
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: data.message])
                    completion(.failure(error))
                }
                
            case .failure(let error):
                // 네트워크 오류 또는 응답 디코딩 실패 등의 오류가 발생했을 때
                completion(.failure(error))
            }
        }
    }
    
    // Function to handle new scrapped post
    func handleNewScrappedPost(_ newPost: BoardBookmarkedResult?) {
        if let newPost = newPost {
            scrappedPosts.insert(newPost, at: 0) // Add the new post at the top of the list
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

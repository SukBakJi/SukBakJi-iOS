import SwiftUI
import Alamofire

struct CommentedBoardViewController: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var hasCommentedPosts: Bool = true
    @State private var commentedPosts: [CommentedPost] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // 뒤로가기 버튼
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("BackButton")
                            .frame(width: Constants.nav, height: Constants.nav)
                    }
                    
                    Spacer()
                    
                    Text("댓글 단 글")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.Gray900)
                    
                    Spacer()
                    
                    Image("") // 더보기 버튼, 현재 사용되지 않음
                        .frame(width: Constants.nav, height: Constants.nav)
                }
                
                Divider()
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if hasCommentedPosts && !commentedPosts.isEmpty {
                    ScrollView(showsIndicators: false) {
                        // 댓글 단 글 목록 표시
                        ForEach(commentedPosts, id: \.postId) { post in
                            NavigationLink(destination: DummyBoardDetail(boardName: post.boardName, postId: post.postId, memberId: nil)) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(post.title)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(Constants.Gray900)
                                    
                                    Text(post.content)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(Constants.Gray900)
                                    
                                    HStack(alignment: .top, spacing: 12) {
                                        Image("chat 1")
                                            .resizable()
                                            .frame(width: 12, height: 12)
                                        
                                        Text("\(post.commentCount)")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Color(red: 0.29, green: 0.45, blue: 1))
                                        
                                        Image("eye")
                                            .resizable()
                                            .frame(width: 12, height: 12)
                                        
                                        Text("\(post.views)")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                                }
                                .padding(.horizontal, 18)
                                .padding(.vertical, 16)
                                .background(Constants.White)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .inset(by: 0.5)
                                        .stroke(Constants.Gray100, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                } else {
                    VStack {
                        Spacer()
                        EmptyCommentedBoard()
                        Spacer()
                    }
                }
            }
            .onAppear {
                loadCommentedPosts()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    func loadCommentedPosts() {
//        guard let accessTokenData = KeychainHelper.standard.read(service: "access-token", account: "user"),
//              let accessToken = String(data: accessTokenData, encoding: .utf8) else {
//            print("토큰이 없습니다.")
//            self.isLoading = false // 로딩 상태 업데이트
//            self.hasCommentedPosts = false
//            return
//        }
//        
//        CommentedBoardApi(userToken: accessToken) { result in
//            switch result {
//            case .success(let posts):
//                self.commentedPosts = posts
//                self.hasCommentedPosts = !posts.isEmpty
//            case .failure(let error):
//                print("Error loading commented posts: \(error.localizedDescription)")
//                self.hasCommentedPosts = false
//            }
//            self.isLoading = false
//        }
        guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user"), !accessToken.isEmpty else {
            print("토큰이 없습니다.")
            self.isLoading = false
            return
        }
        
        CommentedBoardApi(userToken: accessToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    // Sort the posts so that the most recent ones are at the top
                    self.commentedPosts = posts.sorted(by: { $0.postId > $1.postId })
                    self.hasCommentedPosts = !posts.isEmpty
                case .failure(let error):
                    print("Error loading commented posts: \(error.localizedDescription)")
                    self.hasCommentedPosts = false
                }
                self.isLoading = false
            }
        }
    }
    
    func CommentedBoardApi(userToken: String, completion: @escaping (Result<[CommentedPost], Error>) -> Void) {
        let url = APIConstants.communityCommentList.path
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(userToken)"
        ]
        
        AF.request(url,
                   method: .get,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: BoardCommentedModel.self) { response in
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

struct EmptyCommentedBoard: View {
    var body: some View {
        VStack {
            Text("아직 댓글을 단 게시물이 없어요")
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
    CommentedBoardViewController()
}


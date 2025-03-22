import SwiftUI
import Alamofire

struct WrittenBoardViewController: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var hasWrittenPosts: Bool = true // Tracks if there are written posts
    @State private var writtenPosts: [WrittenPost] = [] // Stores the list of written posts
    @State private var isLoading: Bool = true // Tracks the loading state
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // Back button
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        print("Back button tapped")
                    }) {
                        Image("BackButton")
                            .frame(width: Constants.nav, height: Constants.nav)
                    }
                    
                    Spacer()
                    
                    Text("내가 쓴 글")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.Gray900)
                    
                    Spacer()
                    
                    Image("") // More button, not currently used
                        .frame(width: Constants.nav, height: Constants.nav)
                }
                
                Divider()
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if hasWrittenPosts && !writtenPosts.isEmpty {
                    ScrollView {
                        // Display the list of written posts
                        ForEach(writtenPosts, id: \.postId) { post in
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
                        EmptyWrittenBoard()
                        Spacer()
                    }
                }
            }
            .onAppear {
                loadWrittenPosts()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    func loadWrittenPosts() {
//        guard let accessTokenData = KeychainHelper.standard.read(service: "access-token", account: "user"),
//              let accessToken = String(data: accessTokenData, encoding: .utf8) else {
//            print("토큰이 없습니다.")
//            self.isLoading = false
//            self.hasWrittenPosts = false
//            return
//        }
//        
//        WrittenBoardApi(userToken: accessToken) { result in
//            switch result {
//            case .success(let posts):
//                self.writtenPosts = posts
//                self.hasWrittenPosts = !posts.isEmpty
//            case .failure(let error):
//                print("Error loading written posts: \(error.localizedDescription)")
//                self.hasWrittenPosts = false
//            }
//            self.isLoading = false
//        }
        guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user"), !accessToken.isEmpty else {
            print("No token available.")
            self.isLoading = false
            return
        }
        
        WrittenBoardApi(userToken: accessToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self.writtenPosts = posts.sorted(by: { $0.postId > $1.postId }) // Ensure most recent posts are at the top
                    self.hasWrittenPosts = !posts.isEmpty
                case .failure(let error):
                    print("Error loading written posts: \(error.localizedDescription)")
                    self.hasWrittenPosts = false
                }
                self.isLoading = false
            }
        }
    }
    
    func WrittenBoardApi(userToken: String, completion: @escaping (Result<[WrittenPost], Error>) -> Void) {
        let url = APIConstants.communityPostList.path
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(userToken)"
        ]
        
        AF.request(url,
                   method: .get,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: WrittenPostsResponse.self) { response in
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

struct EmptyWrittenBoard: View {
    var body: some View {
        VStack {
            Text("아직 작성한 게시물이 없어요")
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
    WrittenBoardViewController()
}


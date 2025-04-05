import SwiftUI
import Alamofire

struct BoardDoctoralViewController: View {
    
    @State private var searchText: String = "" // 검색 텍스트 상태 변수
    @State private var selectedButton: String? = "질문 게시판" // 기본값을 '질문 게시판'으로 설정
    @State private var isSearchActive: Bool = false // 검색 바 클릭 상태 변수
    @State private var posts: [BoardListResult] = [] // 게시물 데이터를 저장할 상태 변수
    @State private var isLoading: Bool = true // 데이터 로딩 상태
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                // 검색 바
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8) // 아이콘 왼쪽 여백
                    
                    Text("게시판에서 궁금한 내용을 검색해 보세요!")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.leading, 12)
                        .onTapGesture {
                            isSearchActive = true
                        }
                }
                .padding(.horizontal, 16) // 좌우 여백 추가
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Constants.Gray50) // 밝은 회색 배경색
                .cornerRadius(8) // 모서리 둥글게
                
                Spacer()
                
                // 가로 스크롤 뷰
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        BoardButton(text: "질문 게시판", isSelected: selectedButton == "질문 게시판") {
                            selectedButton = "질문 게시판"
                            loadPosts()
                        }
                        BoardButton(text: "취업후기 게시판", isSelected: selectedButton == "취업후기 게시판") {
                            selectedButton = "취업후기 게시판"
                            loadPosts()
                        }
                        BoardButton(text: "대학원생활 게시판", isSelected: selectedButton == "대학원생활 게시판") {
                            selectedButton = "대학원생활 게시판"
                            loadPosts()
                        }
                        BoardButton(text: "연구주제 게시판", isSelected: selectedButton == "연구주제 게시판") {
                            selectedButton = "연구주제 게시판"
                            loadPosts()
                        }
                    }
                    .font(.system(size: 12, weight: .medium))
                    .padding(.top, 8)
                }
                
                // 선택된 게시판에 따라 다른 뷰 표시
                VStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else if posts.isEmpty {
                        Text("게시물이 없습니다.")
                            .foregroundColor(Constants.Gray500)
                            .padding()
                    } else {
                        ForEach(posts, id: \.postId) { post in
                            BoardItem(post: post, selectedButton: selectedButton ?? "게시판") // selectedButton을 전달
                        }
                    }
                }
                
                .padding(.top, 20)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
        }
        .overlay(
            overlayButton(selectedButton: selectedButton)
                .padding(.trailing, 24)
                .padding(.bottom, 48)
            ,alignment: .bottomTrailing
        )
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isSearchActive) {
            SearchViewController(boardName: selectedButton ?? "게시판")
        }
        .onAppear {
            loadPosts() // 초기 로드
        }
    }
    
    // 게시글을 불러오는 함수
    func loadPosts() {
        isLoading = true
        
        //        guard let accessTokenData = KeychainHelper.standard.read(service: "access-token", account: "user"),
        //              let accessToken = String(data: accessTokenData, encoding: .utf8) else {
        //            print("토큰이 없습니다.")
        //            self.isLoading = false
        //            return
        //        }
        //        guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self), !accessToken.isEmpty else {
        //            print("토큰이 없습니다.")
        //            self.isLoading = false
        //            return
        //        }
        
        let boardName = selectedButton ?? "질문 게시판"
        let url = APIConstants.posts.path + "/list"
        
        let parameters: [String: Any] = [
            "menu": "박사",
            "boardName": boardName
        ]
        
        let headers: HTTPHeaders = [
            //            "Authorization": "Bearer \(accessToken)"
        ]
        
        NetworkAuthManager.shared.request(url, method: .get, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoardListGetResponseModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        self.posts = data.result.reversed() // 배열을 뒤집어 상단에 추가되도록 함
                    } else {
                        print("Error: \(data.message)")
                        self.posts = []
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.posts = []
                }
                self.isLoading = false
            }
    }
}

struct BoardItem: View {
    var post: BoardListResult
    var selectedButton: String
    
    var body: some View {
        Button(action: {
            pushToDetail()
        }) {
            VStack(alignment: .leading, spacing: 12) {
                
                // 취업후기 게시판일 경우에만 채용형태와 지원분야 라벨 표시
                if selectedButton == "취업후기 게시판" {
                    HStack {
                        if let hiringType = post.hiringType {
                            Text(hiringType)
                                .font(.system(size: 12, weight: .bold))
                                .padding(4)
                                .background(Color(red: 1, green: 0.97, blue: 0.87))
                                .foregroundColor(Color(red: 1, green: 0.75, blue: 0))
                                .cornerRadius(4)
                        }
                        
                        if let supportField = post.supportField {
                            Text(supportField)
                                .font(.system(size: 12, weight: .bold))
                                .padding(4)
                                .background(Constants.Gray50)
                                .foregroundColor(Constants.Gray500)
                                .cornerRadius(4)
                        }
                    }
                }
                
                // 제목과 미리보기 내용은 모든 게시판에서 표시
                Text(post.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Constants.Gray900)
                
                Text(post.previewContent)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Constants.Gray900)
                    .lineLimit(2)
                
                // 댓글 수와 조회수는 모든 게시판에서 표시
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
    
    func pushToDetail() {
        let detailView = DummyBoardDetail(boardName: selectedButton, postId: post.postId, memberId: 10)
        let vc = UIHostingController(rootView: detailView)
        vc.hidesBottomBarWhenPushed = true
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController,
           let nav = findNavigationController(from: rootVC) {
            nav.pushViewController(vc, animated: true)
        }
    }
    
    func findNavigationController(from vc: UIViewController) -> UINavigationController? {
        if let nav = vc as? UINavigationController {
            return nav
        }
        for child in vc.children {
            if let found = findNavigationController(from: child) {
                return found
            }
        }
        return nil
    }
}

#Preview {
    BoardDoctoralViewController()
}



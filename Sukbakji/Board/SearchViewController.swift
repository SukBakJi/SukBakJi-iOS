import SwiftUI
import Alamofire

struct SearchViewController: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""
    @State private var hasSearchResults: Bool = true // 검색 결과 상태 변수
    var boardName: String? = nil // If nil, search across all boards
    var menu: String? = nil // If nil, search across all boards
    @State private var filteredResults: [BoardSearchResult] = [] // 검색 결과를 저장할 상태 변수
    @State private var isLoading: Bool = false // 로딩 상태를 나타내는 변수

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        Image("Search")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        TextField("제목과 내용을 자유롭게 검색해 보세요", text: $searchText, onCommit: {
                            // 검색 로직 추가
                            performSearch()
                        })
                        .padding(.leading, 12)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Constants.Gray900)
                        
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Constants.Gray50)
                    .cornerRadius(12)
                    
                    Button("취소") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Constants.Gray800)
                    .padding(.leading, 10)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                ScrollView {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.top, 50)
                    } else if !searchText.isEmpty && filteredResults.isEmpty {
                        VStack(alignment: .center, spacing: 8) {
                            Image("Warning")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .padding(.bottom, 17)
                            
                            Text("\(searchText)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
                            + Text("에 대한\n검색 결과가 없어요")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Constants.Gray900)
                            
                            Spacer()
                        }
                        .padding(.vertical, 144)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if !filteredResults.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(filteredResults, id: \.postId) { item in
                                NavigationLink(destination: DummyBoardDetail(boardName: item.boardName, postId: item.postId, memberId: nil)) {
                                    SearchedBoardItem(post: item, selectedButton: "검색 결과")
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                    } else {
                        VStack(alignment: .center, spacing: 8) {
                            Image("Magnifier 1")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .padding(.bottom, 17)
                            
                            if let boardName = boardName {
                                Text("\(boardName)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
                                + Text(" 글을\n검색해 보세요")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Constants.Gray900)
                            } else {
                                Text("커뮤니티에서 글을\n검색해 보세요")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Constants.Gray900)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 144)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    func performSearch() {
        guard !searchText.isEmpty else { return }

        // 검색 시작 시 로딩 상태로 전환
        isLoading = true
        filteredResults = [] // 이전 결과 초기화

        guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self), !accessToken.isEmpty else {
            print("토큰이 없습니다.")
            isLoading = false
            return
        }

        // API 호출
        BoardSearchApi(keyword: searchText, menu: menu, boardName: boardName, userToken: accessToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self.filteredResults = results
                case .failure(let error):
                    print("Error searching posts: \(error.localizedDescription)")
                }
                self.isLoading = false
            }
        }
    }
    
    func BoardSearchApi(keyword: String, menu: String? = nil, boardName: String? = nil, userToken: String, completion: @escaping (Result<[BoardSearchResult], Error>) -> Void) {
        // 기본 URL
        let url = APIConstants.communitySearch.path
        
        // 쿼리 파라미터 설정
        var parameters: [String: String] = ["keyword": keyword]
        
        if let menu = menu {
            parameters["menu"] = menu
        }
        
        if let boardName = boardName {
            parameters["boardName"] = boardName
        }
        
        // 요청 헤더에 Authorization 추가
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(userToken)"
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default, // GET 요청에서 쿼리 파라미터를 URL에 추가
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: BoardSearchModel.self) { response in
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
}

struct SearchedBoardItem: View {
    let post: BoardSearchResult
    let selectedButton: String
    
    var body: some View {
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
                .stroke(Constants.Gray300, lineWidth: 1)
        )
    }
}

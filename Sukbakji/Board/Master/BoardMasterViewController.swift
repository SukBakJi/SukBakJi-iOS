//
//  BoardMasterViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/25/24.
//

import SwiftUI
import Alamofire

struct BoardMasterViewController: View {
    
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
                        BoardButton(text: "박사지원 게시판", isSelected: selectedButton == "박사지원 게시판") {
                            selectedButton = "박사지원 게시판"
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
                        BoardButton(text: "박사합격 후기", isSelected: selectedButton == "박사합격 후기") {
                            selectedButton = "박사합격 후기"
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
                            BoardItem(post: post, selectedButton: selectedButton ?? "게시판")
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
        
        guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self), !accessToken.isEmpty else {
            print("토큰이 없습니다.")
            self.isLoading = false
            return
        }
        
        let boardName = selectedButton ?? "질문 게시판"
        let url = APIConstants.boardpostURL + "/list"
        
        let parameters: [String: Any] = [
            "menu": "석사",
            "boardName": boardName
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
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

#Preview {
    BoardMasterViewController()
}

// MARK: -- 글쓰기 버튼
struct overlayButton: View {
    var selectedButton: String? // Add this property to capture the selectedButton state
    
    var body: some View {
        Button(action: {
            // 버튼 클릭 시 동작할 코드를 여기에 작성합니다.
            print("글쓰기 버튼 tapped!")
        }) {
            NavigationLink(destination: BoardWriteViewController()) {
                ZStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .background(.clear)
                        .foregroundStyle(Color(Constants.Orange700))
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
                    
                    Image("edit 1")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(PlainButtonStyle()) // 버튼의 기본 스타일을 제거합니다.
            }
        }
    }
}

// MARK: -- 게시판 버튼 뷰
struct BoardButton: View {
    var text: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? Color(red: 0.98, green: 0.31, blue: 0.06) : Constants.Gray500)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color(red: 0.99, green: 0.91, blue: 0.9) : Constants.Gray50)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Constants.Gray200 : Color.clear, lineWidth: 1)
                )
        }
    }
}


// MARK: -- 각 게시판에 대한 뷰
// MARK: -- 석사 탭 질문 게시판
struct MasterQnABoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("질문 게시판")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard(boardName: "질문 게시판")
        dummyBoard(boardName: "질문 게시판")
        dummyBoard(boardName: "질문 게시판")
    }
}

// MARK: -- 박사지원 게시판
struct MasterToDoctoralBoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("박사지원 게시판")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard(boardName: "박사지원 게시판")
        dummyBoard(boardName: "박사지원 게시판")
        dummyBoard(boardName: "박사지원 게시판")
    }
}

// MARK: -- 취업후기 게시판
struct MasterEmploymentReviewBoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("취업후기 게시판")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
//        EmploymentDummyBoard()
//        EmploymentDummyBoard()
//        EmploymentDummyBoard()
    }
}

// MARK: -- 대학원생활 게시판
struct MasterLifeBoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("대학원생활 게시판")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard(boardName: "대학원생활 게시판")
        dummyBoard(boardName: "대학원생활 게시판")
        dummyBoard(boardName: "대학원생활 게시판")
    }
}

// MARK: -- 박사합격 후기
struct MasterToDoctoralReviewBoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("박사합격 후기")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard(boardName: "박사합격 후기")
        dummyBoard(boardName: "박사합격 후기")
        dummyBoard(boardName: "박사합격 후기")
    }
}

// MARK: -- 연구주제 게시판
struct MasterResearchTopicBoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("연구주제 게시판")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard(boardName: "연구주제 게시판")
        dummyBoard(boardName: "연구주제 게시판")
        dummyBoard(boardName: "연구주제 게시판")
    }
}

#Preview {
    BoardMasterViewController()
}


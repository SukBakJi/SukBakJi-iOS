//
//  BoardMainViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/25/24.
//

import SwiftUI
import Alamofire

struct BoardMainViewController: View {
    
    @State private var searchText: String = "" // 검색 텍스트 상태 변수
    @State private var hasBookmarkedBoard: Bool = true // 즐겨찾기한 게시판 상태 변수
    @State private var isSearchActive: Bool = false // 검색 바 클릭 상태 변수
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // MARK - fixedText
            VStack {
                ZStack(alignment: .topLeading) {
                    Color(red: 1, green: 0.44, blue: 0.23) // 주황색 배경 설정
                        .frame(height: 116)
                        .edgesIgnoringSafeArea(.horizontal) // 가로로 안전 영역을 무시하여 전체 너비를 사용
                    
                    Text("석박지에서\n함께 소통해 보세요!📢")
                        .font(Font.custom("Pretendard", size: Constants.fontSizeL).weight(Constants.fontWeightSemiBold))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 24)
                }
                // MARK - 검색창
                .overlay(
                    VStack {
                        HStack {
                            Image("Search")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .padding(.leading, 16) // 아이콘 왼쪽 여백
                                .padding(.vertical, 12) // 상하 여백 추가
                            
                            Text("게시판에서 궁금한 내용을 검색해 보세요!")
                                .font(.system(size: 14))
                                .foregroundColor(Constants.Gray300)
                                .padding(.horizontal, 4) // 아이콘과 텍스트 사이의 여백 추가
                                .onTapGesture {
                                    isSearchActive = true
                                }
                            
                            Spacer() // 아이콘과 텍스트 사이에 빈 공간 추가
                        }
                        .padding(.leading, 4) // 좌우 여백 추가
                        .background(Constants.Gray50) // 밝은 회색 배경색
                        .cornerRadius(12) // 모서리 둥글게
                        .padding(.top, 120) // 검색창과 주황색 배경 간의 공간 조정
                        
                        Spacer() // 검색창과 다른 요소 간의 공간을 만듭니다.
                    }
                        .padding(.horizontal, 24)
                )
                
                // MARK: -- 탭 메뉴 4개 영역
                tapMenu()
                
                // MARK: -- 최신 질문글
                qnaBoard()
                
                // MARK: -- 즐겨찾기한 게시판
                /*
                if hasBookmarkedBoard {
                    HStack(alignment: .center) {
                        Text("즐겨찾기한 게시판")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeL)
                                    .weight(Constants.fontWeightSemiBold)
                            )
                            .foregroundColor(Constants.Gray900)
                        
                        Image("Star 1")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                        
                        Spacer()
                        
                        Button(action: {
                            print("즐겨찾기한 게시판 tapped")
                            // 버튼 클릭 시 동작
                        }) {
                            Text("더보기")
                                .font(
                                    Font.custom("Pretendard", size: Constants.fontSizeXs)
                                        .weight(Constants.fontWeightMedium)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(Constants.Gray500)
                            
                            Image("More 1")
                                .resizable()
                                .frame(width: 4, height: 8)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    .padding(.bottom, 12)
                    .frame(alignment: .center)
                    .background(Constants.White)
                    .buttonStyle(PlainButtonStyle())  // 기본 버튼 스타일
                    bookmarkedBoard()
                } else if !hasBookmarkedBoard {
                    VStack {
                        Spacer()
                        
                        HStack(alignment: .center) {
                            Text("즐겨찾기한 게시판")
                                .font(
                                    Font.custom("Pretendard", size: Constants.fontSizeL)
                                        .weight(Constants.fontWeightSemiBold)
                                )
                                .foregroundColor(Constants.Gray900)
                            
                            Image("Star 1")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, 12)
                        .frame(alignment: .center)
                        .background(Constants.White)
                        
                        EmptyBookmarkBoard()
                        
                        Spacer()
                    }
                } else { */
                    VStack {
                        Spacer()
                        
                        HStack(alignment: .center) {
                            Text("즐겨찾기한 게시판")
                                .font(
                                    Font.custom("Pretendard", size: Constants.fontSizeL)
                                        .weight(Constants.fontWeightSemiBold)
                                )
                                .foregroundColor(Constants.Gray900)
                            
                            Image("Star 1")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, 12)
                        .frame(alignment: .center)
                        .background(Constants.White)
                        
                        UnreadyBookmarkBoard()
                            .padding(.vertical, 48)
                        
                        Spacer()
                    }
//                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isSearchActive) {
            SearchViewController(boardName: "게시판")
        }
    }
}


// MARK: -- 컨테이너 버튼 'HOT 게시판', '내가 쓴 글', '스크랩', '댓글 단 글'
struct tapMenu: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                // HOT 게시판 버튼
                Button(action: {
                    // HOT 게시판 버튼 클릭 시 동작할 코드
                    print("HOT 게시판 tapped")
                }) {
                    NavigationLink(destination: HotBoardViewController()) {
                        ZStack(alignment: .topLeading) { // 텍스트를 상자의 좌측 상단에 정렬
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Constants.Gray50)
                            
                            HStack {
                                Text("HOT 게시판")
                                    .font(
                                        Font.custom("Pretendard", size: 14)
                                            .weight(.semibold)
                                    )
                                    .foregroundColor(Constants.Gray900)
                                    .padding(.top, 16) // 위쪽 여백
                                    .padding(.leading, 12) // 왼쪽 여백
                                    .padding(.bottom, 47)
                                    .frame(maxWidth: .infinity, alignment: .topLeading) // 왼쪽 위 정렬
                                
                                
                                
                                Image("Magnifier") // 이미지 추가
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .padding(.top, 20)
                                
                            }
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일
                
                // 내가 쓴 글 버튼
                Button(action: {
                    // 내가 쓴 글 버튼 클릭 시 동작할 코드
                    print("내가 쓴 글 tapped")
                }) {
                    NavigationLink(destination: WrittenBoardViewController()) {
                        ZStack(alignment: .topLeading) { // 텍스트를 상자의 좌측 상단에 정렬
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Constants.Gray50)

                            HStack {
                                Text("내가 쓴 글")
                                    .font(
                                        Font.custom("Pretendard", size: 14)
                                            .weight(.semibold)
                                    )
                                    .foregroundColor(Constants.Gray900)
                                    .padding(.top, 16) // 위쪽 여백
                                    .padding(.leading, 12) // 왼쪽 여백
                                    .padding(.bottom, 47)
                                    .frame(maxWidth: .infinity, alignment: .topLeading) // 왼쪽 위 정렬
                                
                                
                                
                                Image("Pencil") // 이미지 추가
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .padding(.top, 20)
                                
                            }
                        }
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Constants.Gray900)
                }
                .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일
            }
            
            HStack(spacing: 8) {
                // 스크랩 버튼
                Button(action: {
                    // 스크랩 버튼 클릭 시 동작할 코드
                    print("스크랩 tapped")
                }) {
                    NavigationLink(destination: ScrappedBoardViewController()) {
                        ZStack(alignment: .topLeading) { // 텍스트를 상자의 좌측 상단에 정렬
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Constants.Gray50)

                            HStack {
                                Text("스크랩")
                                    .font(
                                        Font.custom("Pretendard", size: 14)
                                            .weight(.semibold)
                                    )
                                    .foregroundColor(Constants.Gray900)
                                    .padding(.top, 16) // 위쪽 여백
                                    .padding(.leading, 12) // 왼쪽 여백
                                    .padding(.bottom, 47)
                                    .frame(maxWidth: .infinity, alignment: .topLeading) // 왼쪽 위 정렬
                                
                                
                                
                                Image("Folder") // 이미지 추가
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .padding(.top, 20)
                                
                            }
                        }
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Constants.Gray900)
                }
                .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일
                
                // 댓글 단 글 버튼
                Button(action: {
                    // 댓글 단 글 버튼 클릭 시 동작할 코드
                    print("댓글 단 글 tapped")
                }) {
                    NavigationLink(destination: CommentedBoardViewController()) {
                        ZStack(alignment: .topLeading) { // 텍스트를 상자의 좌측 상단에 정렬
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Constants.Gray50)

                            HStack {
                                Text("댓글 단 글")
                                    .font(
                                        Font.custom("Pretendard", size: 14)
                                            .weight(.semibold)
                                    )
                                    .foregroundColor(Constants.Gray900)
                                    .padding(.top, 16) // 위쪽 여백
                                    .padding(.leading, 12) // 왼쪽 여백
                                    .padding(.bottom, 47)
                                    .frame(maxWidth: .infinity, alignment: .topLeading) // 왼쪽 위 정렬
                                
                                
                                
                                Image("Chat") // 이미지 추가
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .padding(.top, 20)
                                
                            }
                        }
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Constants.Gray900)
                }
                .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일
            }
        }
        .padding(.horizontal, 24) // 좌우 여백 추가
        .padding(.top, 30) // 추가적인 여백
    }
}

// MARK: -- 최신 질문 게시판
struct qnaBoard: View {
    @State private var qnaPosts: [LatestQnAModelResult] = []
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 4) {
                Text("최신 질문글")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemiBold)
                    )
                    .foregroundColor(Constants.Gray900)
                    .padding(.leading, 24)
                
                Image("Magnifier 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15.41667, height: 15.79834)
                
                Spacer()

                Button(action: {
                    print("최신 질문글 tapped")
                }) {
                    NavigationLink(destination: BoardQnAViewController()) {
                        Text("더보기")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeXs)
                                    .weight(Constants.fontWeightMedium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Constants.Gray500)
                        
                        Image("More 1")
                            .resizable()
                            .frame(width: 4, height: 8)
                    }
                }
                .padding(.horizontal, 24)
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.top, 28)
            
            VStack(alignment: .leading, spacing: 0) {
                if qnaPosts.isEmpty {
                    Text("최신 질문글이 없습니다.")
                        .font(.system(size: 14))
                        .foregroundColor(Constants.Gray900)
                        .padding()
                } else {
                    ForEach(qnaPosts.prefix(3), id: \.postId) { question in
                        HStack(alignment: .center, spacing: 12) {
                            NavigationLink(destination: DummyBoardDetail(boardName: question.menu, postId: question.postId, memberId: nil)) {
                                HStack {
                                    Text(question.menu)
                                        .font(Font.custom("Pretendard", size: Constants.fontSizeXs)
                                            .weight(Constants.fontWeightMedium))
                                        .foregroundColor(Color(red: 0.29, green: 0.45, blue: 1))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(RoundedRectangle(cornerRadius: 4)
                                            .fill(Color(red: 0.91, green: 0.92, blue: 1)))
                                        .padding(.leading, 18)

                                    Text(question.title)
                                        .font(Font.custom("Pretendard", size: Constants.fontSizeS)
                                            .weight(Constants.fontWeightSemiBold))
                                        .foregroundColor(Constants.Gray900)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .padding(.leading, 12)
                                        .padding(.vertical, 18)
                                }
                                .contentShape(Rectangle()) // ← 터치 영역을 전체로 확장
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        Divider()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: 0.5)
                    .stroke(Constants.Gray100, lineWidth: 1)
            )
            .padding(.horizontal, 24)

            Spacer(minLength: 16)
        }
        .background(Constants.Gray50)
        .padding(.top, 20)
        .onAppear {
            loadQnAPosts()
        }
    }

    /// 최신 질문글을 가져오는 함수
    private func loadQnAPosts() {
        isLoading = true
        fetchLatestQnA { result in
            switch result {
            case .success(let posts):
                self.qnaPosts = posts
            case .failure(let error):
                print("❌ 최신 질문글 로딩 실패: \(error.localizedDescription)")
            }
            self.isLoading = false
        }
    }

    /// 최신 질문글 API 요청 함수 (참고 코드 양식 그대로 유지)
    private func fetchLatestQnA(completion: @escaping (Result<[LatestQnAModelResult], Error>) -> Void) {
        let url = APIConstants.communityLastestQuestions.path

        guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user"), !accessToken.isEmpty else {
            print("❌ JWT 토큰이 없습니다.")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "JWT 토큰이 없습니다."])))
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LatestQnAModel.self) { response in
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

// MARK: -- 즐겨찾기한 게시판
struct bookmarkedBoard: View {
    
    @State var progress: Double = 0.0
    
    var body: some View {
        VStack {
            GeometryReader { outerGeometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<8) { _ in
                            bookmarkedBoardTable()
                        }
                    }
                    .background(
                        GeometryReader { innerGeometry in
                            Color.clear
                                .onChange(of: innerGeometry.frame(in: .global)) { _ in
                                    let contentWidth = innerGeometry.size.width
                                    let scrollOffset = outerGeometry.frame(in: .global).minX - innerGeometry.frame(in: .global).minX
                                    let progressValue = Double(scrollOffset / (contentWidth - outerGeometry.size.width))
                                    progress = max(0.0, min(1.0, progressValue))
                                }
                        }
                    )
                }
                .padding(.horizontal, 24)
            }
            .frame(height: 150)  // 적절한 높이 설정
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                .padding(.horizontal, 24)
                .padding(.top, 10)
        }
    }
}

// MARK: -- 즐겨찾기한 게시판 테이블뷰
struct bookmarkedBoardTable: View {
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack(alignment: .center, spacing: 4) {
                        Text("박사")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(red: 0.99, green: 0.91, blue: 0.9))
                    .cornerRadius(4)
                    
                    HStack(alignment: .center, spacing: 4) {
                        Text("질문")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Constants.Gray500)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Constants.Gray50)
                    .cornerRadius(4)
                }
                
                Text("아삭아삭 석박지")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Constants.Gray900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("무를 큼직하게 썰어 양념에 버무린 섞박지는 국밥, 설렁탕 등 맑은 국물이 있는 요리")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Constants.Gray900)
                    .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36, alignment: .topLeading)
                
                HStack {
                    Image("chat 1")
                        .resizable()
                        .frame(width: 12, height: 12)
                    
                    Text("12")
                        .font(.system(size: 12, weight: .medium))
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(Color(red: 0.29, green: 0.45, blue: 1))
                    
                    Image("eye")
                        .resizable()
                        .frame(width: 12, height: 12)
                    
                    Text("14")
                        .font(.system(size: 12, weight: .medium))
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .topTrailing)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .frame(width: 165, alignment: .topLeading)
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


// MARK: -- 즐겨찾기한 게시판이 없을 경우
struct EmptyBookmarkBoard: View {
    var body: some View {
        VStack {
            Text("아직 즐겨찾기한 게시물이 없어요")
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Constants.Gray500)
                .padding(.bottom, 8)
            
            Text("게시판을 탐색하고 즐겨찾기를 등록해 보세요!")
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.Gray500)
            
        }
    }
}

// MARK: -- 즐겨찾기한 게시판 준비중인 서비스
struct UnreadyBookmarkBoard: View {
    var body: some View {
        VStack {
            Text("준비중인 서비스입니다.")
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Constants.Gray500)
                .padding(.bottom, 8)
            
            Text("추후에 게시판을 탐색하고 즐겨찾기를 등록해 보세요!")
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.Gray500)
            
        }
    }
}

// MARK: -- Preview
struct BoardMainViewController_Previews: PreviewProvider {
    static var previews: some View {
        BoardMainViewController()
    }
}



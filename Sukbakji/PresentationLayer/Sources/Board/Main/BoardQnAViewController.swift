//
//  BoardQnAViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/25/24.
//

import SwiftUI
import Alamofire

struct BoardQnAViewController: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showAlert: Bool = false
    @State private var showBookmarkAlert: Bool = false
    @State private var showingSheet = false
    @State private var isAuthor = true // 작성자인지 여부를 나타내는 상태 변수
    @State private var isBookmarked = false // 즐겨찾기 상태를 나타내는 변수
    @State private var showBookmarkOverlay = false // 즐겨찾기 오버레이 표시 상태 변수
    @State private var bookmarkOverlayMessage = "" // 오버레이 메시지
    @State private var showAnonymousMessage = false // 익명 메시지 표시 상태 변수
    @State private var qnaPosts: [BoardNewQnAResult] = [] // 질문 게시판의 최신 질문 목록을 저장할 상태 변수
    @State private var isLoading: Bool = true // 로딩 상태를 추적하는 상태 변수
    @State private var posts: [BoardListResult] = []

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        // 뒤로가기 버튼
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            print("뒤로가기 버튼 tapped")
                        }) {
                            Image("BackButton")
                                .frame(width: Constants.nav, height: Constants.nav)
                        }

                        Spacer()

                        Text("질문 게시판")
                            .font(.system(size: 20, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Constants.Gray900)

                        Spacer()

                        // 더보기 버튼
                        Button(action: {
                            self.showingSheet = true
                        }) {
                            Image("MoreButton")
                                .frame(width: Constants.nav, height: Constants.nav)
                        }
                        .actionSheet(isPresented: $showingSheet) {
                            if isAuthor {
                                return ActionSheet(
                                    title: Text("질문 게시판"),
                                    buttons: [
                                        .default(Text("신고하기")),
                                        .default(Text(isBookmarked ? "즐겨찾기 삭제하기" : "즐겨찾기 등록하기"), action: {
                                            toggleBookmark()
                                        }),
                                        .cancel(Text("취소"))
                                    ]
                                )
                            } else {
                                return ActionSheet(
                                    title: Text("질문 게시판"),
                                    buttons: [
                                        .default(Text(isBookmarked ? "즐겨찾기 삭제하기" : "즐겨찾기 등록하기"), action: {
                                            toggleBookmark()
                                        }),
                                        .cancel(Text("취소"))
                                    ]
                                )
                            }
                        }
                    }

                    Divider()

                    ScrollView(showsIndicators: false) {
                        // 공지사항 글
                        noticeView(showAlert: $showAlert)
                            .padding(.horizontal, 24)

                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else if posts.isEmpty {
                            Spacer()
                            EmptyQnABoard()
                            Spacer()
                        } else {
                            // 게시판 글 목록
                            ForEach(posts, id: \.postId) { post in
                                BoardItem(post: post, selectedButton: "질문 게시판")
                                    .padding(.horizontal, 24)
                            }
                        }
                    }
//                    .overlay(
//                        overlayButton(selectedButton: "질문 게시판")
//                            .padding(.trailing, 24) // 오른쪽 여백
//                        , alignment: .bottomTrailing // 오른쪽 아래에 위치
//                    )
                }

                if showAlert {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 16) {
                        Text("공지")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeL)
                                    .weight(Constants.fontWeightSemiBold)
                            )
                            .foregroundColor(Constants.Gray900)
                        
                        Text("게시판 내 개인정보 유추 금지와 관련하여 안내드립니다")
                            .font(
                                Font.custom("Pretendard", size: 14)
                                    .weight(.medium)
                            )
                            .foregroundStyle(Constants.Gray800)
                            .frame(alignment: .topLeading)
                        
                        Button(action: {
                            showAlert = false
                        }) {
                            Text("확인했어요")
                                .padding(.horizontal, 93)
                                .padding(.vertical, 10)
                                .font(.system(size: 16, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .background(Color(red: 0.93, green: 0.29, blue: 0.03))
                                .foregroundColor(Constants.White)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .background(Constants.White)
                    .cornerRadius(16)
                    .padding(.horizontal, 48)
                }

                if showBookmarkOverlay {
                    VStack {
                        Spacer()
                        HStack {
                            Image("Star 1")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 18, height: 18)
                                .foregroundColor(Constants.White)

                            Text(bookmarkOverlayMessage)
                                .padding(.leading, 12)
                                .foregroundColor(Constants.White)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                        .transition(.opacity)
                        .animation(.easeInOut, value: showBookmarkOverlay)

                        Spacer().frame(height: 59)
                    }
                }

                if showAnonymousMessage {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                            Text("익명으로 함께 소통해 보세요!")
                                .font(.system(size: 12, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 11)
                                .background(Color(red: 1, green: 0.34, blue: 0.08))
                                .foregroundColor(Constants.White)
                                .cornerRadius(6)
                        }
                        .padding(.trailing, 24)

                        Spacer().frame(height: 65)
                    }
                    .transition(.opacity)
                }
            }
            .alert(isPresented: $showBookmarkAlert) {
                Alert(
                    title: Text("즐겨찾기 등록"),
                    message: Text("즐겨찾기에 등록되었습니다."),
                    dismissButton: .default(Text("확인"))
                )
            }
            .onAppear {
                showAnonymousMessage = true
                //loadQnAPosts()
                loadAllPosts() // 메뉴의 모든 게시글을 불러옴
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        showAnonymousMessage = false
                    }
                }
            }

        }
        .navigationBarBackButtonHidden()
    }

    private func toggleBookmark() {
        isBookmarked.toggle()
        bookmarkOverlayMessage = isBookmarked ? "즐겨찾기를 등록했어요" : "즐겨찾기에서 삭제했어요"
        showBookmarkOverlay = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showBookmarkOverlay = false
            }
        }
    }

    private func loadQnAPosts() {
        isLoading = true
        BoardNewQnAApi { result in
            switch result {
            case .success(let posts):
                self.qnaPosts = posts
            case .failure(let error):
                print("Error loading QnA posts: \(error.localizedDescription)")
            }
            self.isLoading = false
        }
    }

    func BoardNewQnAApi(completion: @escaping (Result<[BoardNewQnAResult], Error>) -> Void) {
        let url = APIConstants.communityLastestQuestions.path // 실제 API 엔드포인트로 교체

        AF.request(url,
                   method: .get,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoardNewQnAModel.self) { response in
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

    func loadPosts(_ menu: String, completion: @escaping () -> Void) {
        guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user"), !accessToken.isEmpty else {
            print("토큰이 없습니다.")
            completion()
            return
        }

        let url = APIConstants.postsList.path

        let parameters: [String: Any] = [
            "menu": menu,
            "boardName": "질문 게시판"
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
                        DispatchQueue.main.async {
                            self.posts += data.result
                            // Sort posts by postId in descending order
                            self.posts.sort(by: { $0.postId > $1.postId })
                        }
                    } else {
                        print("Error: \(data.message)")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
                completion() // API 요청이 끝나면 completion을 호출
            }
    }

    func loadAllPosts() {
        self.posts = [] // 초기화
        self.isLoading = true

        let group = DispatchGroup()

        // '석사', '박사' 뿐만 아니라 '진학예정'도 포함
        let menus = ["석사", "박사", "진학예정"]
        for menu in menus {
            group.enter()
            loadPosts(menu) {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.isLoading = false
        }
    }
}




// MARK: -- 공지사항
struct noticeView: View {
    @Binding var showAlert: Bool

    var body: some View {
        Button(action: {
            showAlert = true
            print("질문게시판 공지사항 글 tapped")
        }) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 0) {
                    Image("Speaker")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)

                    Text("공지")
                        .padding(.leading, 6)
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightSemiBold)
                        )
                        .foregroundStyle(Constants.Orange400)

                    Divider()
                        .background(Constants.Gray400)
                        .padding(.horizontal, 8.8)

                    Text("게시판 내 개인정보 유추 금지와 관련하여 안내드립니다")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXs)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundStyle(Constants.Gray800)
                        .frame(alignment: .topLeading)
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40, alignment: .topLeading)
            .background(Constants.White)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(Constants.Orange400, lineWidth: 1)
            )
        }
    }
}

struct EmptyQnABoard: View {
    var body: some View {
        VStack {
            Text("아직 질문 게시물이 없어요")
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Constants.Gray500)
                .padding(.bottom, 8)
        }
    }
}


#Preview {
    BoardQnAViewController()
}

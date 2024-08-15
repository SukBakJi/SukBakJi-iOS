//
//  HotBoardViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/27/24.
//

import SwiftUI
import Alamofire

struct HotBoardViewController: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showAlert: Bool = false
    @State private var hotPosts: [BoardHotResult] = [] // HOT 게시판 글 목록을 저장할 상태 변수
    @State private var isLoading: Bool = true // 로딩 상태를 추적하는 상태 변수
    
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
                        
                        Text("HOT 게시판")
                            .font(.system(size: 20, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Constants.Gray900)
                        
                        Spacer()
                        
                        // 더보기 버튼
                        Image("")
                            .frame(width: Constants.nav, height: Constants.nav)
                    }
                    
                    Divider()
                    
                    ScrollView {
                        // 공지사항 글
                        hotNoticeView(showAlert: $showAlert)
                        
                        if isLoading {
                            // 로딩 중일 때 표시할 뷰
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else if hotPosts.isEmpty {
                            // HOT 게시물이 없을 경우 표시할 뷰
                            Spacer()
                            EmptyHotBoard()
                            Spacer()
                        } else {
                            // HOT 게시물 목록 표시
                            ForEach(hotPosts, id: \.title) { post in
                                Board(boardName: post.boardName, title: post.title, content: post.content, commentCount: post.commentCount, views: post.views)
                            }
                        }
                    }
                }
                
                if showAlert {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 16) {
                        Text("공지")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Constants.Gray900)
                        
                        Text("스크랩 20개 이상\n또는 조회수 100회 이상인 게시글의 경우\nHOT 게시판에 선정되어 게시됩니다")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Constants.Gray800)
                            .frame(alignment: .topLeading)
                        
                        Button(action: {
                            showAlert = false
                        }) {
                            Text("확인했어요")
                                .padding(.horizontal, 60)
                                .padding(.vertical, 10)
                                .font(.system(size: 16, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .background(Color(red: 0.93, green: 0.29, blue: 0.03))
                                .foregroundColor(Constants.White)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 48)
                    .padding(.vertical, 24)
                    .background(Constants.White)
                    .cornerRadius(12)
                    .shadow(radius: 8)
                }
            }
            .onAppear {
                loadHotPosts()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    func loadHotPosts() {
        guard let accessTokenData = KeychainHelper.standard.read(service: "access-token", account: "user"),
              let accessToken = String(data: accessTokenData, encoding: .utf8) else {
            print("토큰이 없습니다.")
            self.isLoading = false
            return
        }
        
        HotBoardApi(userToken: accessToken) { result in
            switch result {
            case .success(let posts):
                self.hotPosts = posts
            case .failure(let error):
                print("Error loading HOT posts: \(error.localizedDescription)")
            }
            self.isLoading = false
        }
    }
    
    func HotBoardApi(userToken: String, completion: @escaping (Result<[BoardHotResult], Error>) -> Void) {
        // API 엔드포인트 URL
        let url = APIConstants.communityURL + "/hot-boards" // 실제 API 엔드포인트로 교체

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
            .responseDecodable(of: BoardHotModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        // 성공적으로 데이터를 받아왔을 때, 결과를 반환
                        completion(.success(data.result))
                    } else {
                        // API 호출은 성공했으나, 서버에서 에러를 반환한 경우
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

struct hotNoticeView: View {
    @Binding var showAlert: Bool
    
    var body: some View {
        Button(action: {
            showAlert = true
            print("HOT게시판 공지사항 글 tapped")
        }) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 0) {
                    Image("Speaker")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                    
                    Text("공지")
                        .padding(.leading, 6)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Constants.Orange400)
                    
                    Divider()
                        .background(Constants.Gray400)
                        .padding(.horizontal, 8.8)
                    
                    Text("HOT 게시판 선정 기준 안내드립니다")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Constants.Gray800)
                        .frame(alignment: .topLeading)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .frame(height: 40, alignment: .topLeading)
            .background(Constants.White)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(Constants.Orange400, lineWidth: 1)
            )
        }
        .padding(.horizontal, 24)
    }
}

struct EmptyHotBoard: View {
    var body: some View {
        VStack {
            Text("아직 HOT 게시물이 없어요")
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Constants.Gray500)
                .padding(.bottom, 8)
        }
    }
}

#Preview {
    HotBoardViewController()
}

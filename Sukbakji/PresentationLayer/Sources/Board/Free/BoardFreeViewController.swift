//
//  BoardFreeViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/25/24.
//

import SwiftUI
import Combine
import Alamofire

// MARK: - BoardFreeViewController
struct BoardFreeViewController: View {
    @State private var searchText: String = ""
    @State private var isSearchActive: Bool = false
    @State private var boards: [String] = []
    @State private var selectedMenu: String = "자유" // 기본값 설정
    
    var body: some View {
        VStack {
            // 검색 바
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                
                Text("궁금한 게시판을 검색해 보세요!")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.leading, 12)
                    .onTapGesture {
                        isSearchActive = true
                    }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Constants.Gray50)
            .cornerRadius(8)
            .padding(.horizontal, 24)
            .padding(.top, 20)
                        
            // 즐겨찾기한 게시판 목록
            SavedBoardsView(boards: boards)
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 8)
                .foregroundStyle(Constants.Gray100)
            
            MakeBoardsView()
            
            Spacer()
        }
        .fullScreenCover(isPresented: $isSearchActive) {
            SearchViewController(boardName: "자유 게시판")
        }
        .onAppear {
            fetchSavedBoards(menu: selectedMenu)
        }
    }
    
    func fetchSavedBoards(menu: String) {
        BoardFreeAPI.fetchSavedBoards(menu: menu) { result in
            switch result {
            case .success(let boards):
                self.boards = boards
            case .failure(let error):
                print("❌ 즐겨찾기한 게시판 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - SavedBoardsView: 즐겨찾기한 게시판 UI
struct SavedBoardsView: View {
    let boards: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            if !boards.isEmpty {
                HStack {
                    Text("즐겨찾기한 게시판")
                        .font(Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightMedium))
                        .foregroundColor(Constants.Gray900)
                    
                    Image("Rectangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            }
            
            if boards.isEmpty {
                VStack {
                    Text("아직 즐겨찾기한 게시판이 없어요")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                .weight(Constants.fontWeightSemiBold)
                        )
                        .foregroundColor(Constants.Gray500)
                        .padding(.top, 24)
                    
                    Text("게시판을 탐색하고 즐겨찾기를 등록해 보세요!")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                .weight(Constants.fontWeightRegular)
                        )
                        .foregroundColor(Constants.Gray500)
                        .padding(.top, 8)
                        .padding(.bottom, 42)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 20)
            } else {
                ForEach(boards, id: \.self) { boardName in
                    HStack {
                        Image("star")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 12)
                        
                        Text(boardName)
                            .font(Font.custom("Pretendard", size: Constants.fontSizeL)
                                .weight(Constants.fontWeightMedium))
                            .foregroundColor(Constants.Gray900)
                            .padding(.leading, 6)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .frame(width: 24, height: 24)
                            .foregroundColor(Constants.Gray400)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                }
            }
        }
    }
}

// MARK: - BoardFreeAPI
struct BoardFreeAPI {
    static func fetchSavedBoards(menu: String, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user"),
              !accessToken.isEmpty else {
            print("❌ 인증 토큰이 없습니다. 로그인 후 다시 시도하세요.")
            completion(.failure(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access Token 없음"])))
            return
        }
        
        let urlString = APIConstants.boardsMenu(menu).path  // ✅ menu가 String으로 설정됨
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        print("📌 API 요청 URL: \(urlString)")
        print("🔑 사용 중인 Access Token: \(accessToken)")
        
        AF.request(urlString, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SavedBoardResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("🎯 성공적으로 불러온 게시판 목록: \(data.boards)")
                    completion(.success(data.boards))
                case .failure(let error):
                    if let httpResponse = response.response {
                        print("❌ API 요청 실패: HTTP 상태 코드 \(httpResponse.statusCode)")
                        if httpResponse.statusCode == 400 {
                            print("🚨 [400] 잘못된 요청 - API 요청 형식을 확인하세요. menu 값을 확인하세요: \(menu)")
                        }
                    }
                    print("❌ API 요청 실패: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}

// MARK: - 게시판 생성 유도 UI
struct MakeBoardsView: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("마음에 드는 게시판이 없다면?")
                        .font(Font.custom("Pretendard", size: 18)
                            .weight(.semibold))
                        .foregroundStyle(Constants.Gray900)
                    
                    Text("직접 게시판을 만들고 관심사를 공유해 보세요!")
                        .font(Font.custom("Pretendard", size: 14))
                        .foregroundStyle(Constants.Gray800)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)

            Image("Notes")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)

            Spacer()

            HStack(alignment: .center) {
                Text("게시판 만들러 가기")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeM)
                            .weight(Constants.fontWeightSemiBold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.vertical, 14)
            }
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.93, green: 0.29, blue: 0.03))
            .cornerRadius(8)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    BoardFreeViewController()
}

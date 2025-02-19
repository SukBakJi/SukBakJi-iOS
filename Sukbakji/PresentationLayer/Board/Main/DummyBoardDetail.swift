//
//  DummyBoardDetail.swift
//  Sukbakji
//
//  Created by KKM on 7/29/24.
//

import SwiftUI
import Alamofire

struct DummyBoardDetail: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var commentText: String = ""
    @State private var showValidationError: Bool = false
    @State var showingSheet = false
    @State var showAlert = false
    @State var isAuthor = true // 작성자인지 여부를 나타내는 상태 변수
    var boardName: String // 게시판 이름을 전달받는 변수
    @State private var showDeletionMessage = false
    @State private var showCommentDeletionMessage = false
    @State private var degreeLevel: DegreeLevel? = nil // 사용자의 학위 상태를 저장할 변수
    
    @State private var boardDetail: BoardDetailResult? = nil // 게시물 데이터 상태 변수
    @State private var isLoading: Bool = true // 데이터 로딩 상태
    
    var postId: Int // 게시물 ID를 전달받는 변수
    var memberId: Int? // 사용자 ID를 전달받는 변수
    
    // 댓글 데이터 상태 변수
    @State private var comments: [BoardComment] = []
    @State private var anonymousCounter: Int = 1 // 익명 댓글 번호를 위한 카운터

    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
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
                            
                            Text(boardName)
                                .font(.system(size: 20, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Constants.Gray900)
                            
                            Spacer()
                            
                            Button(action: {
                                self.showingSheet = true
                            }) {
                                Image("MoreButton")
                                    .frame(width: Constants.nav, height: Constants.nav)
                            }
                            .actionSheet(isPresented: $showingSheet) {
                                if isAuthor {
                                    return ActionSheet(
                                        title: Text(boardName),
                                        buttons: [
                                            .default(Text("수정하기")),
                                            .destructive(Text("삭제하기"), action: {
                                                self.showAlert = true
                                            }),
                                            .cancel(Text("취소"))
                                        ]
                                    )
                                } else {
                                    return ActionSheet(
                                        title: Text(boardName),
                                        buttons: [
                                            .default(Text("신고하기")),
                                            .cancel(Text("취소"))
                                        ]
                                    )
                                }
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("게시물 삭제하기"),
                                    message: Text("게시물을 삭제할까요? 삭제 후 복구되지 않습니다."),
                                    primaryButton: .destructive(Text("삭제할게요"), action: {
                                        deletePost() // 게시물 삭제 함수 호출
                                    }),
                                    secondaryButton: .cancel(Text("닫기"))
                                )
                            }
                        }
                        
                        Divider()
                        
                        if let boardDetail = boardDetail {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(boardDetail.menu + " 게시판")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(red: 0.29, green: 0.45, blue: 1))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color(red: 0.91, green: 0.92, blue: 1))
                                        .cornerRadius(4)
                                    
                                    if let hiringType = boardDetail.hiringType {
                                        Text(hiringType)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Color(red: 1, green: 0.75, blue: 0))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(Color(red: 1, green: 0.97, blue: 0.87))
                                            .cornerRadius(4)
                                    }
                                    
                                    if let supportField = boardDetail.supportField {
                                        Text(supportField)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Constants.Gray500)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(Constants.Gray50)
                                            .cornerRadius(4)
                                    }
                                    
                                    Spacer()
                                    BookmarkButtonView(postId: postId)
                                        .frame(width: 20, height: 20)
                                }
                                
                                Text(boardDetail.title)
                                    .padding(.top, 12)
                                    .padding(.bottom, 8)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Constants.Gray900)
                                
                                Text(boardDetail.content)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Constants.Gray900)
                                
                                HStack {
                                    Image("chat 1")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    
                                    Text("\(boardDetail.commentCount)")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(red: 0.29, green: 0.45, blue: 1))
                                    
                                    Image("eye")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    
                                    Text("\(boardDetail.views)")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                                }
                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(Constants.White)
                            
                            VStack {
                                Rectangle()
                                    .frame(height: 8)
                                    .background(Constants.Gray100)
                                    .foregroundStyle(Constants.Gray100)
                                
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 16) {
                                        ForEach(comments.indices, id: \.self) { index in
                                            Comments(comment: comments[index], degreeLevel: degreeLevel, isAuthor: isAuthor, showDeletionMessage: $showDeletionMessage, showCommentDeletionMessage: $showCommentDeletionMessage, deleteComment: {
                                                deleteComment(at: index)
                                            })
                                        }
                                    }
                                }
                            }
                            
                            WriteComment(commentText: $commentText, showValidationError: $showValidationError, addComment: addComment)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            DispatchQueue.main.async {
                loadBoardDetail(postId: postId) // 게시물 상세 정보를 로드합니다.
                loadProfileData() // 프로필 데이터 로드
            }
        }
    }
    
    func addComment() {
        if commentText.isEmpty {
            showValidationError = true
        } else {
            postComment(content: commentText)
        }
    }

    // 댓글 작성 함수
    func postComment(content: String) {
        let url = APIConstants.baseURL + "/comments/create"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let commentRequest = CommentRequest(postId: postId, memberId: memberId ?? 0, content: content)
        
        NetworkAuthManager.shared.request(url, method: .post, parameters: commentRequest, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CommentResponse.self) { response in
                switch response.result {
                case .success(let data):
                    let newComment = BoardComment(
                        anonymousName: data.result.nickname,
                        degreeLevel: "익명", // DegreeLevel 설정이 필요하다면 적절히 변경하세요
                        content: data.result.content,
                        createdDate: data.result.createdAt,
                        memberId: data.result.memberId
                    )
                    
                    comments.insert(newComment, at: 0) // 새로운 댓글을 맨 위에 추가
                    commentText = ""
                    showValidationError = false
                    print("댓글 작성 성공: \(data.message)")
                    
                    // 댓글 카운트 증가
                    boardDetail?.commentCount += 1
                case .failure(let error):
                    if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("Server Error Message: \(errorMessage)")
                    } else {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    // 게시물 삭제 함수
    func deletePost() {
        let url = APIConstants.posts.path + "/\(postId)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        NetworkAuthManager.shared.request(url, method: .delete, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    print("게시물이 삭제되었습니다.")
                    self.presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("Server Error Message: \(errorMessage)")
                    } else {
                        print("Error deleting post: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    // 댓글 삭제 후 UI 업데이트
    func deleteComment(at index: Int) {
        comments.remove(at: index)
    }

    // 게시글 상세 정보를 불러오는 함수
    func loadBoardDetail(postId: Int) {
        let url = APIConstants.posts.path + "/\(postId)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        NetworkAuthManager.shared.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoardDetailModel.self) { response in
                switch response.result {
                case .success(let data):
                    self.boardDetail = data.result
                    self.anonymousCounter = 1 // Reset anonymous counter when loading new post details

                    self.comments = data.result.comments
                    self.isLoading = false
                case .failure(let error):
                    if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("Server Error Message: \(errorMessage)")
                    } else {
                        print("Error: \(error.localizedDescription)")
                    }
                    self.isLoading = false
                }
            }
    }

    // 프로필 데이터를 로드하는 함수
    func loadProfileData() {
        ProfileGetDataManager { profileModel in
            guard let profile = profileModel?.result else {
                print("프로필 데이터를 가져오지 못했습니다.")
                return
            }
            self.degreeLevel = DegreeLevel(rawValue: profile.degreeLevel ?? "")
        }
    }

    // ProfileGetDataManager 함수 정의
    func ProfileGetDataManager(completion: @escaping (ProfileModel?) -> Void) {
        let url = APIConstants.userMypage.path
        let headers: HTTPHeaders = [
            "Accept": "*/*"
        ]

        NetworkAuthManager.shared.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: ProfileModel.self) { response in
                switch response.result {
                case .success(let profileModel):
                    completion(profileModel)
                    print("성공. \(profileModel)")
                case .failure(let error):
                    print("에러 : \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

}

struct Comments: View {
    var comment: BoardComment
    @State private var showingCommentSheet = false
    @State private var showCommentAlert = false
    var degreeLevel: DegreeLevel? // 추가된 변수
    var isAuthor: Bool
    @Binding var showDeletionMessage: Bool
    @Binding var showCommentDeletionMessage: Bool
    var deleteComment: () -> Void
    
    // State to manage like status and count
    @State private var isLiked: Bool = false
    @State private var likeCount: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                // Display "글쓴이" instead of "익명1"
                Text(comment.anonymousName == "익명1" ? "글쓴이" : comment.anonymousName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Constants.Gray800)
                Divider()
                
                // DegreeLevel에 따른 학위 상태 표시
                if let degreeLevel = degreeLevel {
                    Text(degreeLevelText(degreeLevel))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Constants.Orange700)
                }
                
                Spacer()
                
                Button(action: {
                    print("댓글 더보기 버튼 tapped")
                    self.showingCommentSheet = true
                }) {
                    Image("MoreButton 1")
                        .resizable()
                        .frame(width: 12, height: 12)
                }
                .actionSheet(isPresented: $showingCommentSheet) {
                    if isAuthor {
                        return ActionSheet(
                            title: Text("댓글"),
                            buttons: [
                                .default(Text("수정하기")),
                                .destructive(Text("삭제하기"), action: {
                                    self.showCommentAlert = true
                                }),
                                .cancel(Text("취소"))
                            ]
                        )
                    } else {
                        return ActionSheet(
                            title: Text("댓글"),
                            buttons: [
                                .default(Text("신고하기")),
                                .cancel(Text("취소"))
                            ]
                        )
                    }
                }
                .alert(isPresented: $showCommentAlert) {
                    Alert(
                        title: Text("댓글 삭제하기"),
                        message: Text("댓글을 삭제할까요? 삭제 후 복구되지 않습니다."),
                        primaryButton: .destructive(Text("삭제할게요"), action: {
                            deleteComment()
                            showCommentDeletionMessage = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showCommentDeletionMessage = false
                            }
                            print("댓글 삭제됨")
                        }),
                        secondaryButton: .cancel(Text("닫기"))
                    )
                }
            }
            
            Text(formatDate(comment.createdDate))
                .font(.system(size: 10))
                .foregroundStyle(Constants.Gray500)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            HStack {
                Text(comment.content)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Constants.Gray900)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Spacer()
                
                // 댓글 좋아요 버튼
                Button(action: {
                    isLiked.toggle()
                    likeCount += isLiked ? 1 : -1
                }) {
                    Image(isLiked ? "LikeButton Fill" : "LikeButton")
                        .resizable()
                        .frame(width: 12, height: 12)
                }
                
                // 댓글 좋아요 수
                Text("\(likeCount)")
                    .font(
                        Font.custom("Pretendard", size: 10)
                            .weight(.regular)
                    )
                    .foregroundColor(isLiked ? Constants.Orange700 : Constants.Gray300)
            }
            
            Divider() // 댓글 구분선
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .frame(alignment: .topLeading)
        .background(Constants.White)
    }
    
    // DegreeLevel에 따른 텍스트 반환 함수
    func degreeLevelText(_ degreeLevel: DegreeLevel) -> String {
        switch degreeLevel {
        case .bachelorsStudying:
            return "학사 재학"
        case .bachelorsGraduated:
            return "학사 졸업"
        case .mastersStudying:
            return "석사 재학"
        case .mastersGraduated:
            return "석사 졸업"
        case .doctoralStudying:
            return "박사 재학"
        case .doctoralGraduated:
            return "박사 졸업"
        case .integratedStudying:
            return "통합과정 재학"
        }
    }
    
    // 날짜 형식을 'yyyy-MM-dd 작성'으로 변경하는 함수
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy.MM.dd 작성"
            return formatter.string(from: date)
        }
        return dateString // 변환이 실패하면 원래 문자열 반환
    }
}


struct WriteComment: View {
    @Binding var commentText: String
    @Binding var showValidationError: Bool
    var addComment: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    ZStack(alignment: .leading) {
                        if commentText.isEmpty {
                            Text("댓글을 남겨보세요!")
                                .foregroundColor(Color(Constants.Gray500))
                                .padding(.horizontal, 8)
                        }
                        TextField("댓글을 남겨보세요!", text: $commentText)
                            .padding()
                            .frame(height: 44)
                            .background(showValidationError && commentText.isEmpty ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100))
                            .cornerRadius(8, corners: [.topLeft, .topRight])
                            .overlay(
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(commentText.isEmpty ? Color(Constants.Gray300) : Color.blue)
                                    .padding(.top, 44)
                                    .padding(.horizontal, 8),
                                alignment: .bottom
                            )
                            .foregroundColor(showValidationError && commentText.isEmpty ? Color(red: 1, green: 0.29, blue: 0.29) : Color(Constants.Gray900))
                    }
                    Button(action: {
                        addComment()
                    }) {
                        Text("등록")
                            .font(.system(size: 16, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(commentText.isEmpty ? Constants.Gray500 : Constants.White)
                            .frame(width: 70, height: 44)
                            .background(commentText.isEmpty ? Color(Constants.Gray200) : Color(red: 0.93, green: 0.29, blue: 0.03))
                            .cornerRadius(8)
                    }
                }
            }
            .frame(alignment: .topLeading)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .frame(alignment: .topLeading)
        .background(Constants.White)
        .shadow(color: .black.opacity(0.15), radius: 3.5, x: 0, y: 0)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct BookmarkButtonView: View {
    @State private var isBookmarked: Bool = false
    var postId: Int // Post ID to be passed when toggling scrap status
    
    var body: some View {
        Button(action: {
            toggleScrapStatus()
        }) {
            Image(isBookmarked ? "BookmarkButton Fill" : "BookmarkButton")
                .resizable()
                .frame(width: 20, height: 20)
        }
        .onAppear {
            checkInitialScrapStatus()
        }
    }
    
    private func toggleScrapStatus() {
        let url = "\(APIConstants.baseURL)/scraps/\(postId)/toggle"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        NetworkAuthManager.shared.request(url, method: .post, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoardScrapModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        isBookmarked.toggle()
                        print("Scrap status toggled successfully: \(data.message)")
                    } else {
                        print("Failed to toggle scrap status: \(data.message)")
                    }
                case .failure(let error):
                    if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("Server Error Message: \(errorMessage)")
                    } else {
                        print("Error toggling scrap status: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    private func checkInitialScrapStatus() {
        let url = "\(APIConstants.baseURL)/scraps/\(postId)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        NetworkAuthManager.shared.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ScrapStatusResponse.self) { response in
                switch response.result {
                case .success(let data):
                    isBookmarked = data.isScrapped
                case .failure(let error):
                    print("Error checking scrap status: \(error.localizedDescription)")
                }
            }
    }
}

struct ScrapStatusResponse: Decodable {
    let isScrapped: Bool
}

#Preview {
    DummyBoardDetail(boardName: "질문 게시판", postId: 3, memberId: 10)
}

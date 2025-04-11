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
    @State var isAuthor = false
    var boardName: String
    @State private var showDeletionMessage = false
    @State private var showCommentDeletionMessage = false
    @State private var degreeLevel: DegreeLevel? = nil
    @State private var boardDetail: BoardDetailResult? = nil
    @State private var isLoading: Bool = true
    @State private var showMore = false
    @State private var isShowingEditView = false
    
    var postId: Int
    var memberId: Int?
    
    @State private var reportViewModel = ReportViewModel()
    
    @State private var comments: [BoardComment] = []
    @State private var anonymousCounter: Int = 1
    @State private var currentUserId: Int? = nil
    @State private var shouldReloadDetail: Bool = false
    
    @State private var isEditingCommentMode = false
    @State private var editingCommentId: Int? = nil
    
    @State private var selectedComment: BoardComment? = nil
    @State private var showCommentMoreView = false
    @State private var isReportingComment = false

    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: BoardEditViewController(
                    postId: postId,
                    originalTitle: boardDetail?.title ?? "",
                    originalContent: boardDetail?.content ?? "",
                    memberId: boardDetail?.memberId ?? 0,
                    currentUserId: currentUserId ?? 0,
                    boardName: boardDetail?.menu ?? "",
                    shouldReload: $shouldReloadDetail
                ), isActive: $isShowingEditView) {
                    EmptyView()
                }
                .onChange(of: shouldReloadDetail) { newValue in
                    if newValue {
                        loadBoardDetail(postId: postId)
                        shouldReloadDetail = false
                    }
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    VStack {
                        HStack {
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
                                showMore = true
                            }) {
                                Image("MoreButton")
                                    .frame(width: Constants.nav, height: Constants.nav)
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
                                            Comments(
                                                comment: comments[index],
                                                degreeLevel: degreeLevel,
                                                isAuthor: isAuthor,
                                                showDeletionMessage: $showDeletionMessage,
                                                showCommentDeletionMessage: $showCommentDeletionMessage,
                                                updateCommentCallback: { updatedContent in
                                                    comments[index].content = updatedContent
                                                },
                                                deleteComment: {
                                                    deleteComment(at: index)
                                                },
                                                currentUserId: currentUserId,
                                                onEditComment: { comment in
                                                    self.commentText = comment.content
                                                    self.editingCommentId = comment.commentId
                                                    self.isEditingCommentMode = true
                                                },
                                                onShowMore: { comment in
                                                    self.selectedComment = comment
                                                    self.showCommentMoreView = true
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                            
                            WriteComment(
                                commentText: $commentText,
                                showValidationError: $showValidationError,
                                addComment: addComment,
                                isEditing: isEditingCommentMode,
                                originalCommentText: comments.first(where: { $0.commentId == editingCommentId })?.content ?? ""
                            )
                        }
                    }
                }

                MoreButtonView(
                    isPresented: $showMore,
                    onEdit: {
                        print("수정하기 눌림")
                        isShowingEditView = true
                    },
                    onDelete: {
                        deletePost()
                    },
                    onReport: { reason in
                        print("신고 사유 선택됨: \(reason)")
                        // 예: 서버에 신고 요청 보내기
                        reportViewModel.loadReportPost(postId: postId, reason: reason)
                    },
                    boardName: boardName,
                    isAuthor: isAuthor // ← 작성자인지 여부 전달
                )
                
                // CommentButtonView 구현
                if let selectedComment = selectedComment {
                    CommentMoreButtonView(
                        isPresented: $showCommentMoreView,
                        onEdit: {
                            commentText = selectedComment.content
                            editingCommentId = selectedComment.commentId
                            isEditingCommentMode = true
                        },
                        onDelete: {
                            if let index = comments.firstIndex(where: { $0.commentId == selectedComment.commentId }) {
                                deleteComment(at: index)
                            }
                        },
                        onReport: { reason in
                            print("댓글 신고 사유 선택됨: \(reason)")
                            // 서버로 신고 요청 전송 처리 가능
                            if let index = comments.firstIndex(where: { $0.commentId == selectedComment.commentId }) {
                                reportViewModel.loadReportComment(commentId: index, reason: reason)
                            }
                        },
                        boardName: boardName,
                        isAuthor: selectedComment.memberId == currentUserId
                    )
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            DispatchQueue.main.async {
                loadBoardDetail(postId: postId)
                loadProfileData()
                // 작성자 판별을 위해 현재 사용자 memberId 조회
                fetchCurrentUserMemberId { currentUserId in
                    if let currentUserId = currentUserId, let boardAuthorId = boardDetail?.memberId {
                        self.isAuthor = (currentUserId == boardAuthorId)
                    }
                }
            }
        }
        .onAppear(perform: UIApplication.shared.hideKeyboard)
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
                        commentId: data.result.commentId,
                        anonymousName: data.result.nickname,
                        degreeLevel: "익명",
                        content: data.result.content,
                        createdDate: data.result.createdAt,
                        memberId: data.result.memberId // 댓글 수정은 해당 댓글 작성자만 가능하도록 memberId 추가
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
                    self.comments = data.result.comments
                    self.isLoading = false
                    
                    // 작성자 판별
                    fetchCurrentUserMemberId { currentUserId in
                        if let currentUserId = currentUserId {
                            self.currentUserId = currentUserId // ← 반드시 필요!
                            if let boardAuthorId = boardDetail?.memberId {
                                self.isAuthor = (currentUserId == boardAuthorId)
                            }
                        }
                    }

                case .failure(let error):
                    self.isLoading = false
                    print("게시물 로드 실패: \(error.localizedDescription)")
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
    func ProfileGetDataManager(completion: @escaping (PostProfileResponseDTO?) -> Void) {
        let url = APIConstants.userMypage.path
        let headers: HTTPHeaders = [
            "Accept": "*/*"
        ]

        NetworkAuthManager.shared.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: PostProfileResponseDTO.self) { response in
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

    func fetchCurrentUserMemberId(completion: @escaping (Int?) -> Void) {
        let token = KeychainHelper.standard.read(service: "access-token", account: "user") ?? ""
        let url = APIConstants.calendarMember.path
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]

        print("요청 URL: \(url)") // 디버깅용 로그

        NetworkAuthManager.shared.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CurrentUserResponse.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        completion(data.result.memberId)
                    } else {
                        print("사용자 정보 응답 실패: \(data.message)")
                        completion(nil)
                    }
                case .failure(let error):
                    print("사용자 정보 조회 에러: \(error.localizedDescription)")
                    if let data = response.data, let body = String(data: data, encoding: .utf8) {
                        print("응답 body: \(body)")
                    }
                    completion(nil)
                }
            }
    }
    
    func updateComment(commentId: Int, newContent: String) {
        let url = APIConstants.baseURL + "/comments/update"
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            print("토큰 없음")
            return
        }

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]

        let request = CommentUpdateRequest(commentId: commentId, content: newContent)

        NetworkAuthManager.shared.request(url, method: .put, parameters: request, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CommentUpdateResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("댓글 수정 성공: \(data.message)")
                    if let index = comments.firstIndex(where: { $0.commentId == commentId }) {
                        comments[index].content = newContent
                    }
                    commentText = ""
                    editingCommentId = nil
                    isEditingCommentMode = false
                    showValidationError = false
                case .failure(let error):
                    print("댓글 수정 실패: \(error.localizedDescription)")
                }
            }
    }
    
    func addComment() {
        if commentText.isEmpty {
            showValidationError = true
            return
        }

        if isEditingCommentMode, let commentId = editingCommentId {
            updateComment(commentId: commentId, newContent: commentText)
        } else {
            postComment(content: commentText)
        }
    }
}

struct Comments: View {
    var comment: BoardComment
    var degreeLevel: DegreeLevel?
    var isAuthor: Bool
    @Binding var showDeletionMessage: Bool
    @Binding var showCommentDeletionMessage: Bool
    var updateCommentCallback: (String) -> Void
    var deleteComment: () -> Void

    var currentUserId: Int? // 현재 로그인한 사용자 ID
    var onEditComment: ((BoardComment) -> Void)?
    var onShowMore: (BoardComment) -> Void

    var isCommentAuthor: Bool {
        return currentUserId == comment.memberId
    }

    @State private var isLiked: Bool = false
    @State private var likeCount: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Text(comment.anonymousName == "글쓴이" ? "글쓴이" : comment.anonymousName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Constants.Gray800)
                Divider()
                
                if let degreeLevel = degreeLevel {
                    Text(degreeLevelText(degreeLevel))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Constants.Orange700)
                }
                
                Spacer()
                
                Button(action: {
                    onShowMore(comment)
                }) {
                    Image("MoreButton 1")
                        .resizable()
                        .frame(width: 12, height: 12)
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
                
                Button(action: {
                    isLiked.toggle()
                    likeCount += isLiked ? 1 : -1
                }) {
                    Image(isLiked ? "LikeButton Fill" : "LikeButton")
                        .resizable()
                        .frame(width: 12, height: 12)
                }
                
                Text("\(likeCount)")
                    .font(Font.custom("Pretendard", size: 10).weight(.regular))
                    .foregroundColor(isLiked ? Constants.Orange700 : Constants.Gray300)
            }

            Divider()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .frame(alignment: .topLeading)
        .background(Constants.White)
    }

    func updateComment(commentId: Int, newContent: String) {
        let url = APIConstants.baseURL + "/comments/update"
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            print("토큰 없음")
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        let request = CommentUpdateRequest(commentId: commentId, content: newContent)
        
        NetworkAuthManager.shared.request(url, method: .put, parameters: request, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CommentUpdateResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("댓글 수정 성공: \(data.message)")
                    updateCommentCallback(data.result.content)
                case .failure(let error):
                    if let data = response.data,
                       let errorMessage = String(data: data, encoding: .utf8) {
                        print("서버 응답: \(errorMessage)")
                    } else {
                        print("댓글 수정 실패: \(error.localizedDescription)")
                    }
                }
            }
    }

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

    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy.MM.dd 작성"
            return formatter.string(from: date)
        }
        return dateString
    }
}

struct WriteComment: View {
    @Binding var commentText: String
    @Binding var showValidationError: Bool
    var addComment: () -> Void
    var isEditing: Bool
    var originalCommentText: String

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isEditing {
                Text("댓글 수정 중")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Constants.Orange700)
                    .padding(.bottom, 4)
                    .padding(.horizontal, 4)
            }

            HStack {
                ZStack(alignment: .leading) {
                    if commentText.isEmpty {
                        Text("댓글을 남겨보세요!")
                            .foregroundColor(Color(Constants.Gray500))
                            .padding(.horizontal, 8)
                    }

                    TextField("댓글을 남겨보세요!", text: $commentText)
                        .focused($isTextFieldFocused)
                        .padding()
                        .frame(height: 44)
                        .background(showValidationError && commentText.isEmpty ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100))
                        .cornerRadius(8, corners: [.topLeft, .topRight])
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(commentText.isEmpty ? Color(Constants.Gray300) : Constants.Orange700)
                                .padding(.top, 44)
                                .padding(.horizontal, 8),
                            alignment: .bottom
                        )
                        .foregroundColor(showValidationError && commentText.isEmpty ? Color(red: 1, green: 0.29, blue: 0.29) : Color(Constants.Gray900))
                }

                Button(action: {
                    addComment()
                }) {
                    Text(isEditing ? "수정" : "등록")
                        .font(.system(size: 16, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(
                            commentText.isEmpty || (isEditing && commentText == originalCommentText)
                            ? Constants.Gray500
                            : Constants.White
                        )
                        .frame(width: 70, height: 44)
                        .background(
                            commentText.isEmpty || (isEditing && commentText == originalCommentText)
                            ? Color(Constants.Gray200)
                            : Color(red: 0.93, green: 0.29, blue: 0.03)
                        )
                        .cornerRadius(8)
                }
                .disabled(commentText.isEmpty || (isEditing && commentText == originalCommentText))
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .background(Constants.White)
        .onChange(of: isEditing) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTextFieldFocused = true
                }
            }
        }
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
    var postId: Int // 현재 게시물의 postId

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
    
    // [POST] /api/scraps/{postId}/toggle
    private func toggleScrapStatus() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user"),
              !token.isEmpty else {
            print("토큰이 없습니다.")
            return
        }
        
        let url = "\(APIConstants.baseURL)/scraps/\(postId)/toggle"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
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
                    if let data = response.data,
                       let errorMessage = String(data: data, encoding: .utf8) {
                        print("Server Error Message: \(errorMessage)")
                    } else {
                        print("Error toggling scrap status: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    // [GET] /api/community/scrap-list
    private func checkInitialScrapStatus() {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user"),
              !token.isEmpty else {
            print("토큰이 없습니다.")
            return
        }
        
        let url = "\(APIConstants.baseURL)/community/scrap-list"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        NetworkAuthManager.shared.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoardScarppedModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        // 응답 result 배열의 게시물 ID(postId)를 확인
                        isBookmarked = data.result.contains { $0.postId == postId }
                    } else {
                        print("Scrap list fetch failed: \(data.message)")
                    }
                case .failure(let error):
                    print("Error checking scrap status: \(error.localizedDescription)")
                }
            }
    }
}

struct MoreButtonView: View {
    @Binding var isPresented: Bool
    var onEdit: () -> Void
    var onDelete: () -> Void
    var onReport: (String) -> Void // 신고 사유도 전달받도록 수정
    var boardName: String
    var isAuthor: Bool

    @State private var isReporting = false

    let reportReasons = [
        "욕설/비하",
        "유출/사칭/사기",
        "상업적 광고 및 판매",
        "음란물/불건전한 대화 및 만남",
        "게시판 주제에 부적절함",
        "정당/정치인 비하 및 선거운동",
        "낚시/도배"
    ]

    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                            isReporting = false
                        }
                    }

                VStack(spacing: 8) {
                    Spacer()

                    VStack(spacing: 0) {
                        // ✅ 타이틀: 일반모드 → 게시판 이름 / 신고모드 → 신고하기
                        Text(isReporting ? "신고하기" : boardName)
                            .font(.system(size: 13))
                            .foregroundColor(Color.gray.opacity(0.5))
                            .padding(.vertical, 16)

                        Divider()

                        if isAuthor {
                            // ✅ 작성자인 경우
                            Button(action: {
                                onEdit()
                                isPresented = false
                            }) {
                                Text("수정하기")
                                    .font(.system(size: 17))
                                    .foregroundColor(Constants.ColorsBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(17)
                            }

                            Divider()

//                            Button(action: {
//                                onDelete()
//                                isPresented = false
//                            }) {
//                                Text("삭제하기")
//                                    .font(.system(size: 17))
//                                    .foregroundColor(Constants.ColorsBlue)
//                                    .frame(maxWidth: .infinity)
//                                    .padding(17)
//                            }

                        } else if isReporting {
                            // ✅ 신고 사유 선택 화면
                            ForEach(reportReasons, id: \.self) { reason in
                                Button(action: {
                                    onReport(reason)
                                    isPresented = false
                                    isReporting = false
                                }) {
                                    Text(reason)
                                        .font(.system(size: 17))
                                        .foregroundColor(Constants.ColorsBlue)
                                        .frame(maxWidth: .infinity)
                                        .padding(17)
                                }

                                if reason != reportReasons.last {
                                    Divider()
                                }
                            }
                        } else {
                            // ✅ 신고하기 버튼
                            Button(action: {
                                withAnimation {
                                    isReporting = true
                                }
                            }) {
                                Text("신고하기")
                                    .font(.system(size: 17))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding(17)
                            }
                        }
                    }
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(14)
                    .padding(.horizontal, 8)

                    // 취소 버튼
                    Button(action: {
                        withAnimation {
                            if isReporting {
                                isReporting = false
                            } else {
                                isPresented = false
                            }
                        }
                    }) {
                        Text("취소")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Constants.ColorsBlue)
                            .frame(maxWidth: .infinity)
                            .padding(17)
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

struct CommentMoreButtonView: View {
    @Binding var isPresented: Bool
    var onEdit: () -> Void
    var onDelete: () -> Void
    var onReport: (String) -> Void // 신고 사유도 전달받도록 수정
    var boardName: String
    var isAuthor: Bool

    @State private var isReporting = false

    let reportReasons = [
        "욕설/비하",
        "유출/사칭/사기",
        "상업적 광고 및 판매",
        "음란물/불건전한 대화 및 만남",
        "게시판 주제에 부적절함",
        "정당/정치인 비하 및 선거운동",
        "낚시/도배"
    ]

    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                            isReporting = false
                        }
                    }

                VStack(spacing: 8) {
                    Spacer()

                    VStack(spacing: 0) {
                        // ✅ 타이틀: 일반모드 → 게시판 이름 / 신고모드 → 신고하기
                        Text(isReporting ? "신고하기" : boardName)
                            .font(.system(size: 13))
                            .foregroundColor(Color.gray.opacity(0.5))
                            .padding(.vertical, 16)

                        Divider()

                        if isAuthor {
                            // ✅ 작성자인 경우
                            Button(action: {
                                onEdit()
                                isPresented = false
                            }) {
                                Text("수정하기")
                                    .font(.system(size: 17))
                                    .foregroundColor(Constants.ColorsBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(17)
                            }

                            Divider()

//                            Button(action: {
//                                onDelete()
//                                isPresented = false
//                            }) {
//                                Text("삭제하기")
//                                    .font(.system(size: 17))
//                                    .foregroundColor(Constants.ColorsBlue)
//                                    .frame(maxWidth: .infinity)
//                                    .padding(17)
//                            }

                        } else if isReporting {
                            // ✅ 신고 사유 선택 화면
                            ForEach(reportReasons, id: \.self) { reason in
                                Button(action: {
                                    onReport(reason)
                                    isPresented = false
                                    isReporting = false
                                }) {
                                    Text(reason)
                                        .font(.system(size: 17))
                                        .foregroundColor(Constants.ColorsBlue)
                                        .frame(maxWidth: .infinity)
                                        .padding(17)
                                }

                                if reason != reportReasons.last {
                                    Divider()
                                }
                            }
                        } else {
                            // ✅ 신고하기 버튼
                            Button(action: {
                                withAnimation {
                                    isReporting = true
                                }
                            }) {
                                Text("신고하기")
                                    .font(.system(size: 17))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding(17)
                            }
                        }
                    }
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(14)
                    .padding(.horizontal, 8)

                    // 취소 버튼
                    Button(action: {
                        withAnimation {
                            if isReporting {
                                isReporting = false
                            } else {
                                isPresented = false
                            }
                        }
                    }) {
                        Text("취소")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Constants.ColorsBlue)
                            .frame(maxWidth: .infinity)
                            .padding(17)
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

struct ScrapStatusResponse: Decodable {
    let isScrapped: Bool
}

#Preview {
    DummyBoardDetail(boardName: "질문 게시판", postId: 3, memberId: 10)
}

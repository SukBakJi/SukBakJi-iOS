//
//  DummyBoardDetail.swift
//  Sukbakji
//
//  Created by KKM on 7/29/24.
//

//
//  DummyBoardDetail.swift
//  Sukbakji
//
//  Created by KKM on 7/29/24.
//

import SwiftUI
import Alamofire

struct Comment: Identifiable {
    let id = UUID()
    let author: String
    let content: String
    let date: String
    var isLiked: Bool
    var likeCount: Int
}

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
    
    @State private var boardDetail: BoardDetailResult? = nil // 게시물 데이터 상태 변수
    @State private var isLoading: Bool = true // 데이터 로딩 상태
    
    var postId: Int // 게시물 ID를 전달받는 변수
    
    // 댓글 데이터 상태 변수
    @State private var comments: [Comment] = []
    
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
                        }
                        
                        Divider()
                        
                        if let boardDetail = boardDetail {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(boardDetail.menu)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(red: 0.29, green: 0.45, blue: 1))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color(red: 0.91, green: 0.92, blue: 1))
                                        .cornerRadius(4)
                                    Spacer()
                                    BookmarkButtonView()
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
                            
                            ScrollView {
                                Rectangle()
                                    .frame(height: 8)
                                    .background(Constants.Gray100)
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    ForEach(comments) { comment in
                                        Comments(comment: comment, isAuthor: isAuthor, showDeletionMessage: $showDeletionMessage, showCommentDeletionMessage: $showCommentDeletionMessage)
                                            .padding(.horizontal, 24)
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
            loadBoardDetail(postId: postId) // 게시물 상세 정보를 로드합니다.
        }
    }

    // 댓글 추가 함수
    func addComment() {
        if commentText.isEmpty {
            showValidationError = true
        } else {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd 작성"
            let dateString = dateFormatter.string(from: currentDate)
            
            let newComment = Comment(author: "익명 \(comments.count + 1)", content: commentText, date: dateString, isLiked: false, likeCount: 0)
            comments.append(newComment)
            commentText = ""
            showValidationError = false
        }
    }
    
    // 게시글 상세 정보를 불러오는 함수
    func loadBoardDetail(postId: Int) {
//        guard let accessTokenData = KeychainHelper.standard.read(service: "access-token", account: "user"),
//              let accessToken = String(data: accessTokenData, encoding: .utf8), !accessToken.isEmpty else {
//            print("토큰이 없습니다.")
//            self.isLoading = false
//            return
//        }
        
        let url = APIConstants.boardpostURL + "/detail/\(postId)"
        
        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoardDetailModel.self) { response in
                switch response.result {
                case .success(let data):
                    self.boardDetail = data.result
                    self.comments = data.result.comments.map { comment in
                        Comment(
                            author: comment.anonymousName,
                            content: comment.content,
                            date: comment.createdDate,
                            isLiked: false,
                            likeCount: 0
                        )
                    }
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
}

struct Comments: View {
    @State var comment: Comment // Comment로 변경
    @State private var showingCommentSheet = false
    @State private var showCommentAlert = false
    var isAuthor: Bool
    @Binding var showDeletionMessage: Bool
    @Binding var showCommentDeletionMessage: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Text(comment.author)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Constants.Gray800)
                Divider()
                
                Text("박사 재학")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Constants.Orange700)
                
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
            
            Text(comment.date)
                .font(.system(size: 10))
                .foregroundStyle(Constants.Gray500)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Text(comment.content)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .frame(alignment: .topLeading)
        .background(Constants.White)
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
    
    var body: some View {
        Button(action: {
            isBookmarked.toggle()
            isBookmarked ? print("북마크 완료") : print("북마크 해제")
        }) {
            Image(isBookmarked ? "BookmarkButton Fill" : "BookmarkButton")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    DummyBoardDetail(boardName: "질문 게시판", postId: 1)
}

//
//  DummyBoardDetail.swift
//  Sukbakji
//
//  Created by KKM on 7/29/24.
//

import SwiftUI

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
    
    // 댓글 데이터 상태 변수
    @State private var comments: [Comment] = [
        Comment(author: "익명 1", content: "무는 깨끗이 씻은 후 지저분한 부분만 필러로 제거한 후 1~1.5cm 두께로 썰어 4등분 해주세요.", date: "2024.07.19 작성", isLiked: false, likeCount: 1)
    ]
    
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
                        
                        Text(boardName) // 전달받은 게시판 이름으로 변경
                            .font(.system(size: 20, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Constants.Gray900)
                        
                        Spacer()
                        
                        // 더보기 버튼
                        Button(action: {
                            print("게시물 더보기 버튼 tapped")
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
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(alignment: .center, spacing: 10) {
                            Text("박사 게시판")
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
                        
                        Text("아삭아삭 석박지")
                            .padding(.top, 12)
                            .padding(.bottom, 8)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Constants.Gray900)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("무를 큼직하게 썰어 양념에 버무린 섞박지는 국밥, 설렁탕 등 맑은 국물이 있는 요리와 찰떡처럼 어울리죠. 달고 아삭아삭한 무가 양념과 환상적으로 어우진답니다. 특히 무를 큼직하게 썰어 식감이 좋은 게 특징이에요. 그냥 따뜻한 밥 위에 올려 먹어도 좋고, 뜨끈한 국물 요리와 함께 먹어도 좋답니다.")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Constants.Gray900)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        HStack(alignment: .top, spacing: 12) {
                            Image("chat 1")
                                .resizable()
                                .frame(width: 12, height: 12)
                            
                            Text("\(comments.count)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(red: 0.29, green: 0.45, blue: 1))
                            
                            Image("eye")
                                .resizable()
                                .frame(width: 12, height: 12)
                            
                            Text("1532")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                        }
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .frame(alignment: .topTrailing)
                    .background(Constants.White)
                    
                    ScrollView {
                        Rectangle()
                            .frame(height: 8)
                            .background(Constants.Gray100)
                            .foregroundStyle(Constants.Gray100)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(comments) { comment in
                                Comments(comment: comment, isAuthor: isAuthor, showDeletionMessage: $showDeletionMessage, showCommentDeletionMessage: $showCommentDeletionMessage)
                                    .padding(.horizontal, 24)
                            }
                        }
                    }
                    
                    WriteComment(commentText: $commentText, showValidationError: $showValidationError, addComment: addComment)
                }
                
                // Custom Alert View
                if showAlert {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 16) {
                        Text("게시물 삭제하기")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Constants.Gray900)
                        
                        Text("게시물을 삭제할까요? 삭제 후 복구되지 않습니다.")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Constants.Gray800)
                            .frame(alignment: .topLeading)
                        
                        HStack {
                            Button(action: {
                                showAlert = false
                            }) {
                                Text("닫기")
                                    .padding(.horizontal, 28)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 16, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .background(Color(Constants.Gray200))
                                    .foregroundColor(Constants.Gray900)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                showAlert = false
                                showDeletionMessage = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showDeletionMessage = false
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                print("게시물 삭제됨")
                            }) {
                                Text("삭제할게요")
                                    .padding(.horizontal, 28)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 16, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .background(Color(red: 0.93, green: 0.29, blue: 0.03))
                                    .foregroundColor(Constants.White)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 48)
                    .padding(.vertical, 24)
                    .background(Constants.White)
                    .cornerRadius(12)
                    .shadow(radius: 8)
                }
                
                if showDeletionMessage {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            Image("CheckBox")
                                .resizable()
                                .frame(width: 18, height: 18)
                            
                            Text("해당 게시물이 삭제되었습니다")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Constants.White)
                        }
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(8)
                    }
                    .transition(.opacity)
                    .animation(.easeInOut)
                }
                
                if showCommentDeletionMessage {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            Image("CheckBox")
                                .resizable()
                                .frame(width: 18, height: 18)
                            
                            Text("댓글이 삭제되었습니다")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Constants.White)
                        }
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(8)
                    }
                    .transition(.opacity)
                    .animation(.easeInOut)
                }
            }
        }
        .navigationBarBackButtonHidden()
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
}

struct Comments: View {
    @State var comment: Comment
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
            
            HStack(alignment: .center, spacing: 4) {
                Button(action: {
                    comment.isLiked.toggle()
                    if comment.isLiked {
                        comment.likeCount += 1
                    } else {
                        comment.likeCount -= 1
                    }
                }) {
                    Image(comment.isLiked ? "LikeButton Fill" : "LikeButton")
                        .resizable()
                        .frame(width: 12, height: 12)
                }
                
                Text("\(comment.likeCount)")
                    .font(.system(size: 10))
                    .foregroundStyle(comment.isLiked ? Color(red: 0.93, green: 0.29, blue: 0.03) : Constants.Gray300)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
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
    DummyBoardDetail(boardName: "질문 게시판")
}

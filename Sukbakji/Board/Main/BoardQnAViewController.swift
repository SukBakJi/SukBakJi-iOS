//
//  BoardQnAViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/25/24.
//

import SwiftUI

struct BoardQnABoardViewController: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showAlert: Bool = false
    @State private var showBookmarkAlert: Bool = false
    @State private var showingSheet = false
    @State private var isAuthor = true // 작성자인지 여부를 나타내는 상태 변수
    @State private var isBookmarked = false // 즐겨찾기 상태를 나타내는 변수
    @State private var showBookmarkOverlay = false // 즐겨찾기 오버레이 표시 상태 변수
    @State private var bookmarkOverlayMessage = "" // 오버레이 메시지
    @State private var showAnonymousMessage = false // 익명 메시지 표시 상태 변수
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        // 뒤로가기 버튼
                        Button(action: {
                            // 뒤로가기 버튼 클릭 시 동작할 코드
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
                            // 더보기 버튼 클릭 시 동작할 코드
                            print("더보기 버튼 tapped")
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
                    
                    ScrollView {
                        // 공지사항 글
                        noticeView(showAlert: $showAlert)
                        
                        // 게시판 글 목록
                        ForEach(0..<8, id: \.self) { _ in
                            Board(boardName: "질문 게시판")
                        }
                    }
                    .overlay(
                        overlayButton(selectedButton: "질문 게시판")
                            .padding(.trailing, 24) // 오른쪽 여백
                            .padding(.bottom, 48) // 아래 여백
                        , alignment: .bottomTrailing // 오른쪽 아래에 위치
                    )
                }
                
                if showAlert {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 16) {
                        Text("공지")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Constants.Gray900)
                        
                        Text("게시판 내 개인정보 유추 금지와 관련하여 안내드립니다")
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
                    VStack() {
                        Spacer()
                        Text("익명으로 함께 소통해 보세요!")
                            .font(.system(size: 12, weight: .medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 11)
                            .background(Color(red: 1, green: 0.34, blue: 0.08))
                            .foregroundColor(Constants.White)
                            .cornerRadius(6)
                        
                        Spacer().frame(height: 59)
                    }
                    .padding(.bottom, 55)
                    .padding(.leading, 180)
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
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Constants.Orange400)
                    
                    Divider()
                        .background(Constants.Gray400)
                        .padding(.horizontal, 8.8)
                    
                    Text("게시판 내 개인정보 유추 금지와 관련하여 안내드립니다")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Constants.Gray800)
                        .frame(alignment: .topLeading)
                }
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
    }
}

#Preview {
    BoardQnABoardViewController()
}

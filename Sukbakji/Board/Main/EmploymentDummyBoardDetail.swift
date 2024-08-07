//
//  EmploymentDummyBoardDetail.swift
//  Sukbakji
//
//  Created by KKM on 7/31/24.
//

import SwiftUI

struct EmploymentDummyBoardDetail: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var commentText: String = ""
    @State private var showValidationError: Bool = false
    @State var showingSheet = false
    @State var showAlert = false
    @State var isAuthor = true // 작성자인지 여부를 나타내는 상태 변수
    @State private var showDeletionMessage = false
    @State private var showCommentDeletionMessage = false

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
                        
                        Text("취업후기 게시판")
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
                                    title: Text("질문 게시판"),
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
                                    title: Text("질문 게시판"),
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
                            Text("신입")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(red: 1, green: 0.75, blue: 0))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color(red: 1, green: 0.97, blue: 0.87))
                                .cornerRadius(4)
                            Text("기획·전략")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Constants.Gray500)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Constants.Gray50)
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
                            
                            Text("4")
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
                    .background(Constants.White)
                    
                    ScrollView {
                        Rectangle()
                            .frame(height: 8)
                            .background(Constants.Gray100)
                            .foregroundStyle(Constants.Gray100)
                        
                        Comments(isAuthor: isAuthor, showDeletionMessage: $showDeletionMessage, showCommentDeletionMessage: $showCommentDeletionMessage)
                        Divider()
                            .padding(.horizontal, 24)
                        
                        Comments(isAuthor: isAuthor, showDeletionMessage: $showDeletionMessage, showCommentDeletionMessage: $showCommentDeletionMessage)
                    }

                    
                    WriteComment(commentText: $commentText, showValidationError: $showValidationError)
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
                            Image("Checkbox")
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
                            Image("Checkbox")
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
}



#Preview {
    EmploymentDummyBoardDetail()
}


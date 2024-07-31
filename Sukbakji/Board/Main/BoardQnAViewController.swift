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
    
    var body: some View {
        NavigationView {
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
                    }) {
                        Image("MoreButton")
                            .frame(width: Constants.nav, height: Constants.nav)
                    }
                }
                
                Divider()
                
                ScrollView {
                    // 공지사항 글
                    noticeView(showAlert: $showAlert)
                    
                    // 게시판 글 목록
                    Board()
                    Board()
                    Board()
                    Board()
                    Board()
                    Board()
                    Board()
                    Board()
                }
                .overlay(
                    overlayButton()
                        .padding(.trailing, 24) // 오른쪽 여백
                        .padding(.bottom, 48) // 아래 여백
                    , alignment: .bottomTrailing // 오른쪽 아래에 위치
                )
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("공지"),
                    message: Text("게시판 내 개인정보 유추 금지와 관련하여 안내드립니다"),
                    dismissButton: .default(Text("확인했어요"))
                )
            }
        }
        .navigationBarBackButtonHidden()
    }
}


struct Board: View {
    var body: some View {
        VStack {
            Button(action: {
                print("질문 게시글 tapped")
            }) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("아삭아삭 석박지")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Constants.Gray900)
                    
                    Text("무를 큼직하게 썰어 양념에 버무린 섞박지는 국밥, 설렁탕 등...")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Constants.Gray900)
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image("chat-dots 1")
                            .resizable()
                            .frame(width: 12, height: 12)
                        
                        Text("12")
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
                .padding(.horizontal, 18) // VStack 내부 좌우 여백
                .padding(.vertical, 16)
                .background(Constants.White)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Constants.Gray300, lineWidth: 1) // 원래 색상 Gray100
                )
                .padding(.horizontal, 24) // 사각형 바깥쪽 좌우 여백을 24로 지정
            }
        }
    }
}


struct overlayButton: View {
    var body: some View {
        Button(action: {
            // 버튼 클릭 시 동작할 코드를 여기에 작성합니다.
            print("글쓰기 버튼 tapped!")
        }) {
            NavigationLink(destination: BoardWriteBoardViewController()) {
                ZStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .background(.clear)
                        .foregroundStyle(Color(Constants.Orange700))
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
                    
                    Image("edit 1")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(PlainButtonStyle()) // 버튼의 기본 스타일을 제거합니다.
            }
        }
    }
}

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


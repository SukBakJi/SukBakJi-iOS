//
//  HotBoardViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/27/24.
//

import SwiftUI

struct HotBoardViewController: View {
    
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
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("공지"),
                    message: Text("스크랩 20개 이상 또는 조회수 100회 이상인 게시글의 경우 HOT 게시판에 선정되어 게시됩니다"),
                    dismissButton: .default(Text("확인했어요"))
                )
            }
        }
        .navigationBarBackButtonHidden()
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

#Preview {
    HotBoardViewController()
}

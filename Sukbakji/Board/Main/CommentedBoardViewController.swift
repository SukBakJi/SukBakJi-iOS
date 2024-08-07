//
//  CommentedBoardViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/27/24.
//

import SwiftUI

struct CommentedBoardViewController: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var hasCommentedPosts: Bool = true // State variable to track if there are written posts
    
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
                    
                    Text("댓글 단 글")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.Gray900)
                    
                    Spacer()
                    
                    // 더보기 버튼
                    Image("")
                        .frame(width: Constants.nav, height: Constants.nav)
                    
                }
                
                Divider()
                
                if hasCommentedPosts {
                    ScrollView {
                        // 게시판 글 목록
                        ContainerDummyBoard(boardName: "댓글 단 글")
                        ContainerDummyBoard(boardName: "댓글 단 글")
                        ContainerDummyBoard(boardName: "댓글 단 글")
                        ContainerDummyBoard(boardName: "댓글 단 글")
                    }
                } else {
                    VStack {
                        Spacer()
                        
                        EmptyCommentedBoard()
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct EmptyCommentedBoard: View {
    var body: some View {
        VStack {
            Text("아직 댓글을 단 게시물이 없어요")
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Constants.Gray500)
                .padding(.bottom, 8)
            
            Text("게시판을 탐색하고 석박지 커뮤니티에서 소통해 보세요!")
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.Gray500)
            
        }
    }
}
#Preview {
    CommentedBoardViewController()
}

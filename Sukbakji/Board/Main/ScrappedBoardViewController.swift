//
//  ScrappedBoardViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/27/24.
//

import SwiftUI

struct ScrappedBoardViewController: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var hasScrappedPosts: Bool = true // State variable to track if there are written posts
    
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
                    
                    Text("스크랩")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.Gray900)
                    
                    Spacer()
                    
                    // 더보기 버튼
                    Image("")
                        .frame(width: Constants.nav, height: Constants.nav)
                    
                }
                
                Divider()
                
                if hasScrappedPosts {
                    ScrollView {
                        // 게시판 글 목록
                        ContainerDummyBoard(boardName: "스크랩")
                        ContainerDummyBoard(boardName: "스크랩")
                        ContainerDummyBoard(boardName: "스크랩")
                        ContainerDummyBoard(boardName: "스크랩")
                    }
                } else {
                    VStack {
                        Spacer()
                        
                        EmptyScrappedBoard()
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct EmptyScrappedBoard: View {
    var body: some View {
        VStack {
            Text("아직 스크랩한 게시물이 없어요")
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
    ScrappedBoardViewController()
}

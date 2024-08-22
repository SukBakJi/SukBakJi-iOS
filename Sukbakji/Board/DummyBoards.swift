//
//  DummyBoards.swift
//  Sukbakji
//
//  Created by KKM on 8/7/24.
//

import SwiftUI

struct BoardsItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: String
    let views: Int
    let comments: Int
}

let dummyBoardData = [
    BoardsItem(title: "아삭아삭 석박지", description: "무를 큼직하게 썰어 양념에 버무린 섞박지는 국밥, 설렁탕 등...", category: "질문 게시판", views: 1532, comments: 12),
    BoardsItem(title: "맛있는 김치", description: "김치를 맛있게 만드는 방법은...", category: "취업후기 게시판", views: 1042, comments: 8)
]

let employmentDummyBoardData = [
    BoardsItem(title: "회사 생활 후기", description: "회사 생활을 하면서 겪은 이야기들...", category: "취업후기 게시판", views: 530, comments: 15)
]

let containerDummyBoardData = [
    BoardsItem(title: "대학원 생활", description: "대학원 생활을 하면서 느낀 점들...", category: "대학원생활", views: 820, comments: 20)
]

// MARK: -- 최신 질문글 더미 게시판
struct Board: View {
    var boardName: String
    var title: String // 게시글 제목
    var content: String // 게시글 내용
    var commentCount: Int // 댓글 수
    var views: Int // 조회 수
    
    var body: some View {
        NavigationLink(destination: DummyBoardDetail(boardName: boardName, postId: 1, memberId: 10)) { // Replaced missing parameters with placeholders
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Constants.Gray900)
                
                Text(content)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Constants.Gray900)
                    .lineLimit(2)
                
                HStack(alignment: .center, spacing: 12) {
                    Image("chat 1")
                        .resizable()
                        .frame(width: 12, height: 12)
                    
                    Text("\(commentCount)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.29, green: 0.45, blue: 1))
                    
                    Image("eye")
                        .resizable()
                        .frame(width: 12, height: 12)
                    
                    Text("\(views)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                }
                .frame(maxWidth: .infinity, alignment: .topTrailing)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(Constants.White)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: 0.5)
                    .stroke(Constants.Gray300, lineWidth: 1)
            )
            .padding(.horizontal, 24)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: -- 게시판 메인화면 더미 게시판
struct ContainerDummyBoard: View {
    var boardName: String
    
    var body: some View {
        NavigationLink(destination: DummyBoardDetail(boardName: boardName, postId: 3, memberId: 10)) {
            VStack(alignment: .leading, spacing: 12) {
                
                HStack(alignment: .center, spacing: 10) {
                    HStack {
                        Text("박사 게시판")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.29, green: 0.45, blue: 1))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(red: 0.91, green: 0.92, blue: 1))
                    .cornerRadius(4)
                    
                    HStack {
                        Text("대학원생활")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Constants.Gray500)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Constants.Gray50)
                    .cornerRadius(4)
                }
                
                Text("아삭아삭 석박지")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Constants.Gray900)
                
                Text("무를 큼직하게 썰어 양념에 버무린 섞박지는 국밥, 설렁탕 등...")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Constants.Gray900)
                
                HStack(alignment: .top, spacing: 12) {
                    Image("chat 1")
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
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(Constants.White)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: 0.5)
                    .stroke(Constants.Gray300, lineWidth: 1)
            )
            .padding(.horizontal, 24)
        }
    }
}

// MARK: -- 더미 게시판
struct dummyBoard: View {
    var boardName: String
    
    var body: some View {
        NavigationLink(destination: DummyBoardDetail(boardName: boardName, postId: 1, memberId: 10)) {
            VStack(alignment: .leading, spacing: 12) {
                Text("아삭아삭 석박지")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Constants.Gray900)
                
                Text("무를 큼직하게 썰어 양념에 버무린 섞박지는 국밥, 설렁탕 등...")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Constants.Gray900)
                
                HStack(alignment: .top, spacing: 12) {
                    Image("chat 1")
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
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(Constants.White)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: 0.5)
                    .stroke(Constants.Gray300, lineWidth: 1)
            )
        }
    }
}

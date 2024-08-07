//
//  DummyBoards.swift
//  Sukbakji
//
//  Created by KKM on 8/7/24.
//

import SwiftUI

struct BoardItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: String
    let views: Int
    let comments: Int
}

let dummyBoardData = [
    BoardItem(title: "아삭아삭 석박지", description: "무를 큼직하게 썰어 양념에 버무린 섞박지는 국밥, 설렁탕 등...", category: "질문 게시판", views: 1532, comments: 12),
    BoardItem(title: "맛있는 김치", description: "김치를 맛있게 만드는 방법은...", category: "취업후기 게시판", views: 1042, comments: 8)
]

let employmentDummyBoardData = [
    BoardItem(title: "회사 생활 후기", description: "회사 생활을 하면서 겪은 이야기들...", category: "취업후기 게시판", views: 530, comments: 15)
]

let containerDummyBoardData = [
    BoardItem(title: "대학원 생활", description: "대학원 생활을 하면서 느낀 점들...", category: "대학원생활", views: 820, comments: 20)
]


// MARK: -- 게시판 메인화면 더미 게시판
struct ContainerDummyBoard: View {
    var boardName: String // 게시판 이름을 전달받는 변수
    
    var body: some View {
        VStack {
            Button(action: {
                print("내가 쓴 게시물 tapped")
            }) {
                NavigationLink(destination: DummyBoardDetail(boardName: boardName)) {
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
                    .padding(.horizontal, 18) // VStack 내부 좌우 여백
                    .padding(.vertical, 16)
                    .background(Constants.White)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: 0.5)
                            .stroke(Constants.Gray300, lineWidth: 1) // 원래 색상 Gray100
                    )
                    .padding(.horizontal, 24)
                } // 사각형 바깥쪽 좌우 여백을 24로 지정
            }
        }
    }
}

// MARK: -- 더미 게시판
struct dummyBoard: View {
    var boardName: String // 게시판 이름을 전달받는 변수
    
    var body: some View {
        Button(action: {
            print("\(boardName) 게시글 tapped")
        }) {
            NavigationLink(destination: DummyBoardDetail(boardName: boardName)) {
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
                .padding(.horizontal, 18) // VStack 내부 좌우 여백
                .padding(.vertical, 16)
                .background(Constants.White)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Constants.Gray300, lineWidth: 1) // 원래 색상 Gray100
                )
            }
        }
    }
}

// MARK: -- 취업후기 더미 게시판
struct EmploymentDummyBoard: View {
    var body: some View {
        Button(action: {
            print("게시물 tapped")
        }) {
            NavigationLink(destination: EmploymentDummyBoardDetail()) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .center, spacing: 10) {
                        HStack {
                            Text("신입")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(red: 1, green: 0.75, blue: 0))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(red: 1, green: 0.97, blue: 0.87))
                        .cornerRadius(4)
                        
                        HStack {
                            Text("기획·전략")
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
            }
        }
    }
}

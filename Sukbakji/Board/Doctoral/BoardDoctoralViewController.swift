//
//  BoardDoctoralViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/25/24.
//

import SwiftUI

struct BoardDoctoralViewController: View {
    
    @State private var searchText: String = "" // 검색 텍스트 상태 변수
    @State private var selectedButton: String? = "질문 게시판" // 기본값을 '질문 게시판'으로 설정
    
    var body: some View {
        ScrollView {
            VStack {
                // 검색 바
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8) // 아이콘 왼쪽 여백
                    
                    TextField("게시판에서 궁금한 내용을 검색해 보세요!", text: $searchText)
                        .font(.system(size: 14))
                        .textFieldStyle(PlainTextFieldStyle()) // 테두리 없는 스타일
                        .padding(.vertical, 4)
                        .padding(.leading, 12)
                }
                .padding(.horizontal, 16) // 좌우 여백 추가
                .padding(.vertical, 12)
                .background(Constants.Gray50) // 밝은 회색 배경색
                .cornerRadius(8) // 모서리 둥글게
                
                Spacer()
                
                // 가로 스크롤 뷰
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        BoardButton(text: "질문 게시판", isSelected: selectedButton == "질문 게시판") {
                            selectedButton = "질문 게시판"
                        }
                        BoardButton(text: "취업후기 게시판", isSelected: selectedButton == "취업후기 게시판") {
                            selectedButton = "취업후기 게시판"
                        }
                        BoardButton(text: "대학원생활 게시판", isSelected: selectedButton == "대학원생활 게시판") {
                            selectedButton = "대학원생활 게시판"
                        }
                        BoardButton(text: "연구주제 게시판", isSelected: selectedButton == "연구주제 게시판") {
                            selectedButton = "연구주제 게시판"
                        }
                    }
                    .font(.system(size: 12, weight: .medium))
                    .padding(.top, 8)
                }
                
                // 선택된 게시판에 따라 다른 뷰 표시
                VStack {
                    switch selectedButton {
                    case "질문 게시판":
                        DoctoralQnABoard()
                    case "취업후기 게시판":
                        DoctoralReviewBoard()
                    case "대학원생활 게시판":
                        DoctoralLifeBoard()
                    case "연구주제 게시판":
                        DoctoralResearchBoard()
                    default:
                        Text("여기에 컨텐츠를 추가하세요")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            
        }
        .overlay(
            overlayButton()
                .padding(.trailing, 24)
                .padding(.bottom, 48)
            ,alignment: .bottomTrailing
        )
        
    }
}

// 게시판 버튼 뷰
struct BoardButton: View {
    var text: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? Color(red: 0.98, green: 0.31, blue: 0.06) : Constants.Gray500)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color(red: 0.99, green: 0.91, blue: 0.9) : Constants.Gray50)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Constants.Gray200 : Color.clear, lineWidth: 1)
                )
        }
    }
}

// 더미 게시판
struct dummyBoard: View {
    var body: some View {
        Button(action: {
            print("질문 게시판 게시물 tapped")
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
        }
    }
}

// 각 게시판에 대한 뷰
struct DoctoralQnABoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("질문 게시판")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard()
        dummyBoard()
        dummyBoard()
    }
}

struct DoctoralReviewBoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("취업후기 게시판")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard()
        dummyBoard()
        dummyBoard()
    }
}

struct DoctoralLifeBoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("대학원생활 게시판")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard()
        dummyBoard()
        dummyBoard()
    }
}

struct DoctoralResearchBoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("연구주제 게시판")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard()
        dummyBoard()
        dummyBoard()
    }
}



#Preview {
    BoardDoctoralViewController()
}

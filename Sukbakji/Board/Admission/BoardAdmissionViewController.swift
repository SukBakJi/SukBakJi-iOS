//
//  BoardAdmissionViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/25/24.
//

import SwiftUI

struct BoardAdmissionViewController: View {
    
    @State private var searchText: String = "" // 검색 텍스트 상태 변수
    @State private var selectedButton: String? = "질문 게시판" // 기본값을 '질문 게시판'으로 설정
    @State private var isSearchActive: Bool = false // 검색 바 클릭 상태 변수
    
    var body: some View {
        ScrollView {
            VStack {
                // 검색 바
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8) // 아이콘 왼쪽 여백
                    
                    Text("게시판에서 궁금한 내용을 검색해 보세요!")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.leading, 12)
                        .onTapGesture {
                            isSearchActive = true
                        }
                }
                .padding(.horizontal, 16) // 좌우 여백 추가
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Constants.Gray50) // 밝은 회색 배경색
                .cornerRadius(8) // 모서리 둥글게
                
                Spacer()
                
                // 가로 스크롤 뷰
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        BoardButton(text: "질문 게시판", isSelected: selectedButton == "질문 게시판") {
                            selectedButton = "질문 게시판"
                        }
                        BoardButton(text: "석사합격 후기", isSelected: selectedButton == "석사합격 후기") {
                            selectedButton = "석사합격 후기"
                        }
                        BoardButton(text: "학부연구생 게시판", isSelected: selectedButton == "학부연구생 게시판") {
                            selectedButton = "학부연구생 게시판"
                        }
                        BoardButton(text: "석사지원 게시판", isSelected: selectedButton == "석사지원 게시판") {
                            selectedButton = "석사지원 게시판"
                        }
                        BoardButton(text: "석박사통합지원 게시판", isSelected: selectedButton == "석박사통합지원 게시판") {
                            selectedButton = "석박사통합지원 게시판"
                        }
                    }
                    .font(.system(size: 12, weight: .medium))
                    .padding(.top, 8)
                }
                
                // 선택된 게시판에 따라 다른 뷰 표시
                VStack {
                    switch selectedButton {
                    case "질문 게시판":
                        AdmissionQnABoard()
                    case "석사합격 후기":
                        AdmissionMasterReviewBoard()
                    case "학부연구생 게시판":
                        AdmissionStudentBoard()
                    case "석사지원 게시판":
                        AdmissionMasterBoard()
                    case "석박사통합지원 게시판":
                        AdmissionIntegrationBoard()
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
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isSearchActive) {
            SearchViewController(boardName: selectedButton ?? "게시판")
        }
    }
}

// 각 게시판에 대한 뷰
// 입학예정 탭 질문 게시판
struct AdmissionQnABoard: View {
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
        
        dummyBoard(boardName: "질문 게시판")
        dummyBoard(boardName: "질문 게시판")
        dummyBoard(boardName: "질문 게시판")
    }
}

// 석사합격 후기
struct AdmissionMasterReviewBoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("석사합격 후기")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard(boardName: "석사합격 후기")
        dummyBoard(boardName: "석사합격 후기")
        dummyBoard(boardName: "석사합격 후기")
    }
}

// 학부연구생 게시판
struct AdmissionStudentBoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("학부연구생 게시판")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard(boardName: "학부연구생 게시판")
        dummyBoard(boardName: "학부연구생 게시판")
        dummyBoard(boardName: "학부연구생 게시판")
    }
}

// 석사지원 게시판
struct AdmissionMasterBoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("석사지원 게시판")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard(boardName: "석사지원 게시판")
        dummyBoard(boardName: "석사지원 게시판")
        dummyBoard(boardName: "석사지원 게시판")
    }
}

// 석박사통합지원 게시판
struct AdmissionIntegrationBoard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("석박사통합지원 게시판")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        dummyBoard(boardName: "석박사통합지원 게시판")
        dummyBoard(boardName: "석박사통합지원 게시판")
        dummyBoard(boardName: "석박사통합지원 게시판")
    }
}


#Preview {
    BoardAdmissionViewController()
}

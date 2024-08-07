import SwiftUI

struct BoardDoctoralViewController: View {
    
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
            overlayButton(selectedButton: selectedButton)
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
// MARK: -- 박사 질문 게시판
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
        
        dummyBoard(boardName: "질문 게시판")
        dummyBoard(boardName: "질문 게시판")
        dummyBoard(boardName: "질문 게시판")
    }
}

// MARK: -- 박사 합격후기 게시판
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
        
        EmploymentDummyBoard()
        EmploymentDummyBoard()
        EmploymentDummyBoard()
    }
}

// MARK: -- 박사 대학원생활 게시판
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
        
        dummyBoard(boardName: "대학원생활 게시판")
        dummyBoard(boardName: "대학원생활 게시판")
        dummyBoard(boardName: "대학원생활 게시판")
    }
}

// MARK: -- 박사 연구주제 게시판
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
        
        dummyBoard(boardName: "연구주제 게시판")
        dummyBoard(boardName: "연구주제 게시판")
        dummyBoard(boardName: "연구주제 게시판")
    }
}

#Preview {
    BoardDoctoralViewController()
}


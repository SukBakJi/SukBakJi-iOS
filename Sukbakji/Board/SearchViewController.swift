//
//  SearchViewController.swift
//  Sukbakji
//
//  Created by KKM on 8/7/24.
//

import SwiftUI

struct SearchViewController: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""
    @State private var hasSearchResults: Bool = true // 검색 결과 상태 변수
    var boardName: String
    @State private var filteredResults: [BoardItem] = [] // 검색 결과를 저장할 상태 변수
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image("Search")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    TextField("제목과 내용을 자유롭게 검색해 보세요", text: $searchText, onCommit: {
                        // 검색 로직 추가
                        performSearch()
                    })
                        .padding(.leading, 12)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Constants.Gray900)
                    
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Constants.Gray50)
                .cornerRadius(12)
                
                Button("취소") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Constants.Gray800)
                .padding(.leading, 10)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            
            ScrollView {
                if !searchText.isEmpty && filteredResults.isEmpty {
                    // 검색 결과가 없을 때의 뷰
                    VStack(alignment: .center, spacing: 8) {
                        Image("Warning")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(.bottom, 17)
                        
                        Text("\(searchText)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
                        + Text("에 대한\n검색 결과가 없어요")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Constants.Gray900)
                        
                        Spacer()
                    }
                    .padding(.vertical, 144)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if !filteredResults.isEmpty {
                    // 검색 결과가 있을 때의 뷰
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(filteredResults) { item in
                            VStack(alignment: .leading, spacing: 12) {
                                Text(item.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Constants.Gray900)
                                
                                Text(item.description)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(Constants.Gray900)
                                
                                HStack(alignment: .top, spacing: 12) {
                                    Image("chat 1")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    
                                    Text("\(item.comments)")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(red: 0.29, green: 0.45, blue: 1))
                                    
                                    Image("eye")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    
                                    Text("\(item.views)")
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
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                } else {
                    // 초기 상태의 뷰
                    VStack(alignment: .center, spacing: 8) {
                        Image("Magnifier 1")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(.bottom, 17)
                        
                        Text("\(boardName)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
                        + Text(" 글을\n검색해 보세요")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Constants.Gray900)
                        
                        Spacer()
                    }
                    .padding(.vertical, 144)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
    
    func performSearch() {
        // 모든 데이터를 합쳐 검색할 수 있는 데이터 배열 생성
        let allData = dummyBoardData + employmentDummyBoardData + containerDummyBoardData
        
        // 검색 결과 필터링
        filteredResults = allData.filter {
            $0.title.contains(searchText) || $0.description.contains(searchText)
        }
        
        // 검색 결과가 있는지 확인
        hasSearchResults = !filteredResults.isEmpty
    }
}

#Preview {
    SearchViewController(boardName: "게시판")
}

//
//  DirectoryMainViewController.swift
//  Sukbakji
//
//  Created by KKM on 8/7/24.
//

import SwiftUI

struct DirectoryMainViewController: View {
    
    @State private var selectedButton: String? = "" // 기본값을 '메인'으로 설정
    @State private var searchText: String = "" // 검색 텍스트 상태 변수
    @State private var isSearchActive: Bool = false // 검색 바 클릭 상태 변수
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Text("연구실 디렉토리")
                            .font(.system(size: 22, weight: .bold))
                        
                        Spacer()
                        
                        Button(action: {
                            print("알림 버튼 클릭됨")
                        }) {
                            Image("Bell")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                        
                        Button(action: {
                            print("마이페이지 버튼 클릭됨")
                        }) {
                            Image("MyPage")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                    }
                    .padding(.leading, 24)
                    .padding(.trailing, 8)
                    
                    Divider().background(Constants.Gray100)
                    
                    // MARK: -- 검색창
                    ScrollView(.vertical) {
                        VStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8) // 아이콘 왼쪽 여백
                                
                                Text("게시판에서 궁금한 내용을 검색해 보세요!")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .padding(.vertical, 12) // 상하 여백 추가
                                    .padding(.horizontal, 4) // 아이콘과 텍스트 사이의 여백 추가
                                    .onTapGesture {
                                        isSearchActive = true
                                    }
                                
                                Spacer() // 아이콘과 텍스트 사이에 빈 공간 추가
                            }
                            .padding(.leading, 4) // 좌우 여백 추가
                            .background(Color(UIColor.systemGray6)) // 밝은 회색 배경색
                            .cornerRadius(8) // 모서리 둥글게
                            .shadow(radius: 5) // 그림자 효과
                            
                            Spacer() // 검색창과 다른 요소 간의 공간을 만듭니다.
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                    }
                }
            }
        }
    }
}


// MARK: -- Preview
struct DirectoryMainViewController_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryMainViewController()
    }
}


//
//  LabReviewViewController.swift
//  Sukbakji
//
//  Created by KKM on 8/9/24.
//

import SwiftUI

struct LabReviewViewController: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSearchActive: Bool = false // 검색 바 클릭 상태 변수
    @State private var reviews: [LabReview] = [LabReview(), LabReview(), LabReview()] // 초기 리뷰 목록
    @State private var showMoreReviews: Bool = false // '연구실 후기 더보기' 버튼 상태 변수
    
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
                    
                    Text("연구실 후기")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.Gray900)
                        .frame(alignment: .center)
                    
                    Spacer()
                    
                    // 더보기 버튼 (공간 확보용)
                    Image("")
                        .resizable()
                        .frame(width: Constants.nav, height: Constants.nav)
                }
                
                ScrollView {
                    HStack {
                        VStack(alignment: .center, spacing: 8) {
                            Text("지도교수명을 검색해 주세요")
                                .font(
                                    Font.custom("Pretendard", size: 18)
                                        .weight(.semibold)
                                )
                                .foregroundColor(Constants.Gray900)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("연구실에 대한 정보를 한 눈에 보세요")
                                .font(Font.custom("Pretendard", size: 14))
                                .foregroundColor(Constants.Gray500)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .overlay(
                            Image("Folder")
                                .resizable()
                                .frame(width: 107.16239, height: 87.06912), alignment: .topTrailing
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                    .overlay(
                        // MARK: -- 검색창
                        VStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8) // 아이콘 왼쪽 여백
                                
                                Text("지도교수명을 입력해 주세요")
                                    .font(.system(size: 14))
                                    .foregroundColor(Constants.Gray300)
                                    .padding(.vertical, 12) // 상하 여백 추가
                                    .padding(.horizontal, 4) // 아이콘과 텍스트 사이의 여백 추가
                                    .onTapGesture {
                                        isSearchActive = true
                                    }
                                
                                Spacer() // 아이콘과 텍스트 사이에 빈 공간 추가
                            }
                            .padding(.leading, 4) // 좌우 여백 추가
                            .background(Constants.Gray50) // 밝은 회색 배경색
                            .cornerRadius(8) // 모서리 둥글게
                            .padding(.top, 120) // 검색창과 주황색 배경 간의 공간 조정
                            
                            Spacer() // 검색창과 다른 요소 간의 공간을 만듭니다.
                        }
                            .padding(.horizontal, 24)
                    )
                    HStack {
                        Text("최신 연구실 후기")
                            .font(
                                Font.custom("Pretendard", size: 18)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .foregroundColor(Constants.Gray900)
                            .padding(.top, 56)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    
                    // 기존 리뷰들을 표시
                    ForEach(reviews) { review in
                        NewLabReview(review: review)
                    }
                    
                    // '연구실 후기 더보기' 버튼
                    if showMoreReviews {
                        ForEach(reviews) { review in
                            NewLabReview(review: review)
                        }
                    }
                    
                    Button(action: {
                        // '연구실 후기 더보기' 버튼 클릭 시 동작할 코드
                        showMoreReviews.toggle()
                        print("연구실 후기 더보기 버튼 tapped")
                    }) {
                        HStack {
                            Text("연구실 후기 더보기")
                                .font(
                                Font.custom("Pretendard", size: Constants.fontSize7)
                                    .weight(.regular)
                                )
                                .foregroundColor(Constants.Gray900)
                                
                            Image("More 2")
                                .resizable()
                                .frame(width: 12, height: 12)
                        }
                        .padding(.horizontal, 10)
                        .padding(10)
                        .frame(alignment: .center)
                        .cornerRadius(999)
                        .overlay(
                            RoundedRectangle(cornerRadius: 999)
                                .inset(by: 0.5)
                                .stroke(Constants.Gray300, lineWidth: 1)
                        )
                    }
                    .padding(.top, 16)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct NewLabReview: View {
    var review: LabReview
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text(review.university)
                .font(
                    Font.custom("Pretendard", size: Constants.fontSize6)
                        .weight(Constants.fontWeightMedium)
                )
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(review.department)
                .font(
                    Font.custom("Pretendard", size: Constants.fontSize5)
                        .weight(Constants.fontWeightSemibold)
                )
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(review.reviewText)
                .font(
                    Font.custom("Pretendard", size: Constants.fontSize6)
                        .weight(Constants.fontWeightMedium)
                )
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            HStack(alignment: .center, spacing: 6) { // 좌우 여백을 6으로 설정
                ForEach(review.keywords, id: \.self) { keyword in
                    KeywordView(keywordName: keyword)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
        }
        .padding(16)
        .frame(width: 342, alignment: .topLeading)
        .background(Constants.White)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.5)
                .stroke(Constants.Gray100, lineWidth: 1)
        )
        
    }
}

struct KeywordView: View {
    var keywordName: String
    
    var body: some View {
        Text(keywordName)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color(red: 0.99, green: 0.91, blue: 0.9))
            .cornerRadius(4)
    }
}

// 간단한 LabReview 데이터 구조체
struct LabReview: Identifiable {
    let id = UUID()
    var university: String = "성신여자대학교"
    var department: String = "화학에너지융합학부 에너지재료연구실"
    var reviewText: String = "모든 학생들의 연구 진행상황을 상세히 검토해 주시고 올바른 길로 나아가도록 지도해 주시는 교수님이에요"
    var keywords: [String] = ["지도력이 좋아요", "인건비가 높아요", "자율성이 높아요"]
}

#Preview {
    LabReviewViewController()
}

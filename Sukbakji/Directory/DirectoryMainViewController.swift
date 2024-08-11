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
    
    @State private var hasScrappedLaboratories: Bool = true // 연구실이 있는지 여부를 나타내는 Bool 변수
    
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
                    
                    
                    // MARK: -- 검색창
                    ScrollView(.vertical) {
                        VStack {
                            NavigationLink(destination: DirectorySearchViewController(searchText: $searchText)) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 8) // 아이콘 왼쪽 여백
                                    
                                    Text("게시판에서 궁금한 내용을 검색해 보세요!")
                                        .font(.system(size: 14))
                                        .foregroundColor(Constants.Gray300)
                                        .padding(.vertical, 12) // 상하 여백 추가
                                        .padding(.horizontal, 4) // 아이콘과 텍스트 사이의 여백 추가
                                    
                                    Spacer() // 아이콘과 텍스트 사이에 빈 공간 추가
                                }
                                .padding(.leading, 4) // 좌우 여백 추가
                                .background(Constants.Gray50) // 밝은 회색 배경색
                                .cornerRadius(8) // 모서리 둥글게
                            }
                            
                            Spacer() // 검색창과 다른 요소 간의 공간을 만듭니다.
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        HStack(alignment: .center) {
                            Text("즐겨찾는 연구실")
                                .font(Font.custom("Pretendard", size: 18) .weight(.semibold))
                                .foregroundColor(Constants.Gray900)
                            
                            Image("Magnifier 1")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Spacer()
                            
                            if hasScrappedLaboratories {
                                Button(action: {
                                    print("즐겨찾는 연구실 더보기 tapped!")
                                }) {
                                    
                                    NavigationLink(destination: ScrappedLabDetailViewController()) {
                                        HStack(spacing: 4) {
                                            Text("더보기")
                                                .font(.system(size: 12, weight: .medium))
                                                .multilineTextAlignment(.center)
                                                .foregroundStyle(Constants.Gray500)
                                            
                                            Image("More 1")
                                                .resizable()
                                                .frame(width: 4, height: 8)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, 12)
                        .frame(width: 390, alignment: .center)
                        .background(Constants.White)
                        
                        if hasScrappedLaboratories {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ScrappedLaboratory(
                                                title: "성신여자대학교",
                                                universityName: "성신여자대학교",
                                                labName: "화학에너지융합학부 에너지재료연구실",
                                                professorName: "구본재"
                                            )
                                    ScrappedLaboratory(
                                                title: "성신여자대학교",
                                                universityName: "성신여자대학교",
                                                labName: "화학에너지융합학부 에너지재료연구실",
                                                professorName: "구본재"
                                            )
                                    ScrappedLaboratory(
                                                title: "성신여자대학교",
                                                universityName: "성신여자대학교",
                                                labName: "화학에너지융합학부 에너지재료연구실",
                                                professorName: "구본재"
                                    )
                                    ScrappedLaboratory(
                                                title: "성신여자대학교",
                                                universityName: "성신여자대학교",
                                                labName: "화학에너지융합학부 에너지재료연구실",
                                                professorName: "구본재"
                                            )
                                    ScrappedLaboratory(
                                                title: "성신여자대학교",
                                                universityName: "성신여자대학교",
                                                labName: "화학에너지융합학부 에너지재료연구실",
                                                professorName: "구본재"
                                            )
                                    ScrappedLaboratory(
                                                title: "성신여자대학교",
                                                universityName: "성신여자대학교",
                                                labName: "화학에너지융합학부 에너지재료연구실",
                                                professorName: "구본재"
                                            )
                                }
                            }
                            .padding(.horizontal, 24)
                        } else {
                            EmptyScrappedLaboratory()
                                .frame(maxWidth: .infinity, minHeight: 150)
                                .background(Constants.Gray50)
                                .cornerRadius(12)
                                .padding(.horizontal, 24)
                        }
                        
                        HStack(alignment: .center) {
                            Text("관심 주제 모아보기")
                                .font(Font.custom("Pretendard", size: 18) .weight(.semibold))
                                .foregroundColor(Constants.Gray900)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .frame(alignment: .center)
                        .background(Constants.White)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                TagView(tagName: "열화학")
                                TagView(tagName: "딥러닝")
                                TagView(tagName: "HCI")
                                TagView(tagName: "로보틱스")
                                TagView(tagName: "석박지")
                            }
                            .padding(.horizontal, 24)
                        }

                        // 광고 배너 뷰
                        AdvertisementView()
                        
                        
                        HStack(alignment: .center) {
                            Text("연구실 후기")
                                .font(Font.custom("Pretendard", size: 18) .weight(.semibold))
                                .foregroundColor(Constants.Gray900)
                            
                            Image("Magnifier 1")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Spacer()
                            
                            Button(action: {
                                print("연구실 후기 더보기 tapped!")
                            }) {
                                NavigationLink(destination: LabReviewViewController()) {
                                    Text("더보기")
                                        .font(.system(size: 12, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(Constants.Gray500)
                                    
                                    Image("More 1")
                                        .resizable()
                                        .frame(width: 4, height: 8)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .frame(alignment: .center)
                        .background(Constants.White)
                        
                        LabReviewDummy()
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
}

// MARK: -- 즐겨찾는 연구실 테이블 뷰
import SwiftUI

struct ScrappedLaboratory: View {
    var title: String
    var universityName: String
    var labName: String
    var professorName: String

    var body: some View {
        HStack {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    Constants.White
                        .frame(height: 70) // 상단 흰색 배경
                    Constants.Gray50
                }
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Constants.Gray100, lineWidth: 1)
                )

                VStack(alignment: .leading, spacing: 12) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(1) // 텍스트가 길면 한 줄로 제한하고 '...'로 표시
                        .truncationMode(.tail) // '...' 표시 위치 설정
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(labName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(alignment: .center, spacing: 12) {
                        Image("Profile Image")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.top, 12)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(professorName)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Text("교수")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            
                            Text("\(universityName) \(labName)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    HStack {
                        Text("label")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(red: 0.99, green: 0.91, blue: 0.9))
                            .cornerRadius(4)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
                .frame(width: 300, alignment: .topLeading)
            }
        }
    }
}




// MARK: -- 해시태그 뷰
struct TagView: View {
    var tagName: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text("#\(tagName)")
                .font(
                    Font.custom("Pretendard", size: Constants.fontSize5)
                        .weight(Constants.fontWeightMedium)
                )
                .foregroundColor(Constants.White)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(Constants.Orange700)
        .cornerRadius(999)
    }
}

// MARK: -- 광고 배너 뷰
struct AdvertisementView: View {
    @State private var selectedPage = 0
    let images = ["Adv 1", "Adv 1", "Adv 1", "Adv 1"]
    
    var body: some View {
        TabView(selection: $selectedPage) {
            ForEach(0..<images.count, id: \.self) { index in
                Image(images[index])
                    .resizable()
                    .scaledToFit()
                    .tag(index)
            }
        }
        .padding(.horizontal, 24)
        .frame(height: 100)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay(
            Text(" \(selectedPage + 1) / \(images.count) ")
                .font(
                Font.custom("Pretendard", size: Constants.fontSize6)
                .weight(Constants.fontWeightMedium)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.Gray300)
                .padding(5)
                .background(Color.black.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(999)
                .padding(.trailing, 38)
                .padding(.bottom, 10), alignment: .bottomTrailing
        )
    }
}

// MARK: -- 연구실 후기 더미 데이터
struct LabReviewDummy: View {
    var body: some View {
        HStack {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    Constants.White
                }
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Constants.Gray100, lineWidth: 1)
                )

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        HStack(alignment: .center, spacing: 4) {
                            Text("성신여자대학교")
                                .font(
                                    Font.custom("Pretendard", size: 12)
                                        .weight(.medium)
                                )
                                .foregroundColor(Constants.Gray900)
                                .frame(maxWidth: .infinity, minHeight: 14, maxHeight: 14, alignment: .leading)
                        }
                    }
                    
                    Text("화학에너지융합학부 에너지재료연구실")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize5)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.Gray900)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    
                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text("모든 학생들의 연구 진행상황을 상세히 검토해 주시고 올바른 길로 나아가도록 지도해 주시는 교수님이에요")
                                .font(
                                Font.custom("Pretendard", size: Constants.fontSize6)
                                .weight(Constants.fontWeightMedium)
                                )
                                .foregroundColor(Constants.Gray900)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            
                        }
                        .frame(height: 35, alignment: .topLeading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        HStack(alignment: .center, spacing: 4) {
                            Text("label")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(red: 0.99, green: 0.91, blue: 0.9))
                        .cornerRadius(4)
                        
                        HStack(alignment: .center, spacing: 4) {
                            Text("label")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(red: 0.99, green: 0.91, blue: 0.9))
                        .cornerRadius(4)
                        
                        HStack(alignment: .center, spacing: 4) {
                            Text("label")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(red: 0.99, green: 0.91, blue: 0.9))
                        .cornerRadius(4)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
                .frame(width: 300, alignment: .topLeading)
            }
        }
    }
}

// MARK: -- 즐겨찾는 연구실 없을 경우
struct EmptyScrappedLaboratory: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("아직 즐겨찾기 연구실이 없어요")
                .font(
                    Font.custom("Pretendard", size: Constants.fontSize5)
                        .weight(Constants.fontWeightSemibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.Gray500)
            
            Text("연구실을 탐색하고 즐겨찾기를 등록해 보세요!")
                .font(
                    Font.custom("Pretendard", size: 11)
                        .weight(.regular)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.Gray500)
        }
        .padding()
    }
}

// MARK: -- Preview
struct DirectoryMainViewController_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryMainViewController()
    }
}


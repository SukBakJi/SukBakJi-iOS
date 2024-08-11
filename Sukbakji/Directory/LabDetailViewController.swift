//
//  LabDetailViewController.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import SwiftUI

struct LabDetailViewController: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingSheet = false
    @State private var isBookmarked = false // 즐겨찾기 상태를 나타내는 변수
    @State private var isAuthor = true // 작성자인지 여부를 나타내는 상태 변수
    @State private var showBookmarkOverlay = false // 즐겨찾기 오버레이 표시 상태 변수
    @State private var bookmarkOverlayMessage = "" // 오버레이 메시지
    @State private var selectedButton: String? = "연구실 정보" // 기본값을 '연구실 정보'으로 설정

    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
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
                    
                    Text("연구실 정보")
                        .font(.system(size: 22, weight: .bold))
                    
                    Spacer()
                    
                    Button(action: {
                        print("더보기 버튼 클릭됨")
                    }) {
                        Image("MoreButton")
                            .resizable()
                            .frame(width: 48, height: 48)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 10)
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(["연구실 정보", "후기"], id: \.self) { title in
                            Button(action: {
                                selectedButton = title
                                print("\(title) 클릭")
                            }) {
                                VStack {
                                    Text(title)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(selectedButton == title ? Color(red: 0.93, green: 0.29, blue: 0.03) : .gray)
                                        .padding(.horizontal, 10) // 좌우 여백을 10으로 조정
                                }
                                .padding(.vertical, 8)
                                .background(
                                    GeometryReader { geometry in
                                        if selectedButton == title {
                                            Rectangle()
                                                .fill(Color(red: 0.93, green: 0.29, blue: 0.03))
                                                .frame(width: geometry.size.width, height: 3)
                                                .offset(y: 16) // 구분선과 버튼 사이의 간격
                                        }
                                    }
                                        .frame(height: 0) // GeometryReader의 높이를 0으로 설정하여 겹치지 않게 함
                                )
                            }
                            .padding(.leading, title == "연구실 정보" ? 0 : 16) // 첫 번째 항목에 왼쪽 패딩 제거
                        }
                    }
                    .padding(.leading, 24) // HStack의 좌측 여백을 24로 고정
                    .padding(.trailing, 24) // HStack의 우측 여백을 24로 고정
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color.white) // 상단 영역의 배경색을 흰색으로 설정
                .fixedSize(horizontal: false, vertical: true) // 상단 영역의 높이는 내용에 맞게 조정
            }
            .background(Color.white)
            
            // 구분선 아래의 내용
            VStack {
                switch selectedButton {
                case "연구실 정보":
                    LabInfoView(
                        title: "성신여자대학교",
                        universityName: "성신여자대학교",
                        labName: "화학에너지융합학부",
                        professorName: "구본재",
                        professorEmail: "koo@seokbakji.ac.kr",
                        hasLabURL: true,
                        labURL: "https://seokbakji.ac.kr/",
                        isBookmarked: $isBookmarked
                    )

                case "후기":
                    LabReviewView()
                default:
                    Text("오류 발생. 관리자에게 문의하세요.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 2)
            
        }
    }
}

struct LabInfoView: View {
    var title: String
    var universityName: String
    var labName: String
    var professorName: String
    var professorEmail: String
    var hasLabURL: Bool
    var labURL: String // 연구실 URL
    @Binding var isBookmarked: Bool // Binding으로 상태 전달
    
    var body: some View {
        ScrollView {
            VStack {
                Constants.Gray300
                    .frame(height: 120)
                Constants.White
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 124)
                    .padding(.horizontal, 24)
                    .padding(.top, 190)
                    .foregroundStyle(Constants.Gray50)
            )
            .overlay(
                VStack {
                    HStack {
                        Image("Symbol")
                            .resizable()
                            .frame(width: 56, height: 56)
                            .padding(22)
                    }
                    .background(Constants.White) // 밝은색 배경색
                    .cornerRadius(20) // 모서리 둥글게
                    .padding(.top, 60)
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 24)
            )
            
            VStack {
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
                    
                    // 즐겨찾기 버튼
                    Button(action: {
                        isBookmarked.toggle() // 버튼 클릭 시 상태 변경
                    }) {
                        Image(isBookmarked ? "BookmarkButton Fill" : "BookmarkButton") // 상태에 따라 이미지 변경
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 1)
                
                Text("\(universityName)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Constants.Orange700)
                + Text(" \(labName)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Constants.Gray800)
            }
            .padding(.bottom, 28)
            
            HStack {
                Text("교수 정보")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 24)
                    .padding(.top, 14)
                Image("SearchRecommend 1")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .padding(.top, 14)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 20) {
                    Text("최종학력")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize6)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.Gray600)
                        .frame(width: 50, alignment: .leading) // "최종학력"의 너비를 고정

                    Text("서울대학교 화학에너지융합학부 박사")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize5)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.Gray900)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack(alignment: .center, spacing: 20) {
                    Text("이메일")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize6)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.Gray600)
                        .frame(width: 50, alignment: .leading) // "이메일"의 너비를 "최종학력"과 동일하게 고정

                    Text("\(professorEmail)")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize5)
                                .weight(Constants.fontWeightMedium)
                        )
                        .underline()
                        .foregroundColor(Constants.Gray900)
                        .frame(alignment: .leading)
                    
                    Button(action: {
                        UIPasteboard.general.string = "\(professorEmail)"
                    }) {
                        Image("copy")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(Constants.Gray50)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(Constants.Gray100, lineWidth: 1)
            )
            .padding(.horizontal, 24)
            
            HStack {
                Text("연구실 정보")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 24)
                    .padding(.top, 14)
                Image("Info")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .padding(.top, 14)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 8) {
                    Image("Link")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text("홈페이지")
                        .font(
                            Font.custom("Pretendard", size: 16)
                                .weight(Constants.fontWeightSemibold)
                        )
                        .foregroundColor(Constants.Gray900)
                    
                    if hasLabURL {
                        Text("\(labURL)")
                            .font(
                                Font.custom("Pretendard", size: 16)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .underline()
                            .foregroundColor(Constants.Orange700)
                    } else {
                        Text("해당 연구실은 홈페이지가 없습니다.")
                            .font(
                                Font.custom("Pretendard", size: 16)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .foregroundColor(Constants.Gray600)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 17)
            .frame(width: 342, height: 54, alignment: .topLeading)
            .background(Constants.Gray50)
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(Constants.Gray100, lineWidth: 1)
            )
            
            HStack {
                Text("연구 주제")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 24)
                    .padding(.top, 14)
                Image("SearchRecommend 3")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .padding(.top, 14)
                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    LabTopic(topicName: "열화학")
                    LabTopic(topicName: "딥러닝")
                    LabTopic(topicName: "HCI")
                    LabTopic(topicName: "로보틱스")
                    LabTopic(topicName: "석박지")
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

struct LabTopic: View {
    var topicName: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text("#\(topicName)")
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


struct LabReviewView: View {
    var body: some View {
        ScrollView {
            
        }
    }
}

#Preview {
    LabDetailViewController()
}

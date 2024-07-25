//
//  BoardMainViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/25/24.
//

import SwiftUI




struct BoardMainViewController: View {
    
    @State private var searchText: String = "" // 검색 텍스트 상태 변수
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ZStack(alignment: .topLeading) {
                    Color(red: 1, green: 0.44, blue: 0.23) // 주황색 배경 설정
                        .frame(height: 116)
                        .edgesIgnoringSafeArea(.horizontal) // 가로로 안전 영역을 무시하여 전체 너비를 사용
                    
                    VStack(alignment: .leading) {
                        Text("석박지에서")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white) // 텍스트 색상 흰색
                            .padding(.leading, 24) // 왼쪽 여백 추가
                            .padding(.top, 24) // 위쪽 여백 추가
                        
                        Text("함께 소통해 보세요!📢")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white) // 텍스트 색상 흰색
                            .padding(.leading, 24) // 왼쪽 여백 추가
                            .padding(.top, 4) // 위쪽 여백 추가
                    }
                    .padding(.bottom, 8) // 하단 여백 추가
                }
                .overlay(
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 8) // 아이콘 왼쪽 여백
                            
                            TextField("게시판에서 궁금한 내용을 검색해 보세요!", text: $searchText)
                                .font(.system(size: 14))
                                .textFieldStyle(PlainTextFieldStyle()) // 테두리 없는 스타일
                                .padding(.vertical, 12) // 상하 여백 추가
                                .padding(.horizontal, 4) // 아이콘과 텍스트 사이의 여백 추가
                            
                            Spacer() // 아이콘과 텍스트 사이에 빈 공간 추가
                        }
                        .padding(.leading, 4) // 좌우 여백 추가
                        .background(Color(UIColor.systemGray6)) // 밝은 회색 배경색
                        .cornerRadius(8) // 모서리 둥글게
                        .shadow(radius: 5) // 그림자 효과
                        .padding(.top, 120) // 검색창과 주황색 배경 간의 공간 조정
                        
                        Spacer() // 검색창과 다른 요소 간의 공간을 만듭니다.
                    }
                        .padding(.horizontal, 24)
                )
                
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        // HOT 게시판 버튼
                        Button(action: {
                            // HOT 게시판 버튼 클릭 시 동작할 코드
                            print("HOT 게시판 tapped")
                        }) {
                            ZStack(alignment: .topLeading) { // 텍스트를 상자의 좌측 상단에 정렬
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.98, green: 0.98, blue: 0.98))
                                    .shadow(radius: 3)
                                
                                HStack {
                                    Text("HOT 게시판")
                                        .font(.system(size: 15, weight: .semibold))
                                        .padding(.top, 16) // 위쪽 여백
                                        .padding(.leading, 12) // 왼쪽 여백
                                        .padding(.bottom, 47)
                                        .frame(maxWidth: .infinity, alignment: .topLeading) // 왼쪽 위 정렬
                                    
                                    
                                    
                                    Image("Magnifier") // 이미지 추가
                                    
                                    
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일
                        
                        // 내가 쓴 글 버튼
                        Button(action: {
                            // 내가 쓴 글 버튼 클릭 시 동작할 코드
                            print("내가 쓴 글 tapped")
                        }) {
                            ZStack(alignment: .topLeading) { // 텍스트를 상자의 좌측 상단에 정렬
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.98, green: 0.98, blue: 0.98))
                                    .shadow(radius: 3)
                                
                                HStack {
                                    Text("내가 쓴 글")
                                        .font(.system(size: 15, weight: .semibold))
                                        .padding(.top, 16) // 위쪽 여백
                                        .padding(.leading, 12) // 왼쪽 여백
                                        .padding(.bottom, 47)
                                        .frame(maxWidth: .infinity, alignment: .topLeading) // 왼쪽 위 정렬
                                    
                                    
                                    Image("Pencil") // 이미지 추가
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .padding(.trailing, 0) // 오른쪽 여백 없음
                                        .padding(.bottom, 0) // 아래 여백 없음
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일
                    }
                    
                    HStack(spacing: 8) {
                        // 스크랩 버튼
                        Button(action: {
                            // 스크랩 버튼 클릭 시 동작할 코드
                            print("스크랩 tapped")
                        }) {
                            ZStack(alignment: .topLeading) { // 텍스트를 상자의 좌측 상단에 정렬
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.98, green: 0.98, blue: 0.98))
                                    .shadow(radius: 3)
                                
                                HStack {
                                    Text("스크랩")
                                        .font(.system(size: 15, weight: .semibold))
                                        .padding(.top, 16) // 위쪽 여백
                                        .padding(.leading, 12) // 왼쪽 여백
                                        .padding(.bottom, 47)
                                        .frame(maxWidth: .infinity, alignment: .topLeading) // 왼쪽 위 정렬
                                    
                                    
                                    Image("Folder") // 이미지 추가
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .padding(.trailing, 0) // 오른쪽 여백 없음
                                        .padding(.bottom, 0) // 아래 여백 없음
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일
                        
                        // 댓글 단 글 버튼
                        Button(action: {
                            // 댓글 단 글 버튼 클릭 시 동작할 코드
                            print("댓글 단 글 tapped")
                        }) {
                            ZStack(alignment: .topLeading) { // 텍스트를 상자의 좌측 상단에 정렬
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.98, green: 0.98, blue: 0.98))
                                    .shadow(radius: 3)
                                
                                HStack {
                                    Text("댓글 단 글")
                                        .font(.system(size: 15, weight: .semibold))
                                        .padding(.top, 16) // 위쪽 여백
                                        .padding(.leading, 12) // 왼쪽 여백
                                        .padding(.bottom, 47)
                                        .frame(maxWidth: .infinity, alignment: .topLeading) // 왼쪽 위 정렬
                                    
                                    
                                    Image("Chat") // 이미지 추가
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .padding(.trailing, 0) // 오른쪽 여백 없음
                                        .padding(.bottom, 0) // 아래 여백 없음
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일
                    }
                }
                .padding(.horizontal, 24) // 좌우 여백 추가
                .padding(.top, 30) // 추가적인 여백
                
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(height: 245)
                    .background(Constants.Gray50)
                    .overlay(
                        VStack {
                            
                            HStack {
                                Text("최신 질문글")
                                    .font(.system(size: 18, weight: .bold))
                                    .padding(.leading, 24)
                                    .padding(.top, 14)
                                Image("Magnifier 1")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .padding(.top, 14)
                                
                                Spacer()
                                
                                Button(action: {
                                    print("최신 질문글 tapped")
                                    // 버튼 클릭 시 동작
                                }) {
                                    NavigationLink(destination: BoardQnABoardViewController()) {
                                        Text("더보기")
                                            .font(.system(size: 12, weight: .medium))
                                            .multilineTextAlignment(.center)
                                            .foregroundStyle(Constants.Gray500)
                                        
                                        Image("More 1")
                                            .resizable()
                                            .frame(width: 4, height: 8)
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.top, 14)
                                .frame(alignment: .center)
                                .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                
                                
                                Button(action: {
                                    print("최신 질문글 첫 번재 게시글 tapped")
                                    // 취업후기 버튼 동작
                                }) {
                                    HStack(alignment: .center, spacing: 12) {
                                        Text("입학 예정")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundStyle(Color(red: 0.29, green: 0.45, blue: 1))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(RoundedRectangle(cornerRadius: 4)
                                                .fill(Color(red: 0.91, green: 0.92, blue: 1)))
                                            .padding(.leading, 18)
                                        
                                        Text("면접 때 해당 전공교수님만 들어오나?")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(Constants.Gray900)
                                            .padding(.leading, 12)
                                            .padding(.vertical, 18)
                                    }
                                }
                                
                                Divider()
                                    .background(Constants.Gray50) // 구분선 색상 설정
                                
                                Button(action: {
                                    print("최신 질문글 두 번재 게시글 tapped")
                                    // 대학원생활 버튼 동작
                                }) {
                                    HStack(alignment: .center, spacing: 12) {
                                        Text("석사")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundStyle(Color(red: 0.29, green: 0.45, blue: 1))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(RoundedRectangle(cornerRadius: 4)
                                                .fill(Color(red: 0.91, green: 0.92, blue: 1)))
                                            .padding(.leading, 18)
                                        
                                        Text("연세대 서류학점 필요한가요?")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(Constants.Gray900)
                                            .padding(.leading, 12)
                                            .padding(.vertical, 18)
                                    }
                                }
                                
                                Divider()
                                    .background(Constants.Gray50) // 구분선 색상 설정
                                
                                Button(action: {
                                    print("최신 질문글 세 번재 게시글 tapped")
                                    // 대학원생활 버튼 동작
                                }) {
                                    HStack(alignment: .center, spacing: 12) {
                                        Text("박사")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundStyle(Color(red: 0.29, green: 0.45, blue: 1))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(RoundedRectangle(cornerRadius: 4)
                                                .fill(Color(red: 0.91, green: 0.92, blue: 1)))
                                            .padding(.leading, 18)
                                        
                                        Text("졸업논문 쓸 때 이거 필요한가요?")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(Constants.Gray900)
                                            .padding(.leading, 12)
                                            .padding(.vertical, 18)
                                    }
                                }
                            }
                            .padding(0)
                            .frame(width: 342, alignment: .topLeading)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(Constants.Gray100, lineWidth: 1)
                            )
                            
                            
                        }
                    )
                
                
                
                HStack(alignment: .center) {
                    Text("즐겨찾기한 게시판")
                        .font(.system(size: 18, weight:.semibold))
                        .foregroundStyle(Constants.Gray900)
                    
                    Image("Star 1")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                    
                    Spacer()
                    
                    
                    Button(action: {
                        print("즐겨찾기한 게시판 tapped")
                        // 버튼 클릭 시 동작
                    }) {
                        Text("더보기")
                            .font(.system(size: 12, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Constants.Gray500)
                        
                        Image("More 1")
                            .resizable()
                            .frame(width: 4, height: 8)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 14)
                .padding(.bottom, 12)
                .frame(alignment: .center)
                .background(Constants.White)
                .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일
                
                
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: {
                        print("즐겨찾기한 게시판 첫 번재 게시글 tapped")
                        // 취업후기 버튼 동작
                    }) {
                        HStack(alignment: .center, spacing: 12) {
                            Text("취업후기")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(Color(red: 0.29, green: 0.45, blue: 1))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.91, green: 0.92, blue: 1)))
                                .padding(.leading, 18)
                            
                            Text("연세대 서류학점 필요한가요?")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Constants.Gray900)
                                .padding(.leading, 12)
                                .padding(.vertical, 18)
                        }
                    }
                    
                    Divider()
                        .background(Constants.Gray100) // 구분선 색상 설정
                    
                    Button(action: {
                        print("즐겨찾기한 게시판 두 번재 게시글 tapped")
                        // 대학원생활 버튼 동작
                    }) {
                        HStack(alignment: .center, spacing: 12) {
                            Text("대학원생활")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(Color(red: 0.29, green: 0.45, blue: 1))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 0.91, green: 0.92, blue: 1)))
                                .padding(.leading, 18)
                            
                            Text("배고프다")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Constants.Gray900)
                                .padding(.leading, 12)
                                .padding(.vertical, 18)
                        }
                    }
                }
                .padding(0)
                .frame(width: 342, alignment: .topLeading)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Constants.Gray100, lineWidth: 1)
                        .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 0) // 그림자 효과
                )
                
                VStack {
                    Rectangle()
                        .frame(height: 48)
                        .foregroundStyle(.clear)
                }
            }
        }
    }
}

struct BoardMainViewController_Previews: PreviewProvider {
    static var previews: some View {
        BoardMainViewController()
    }
}



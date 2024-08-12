//
//  BoardViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/25/24.
//

import SwiftUI

struct BoardViewController: View {
    @State private var selectedButton: String? = "메인" // 기본값을 '메인'으로 설정
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Text("게시판")
                            .font(.system(size: 22, weight: .bold))
                        
                        Spacer()
                        
                        Button(action: {
                            print("알림 버튼 클릭됨")
                        }) {
                            Image("Bell")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                    }
                    .padding(.leading, 24)
                    .padding(.trailing, 8)
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ForEach(["메인", "박사", "석사", "입학 예정"], id: \.self) { title in
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
                                .padding(.leading, title == "메인" ? 0 : 16) // 첫 번째 항목에 왼쪽 패딩 제거
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
                    case "메인":
                        MainView()
                    case "박사":
                        DoctoralView()
                    case "석사":
                        MasterView()
                    case "입학 예정":
                        AdmissionView()
//                    case "자유":
//                        FreeView()
                    default:
                        Text("여기에 컨텐츠를 추가하세요")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 2)
                
            }
        }
        .accessibilityIdentifier("BoardViewController")
    }
    
}


struct MainView: View {
    var body: some View {
        BoardMainViewController()
    }
}

struct DoctoralView: View {
    var body: some View {
        BoardDoctoralViewController()
    }
}

struct MasterView: View {
    var body: some View {
        BoardMasterViewController()
    }
}

struct AdmissionView: View {
    var body: some View {
        BoardAdmissionViewController()
    }
}

struct FreeView: View {
    var body: some View {
        BoardFreeViewController()
    }
}

//struct BoardViewcontroller_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardViewController()
//    }
//}

#Preview {
    BoardViewController()
}

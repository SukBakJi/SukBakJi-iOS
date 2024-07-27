//
//  BoardWriteViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/25/24.
//

import SwiftUI

struct BoardWriteBoardViewController: View {
    
    @State private var selectedCategory: Int? = nil
    @State private var titleText: String = "" // 제목 텍스트 필드의 상태를 관리하기 위한 변수
    @State private var postText: String = "" // 내용 텍스트 필드의 상태를 관리하기 위한 변수
    
    var isFormValid: Bool {
        selectedCategory != nil && !titleText.isEmpty && !postText.isEmpty
    }

    var body: some View {
        VStack {
            HStack {
                // 뒤로가기 버튼
                Button(action: {
                    // 뒤로가기 버튼 클릭 시 동작할 코드
                    print("뒤로가기 버튼 tapped")
                }) {
                    Image("BackButton")
                        .frame(width: Constants.nav, height: Constants.nav)
                }
                
                Spacer()
                
                Text("게시물 작성")
                    .font(.system(size: 20, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.Gray900)
                
                Spacer()
                
                Rectangle()
                    .frame(width: Constants.nav, height: Constants.nav)
                    .foregroundStyle(.clear)
            }
            
            Divider()
            
            ScrollView {
                SeoBakji()
                WriteBoardDetail(selectedCategory: $selectedCategory,
                                 titleText: $titleText,
                                 postText: $postText)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center, spacing: 0) {
                        Button(action: {
                            print("게시물 등록하기 버튼 tapped")
                        }) {
                            Spacer()
                            Text("게시물 등록하기")
                                .font(.system(size: 16, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(isFormValid ? Color.white : Constants.Gray500)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(isFormValid ? Color(red: 0.93, green: 0.29, blue: 0.03) : Constants.Gray200) // 배경색 조건부 변경
                        .cornerRadius(8)
                    }
                    .frame(height: 48, alignment: .center)
                }
                
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .frame(height: 50, alignment: .topLeading)
            .background(Constants.White)
            .shadow(color: .black.opacity(0.15), radius: 3.5, x: 0, y: 0)
        }
    }
}

struct SeoBakji: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("석박지")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
            + Text("에서\n이야기를 나눠 보세요")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.black)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct WriteBoardDetail: View {
    
    let category: [String] = ["박사", "석사", "입학예정"]
    
    @Binding var selectedCategory: Int? // 선택된 카테고리
    @Binding var titleText: String // 제목 텍스트 필드의 상태
    @Binding var postText: String // 내용 텍스트 필드의 상태

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top, spacing: 4) {
                        Text("게시판 선택")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Constants.Gray900)
                    }
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    // Category Buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(category.indices, id: \.self) { index in
                                Button(action: {
                                    selectedCategory = index
                                }) {
                                    HStack(alignment: .center, spacing: 8) {
                                        Image(selectedCategory == index ? "Radio Button" : "Radio Button 1")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        
                                        Text(category[index])
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(Constants.Gray900)
                                    }
                                }
                                .padding(.leading, 3)
                            }
                        }
                        .padding(.horizontal, -3) // Adjust padding to align items properly
                    }
                    .padding(.bottom, 12)
                    
                    Text("카테고리")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.top, 20)
                        .padding(.bottom, 12)
                    
                    DropDownMenuView()
                    
                    Text("제목")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.top, 20)
                        .padding(.bottom, 12)
                    
                    // 텍스트 필드 생성
                    TextField("제목을 입력해주세요", text: $titleText)
                        .padding() // 텍스트 필드 내부 여백
                        .background(Color(Constants.Gray100))
                        .cornerRadius(8) // 모서리 둥글게
                        .foregroundColor(Color(Constants.Gray900)) // 텍스트 색상 (선택 사항)
                    
                    Text("내용")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.top, 20)
                        .padding(.bottom, 12)
                    
                    // 텍스트 필드 생성
                    TextField("내용을 입력해주세요", text: $postText)
                        .frame(height: 120, alignment: .topLeading)
                        .padding() // 텍스트 필드 내부 여백
                        .background(Color(Constants.Gray100))
                        .cornerRadius(8) // 모서리 둥글게
                        .foregroundColor(Color(Constants.Gray900)) // 텍스트 색상 (선택 사항)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct DropDownMenu: View {
    
    let options: [String]
    var menuWidth: CGFloat = 150
    var buttonHeight: CGFloat = 44
    var maxItemDisplayed: Int = 4
    
    @Binding var selectedOptionIndex: Int?
    @Binding var showDropdown: Bool
    
    @State private var scrollPosition: Int?
    
    var body: some View {
        VStack {
            // Dropdown Menu
            VStack(spacing: 0) {
                if showDropdown {
                    let scrollViewHeight: CGFloat = options.count > maxItemDisplayed ? (buttonHeight * CGFloat(maxItemDisplayed)) : (buttonHeight * CGFloat(options.count))
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(0..<options.count, id: \.self) { index in
                                Button(action: {
                                    withAnimation {
                                        selectedOptionIndex = index
                                        showDropdown.toggle()
                                    }
                                }, label: {
                                    HStack {
                                        Text(options[index])
                                            .foregroundColor(Color(Constants.Gray900))
//                                        Spacer()
//                                        if index == selectedOptionIndex {
//                                            Image(systemName: "checkmark.circle.fill")
//                                                .foregroundColor(.black)
//                                        }
                                    }
                                })
                                .padding(.leading, 16)
                                .frame(width: menuWidth, height: buttonHeight, alignment: .leading)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $scrollPosition)
                    .scrollDisabled(options.count <= maxItemDisplayed)
                    .frame(height: scrollViewHeight)
                    .onAppear {
                        scrollPosition = selectedOptionIndex
                    }
                }
            }
            
            // Selected Item or Placeholder
            Button(action: {
                withAnimation {
                    showDropdown.toggle()
                }
            }, label: {
                HStack {
                    if let selectedIndex = selectedOptionIndex {
                        Text(options[selectedIndex])
                    } else {
                        Text("게시판 카테고리를 선택해 주세요")
                            .foregroundColor(Constants.Gray500)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color(red: 0.46, green: 0.46, blue: 0.46))
                        .padding(.trailing, 12)
                        .rotationEffect(.degrees(showDropdown ? -180 : 0))
                }
            })
            .padding(.leading, 16)
            .padding(.vertical, 13)
        }
        .foregroundColor(Color(Constants.Gray900))
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(Constants.Gray100)))
    }
}

struct DropDownMenuView: View {
    @State private var selectedOptionIndex: Int? = nil
    @State private var showDropdown = false
    
    var body: some View {
            DropDownMenu(options: ["질문 게시판", "취업후기 게시판", "대학원생활 게시판", "연구주제 게시판"],
                         selectedOptionIndex: $selectedOptionIndex,
                         showDropdown: $showDropdown)
        
    }
}

#Preview {
    BoardWriteBoardViewController()
}


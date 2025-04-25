////
////  EmploymentReviewWriteBoardViewController.swift
////  Sukbakji
////
////  Created by KKM on 7/27/24.
////
//
//import SwiftUI
//
//struct EmploymentReviewWriteBoardViewController: View {
//    
//    @State private var selectedBoardCategory: Int? = nil // 게시판 선택 라디오 버튼 상태
//    @State private var titleText: String = "" // 제목 텍스트 필드의 상태를 관리하기 위한 변수
//    @State private var postText: String = "" // 내용 텍스트 필드의 상태를 관리하기 위한 변수
//    @State private var selectedCategoryIndex: Int? = nil // 카테고리 드롭다운 메뉴에서 선택된 옵션의 인덱스
//    @State private var selectedSupportFieldIndex: Int? = nil // 지원분야 드롭다운 메뉴에서 선택된 옵션의 인덱스
//    @State private var selectedEmploymentType: Int? = nil // 채용 형태 선택
//    @State private var selectedEducationLevel: Int? = nil // 최종학력 선택
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @State private var showValidationError = false // Validation error state
//    @State private var showCategoryDropdown = false // 카테고리 드롭다운 메뉴 표시 상태
//    @State private var showSupportFieldDropdown = false // 지원분야 드롭다운 메뉴 표시 상태
//
//    var isFormValid: Bool {
//        selectedBoardCategory != nil && selectedCategoryIndex != nil && selectedSupportFieldIndex != nil && selectedEmploymentType != nil && selectedEducationLevel != nil && !titleText.isEmpty && !postText.isEmpty
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                HStack {
//                    // 뒤로가기 버튼
//                    Button(action: {
//                        // 뒤로가기 버튼 클릭 시 동작할 코드
//                        print("뒤로가기 버튼 tapped")
//                        self.presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Image("BackButton")
//                            .frame(width: Constants.nav, height: Constants.nav)
//                    }
//                    
//                    Spacer()
//                    
//                    Text("게시물 작성")
//                        .font(.system(size: 20, weight: .semibold))
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(Constants.Gray900)
//                    
//                    Spacer()
//                    
//                    Rectangle()
//                        .frame(width: Constants.nav, height: Constants.nav)
//                        .foregroundStyle(.clear)
//                }
//                
//                Divider()
//                
//                ScrollView {
//                    SeokBakji()
//                    EmploymentWriteBoardDetail(
//                        selectedBoardCategory: $selectedBoardCategory,
//                        titleText: $titleText,
//                        postText: $postText,
//                        selectedCategoryIndex: $selectedCategoryIndex,
//                        selectedSupportFieldIndex: $selectedSupportFieldIndex,
//                        selectedEmploymentType: $selectedEmploymentType,
//                        selectedEducationLevel: $selectedEducationLevel,
//                        showValidationError: $showValidationError,
//                        showCategoryDropdown: $showCategoryDropdown,
//                        showSupportFieldDropdown: $showSupportFieldDropdown
//                    )
//                }
//                
//                VStack(alignment: .leading, spacing: 10) {
//                    VStack(alignment: .leading, spacing: 10) {
//                        HStack(alignment: .center, spacing: 0) {
//                            Button(action: {
//                                if isFormValid {
//                                    print("게시물 등록하기 버튼 tapped")
//                                } else {
//                                    showValidationError = true
//                                }
//                            }) {
//                                Spacer()
//                                Text("게시물 등록하기")
//                                    .font(.system(size: 16, weight: .medium))
//                                    .multilineTextAlignment(.center)
//                                    .foregroundColor(isFormValid ? Color.white : Constants.Gray500)
//                                Spacer()
//                            }
//                            .padding(.horizontal, 24)
//                            .padding(.vertical, 12)
//                            .background(isFormValid ? Color(red: 0.93, green: 0.29, blue: 0.03) : Constants.Gray200) // 배경색 조건부 변경
//                            .cornerRadius(8)
//                        }
//                        .frame(alignment: .center)
//                    }
//                    
//                }
//                .padding(.horizontal, 24)
//                .padding(.vertical, 8)
//                .frame(alignment: .topLeading)
//                .background(Constants.White)
//                .shadow(color: .black.opacity(0.15), radius: 3.5, x: 0, y: 0)
//            }
//        }
//        .navigationBarBackButtonHidden()
//    }
//}
//
//struct EmploymentWriteBoardDetail: View {
//    
//    let boardCategories: [String] = ["박사", "석사", "입학예정"]
//    let categories: [String] = ["질문 게시판", "취업후기 게시판", "대학원생활 게시판", "연구주제 게시판"]
//    let employmentTypes: [String] = ["신입", "경력"]
//    let educationLevels: [String] = ["박사", "석사"]
//    let supportFields: [String] = ["기획·전략", "법무", "인사·HR", "회계·세무", "마케팅·광고·MD", "개발·데이터", "디자인", "물류·무역", "운전·운송·배송", "영업", "고객상담·TM", "금융·보험", "식·음료", "고객서비스·리테일", "엔지니어링·설계", "제조·생산", "교육", "건축·시설", "의료·바이오", "미디어·문화·스포츠", "공공·복지", "기타"]
//
//    @Binding var selectedBoardCategory: String? // 선택된 카테고리
//        @Binding var titleText: String // 제목 텍스트 필드의 상태
//        @Binding var postText: String // 내용 텍스트 필드의 상태
//        @Binding var selectedCategoryIndex: String? // 카테고리 선택 인덱스를 String? 타입으로 변경
//        @Binding var selectedSupportFieldIndex: Int? // 지원분야 드롭다운 메뉴에서 선택된 옵션의 인덱스
//        @Binding var selectedEmploymentType: Int? // 채용 형태 선택
//        @Binding var selectedEducationLevel: Int? // 최종학력 선택
//        @Binding var showValidationError: Bool // Validation error state
//        @Binding var showCategoryDropdown: Bool // 카테고리 드롭다운 메뉴 표시 상태
//        @Binding var showSupportFieldDropdown: Bool // 지원분야 드롭다운 메뉴 표시 상태
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            // 게시판 선택 라디오 버튼
//            HStack(alignment: .top, spacing: 4) {
//                Text("게시판 선택")
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(Constants.Gray900)
//                
//                Image("dot-badge")
//                    .resizable()
//                    .frame(width: 4, height: 4)
//            }
//            .padding(.bottom, 12)
//            .frame(maxWidth: .infinity, alignment: .topLeading)
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 16) {
//                    ForEach(boardCategories.indices, id: \.self) { index in
//                        Button(action: {
//                            selectedBoardCategory = index
//                        }) {
//                            HStack(alignment: .center, spacing: 8) {
//                                Image(selectedBoardCategory == index ? "Radio Button" : "Radio Button 1")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
//                                
//                                Text(boardCategories[index])
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundStyle(Constants.Gray900)
//                            }
//                        }
//                        .padding(.leading, 3)
//                    }
//                }
//                .padding(.horizontal, -3) // Adjust padding to align items properly
//            }
//            .padding(.bottom, 12)
//            
//            // 카테고리 드롭다운
//            HStack(alignment: .top, spacing: 4) {
//                Text("카테고리")
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(Constants.Gray900)
//                
//                Image("dot-badge")
//                    .resizable()
//                    .frame(width: 4, height: 4)
//            }
//            .padding(.bottom, 12)
//            .padding(.top, 20)
//            .frame(maxWidth: .infinity, alignment: .topLeading)
//            
//            EmploymentCategoryDropDownMenuView(selectedOptionIndex: $selectedCategoryIndex, showValidationError: $showValidationError, showDropdown: $showCategoryDropdown)
//            
//            // 지원분야 드롭다운
//            HStack(alignment: .top, spacing: 4) {
//                Text("지원분야")
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(Constants.Gray900)
//                
//                Image("dot-badge")
//                    .resizable()
//                    .frame(width: 4, height: 4)
//            }
//            .padding(.bottom, 12)
//            .padding(.top, 20)
//            .frame(maxWidth: .infinity, alignment: .topLeading)
//            
//            fieldOfSupportDropDown(
//                options: supportFields,
//                selectedSupportFieldIndex: $selectedSupportFieldIndex,
//                showDropdown: $showSupportFieldDropdown,
//                showValidationError: $showValidationError
//            )
//            
//            // 채용 형태
//            HStack(alignment: .top, spacing: 4) {
//                Text("채용 형태")
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(Constants.Gray900)
//                
//                Image("dot-badge")
//                    .resizable()
//                    .frame(width: 4, height: 4)
//            }
//            .padding(.bottom, 12)
//            .padding(.top, 20)
//            .frame(maxWidth: .infinity, alignment: .topLeading)
//            
//            HStack(spacing: 16) {
//                ForEach(employmentTypes.indices, id: \.self) { index in
//                    Button(action: {
//                        selectedEmploymentType = index
//                    }) {
//                        HStack(alignment: .center, spacing: 8) {
//                            Image(selectedEmploymentType == index ? "Radio Button" : "Radio Button 1")
//                                .resizable()
//                                .frame(width: 20, height: 20)
//                            
//                            Text(employmentTypes[index])
//                                .font(.system(size: 16, weight: .semibold))
//                                .foregroundStyle(Constants.Gray900)
//                        }
//                    }
//                }
//            }
//            .padding(.bottom, 12)
//            
//            if showValidationError && selectedEmploymentType == nil {
//                HStack {
//                    Image("CircleWarning")
//                        .resizable()
//                        .frame(width: 12, height: 12)
//                    
//                    Text("채용 형태 선택은 필수입니다")
//                        .font(.system(size: 14))
//                        .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
//                }
//                .padding(.bottom, 12)
//            }
//
//            // 최종학력
//            HStack(alignment: .top, spacing: 4) {
//                Text("최종학력")
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(Constants.Gray900)
//                
//                Image("dot-badge")
//                    .resizable()
//                    .frame(width: 4, height: 4)
//            }
//            .padding(.bottom, 12)
//            .padding(.top, 20)
//            .frame(maxWidth: .infinity, alignment: .topLeading)
//            
//            HStack(spacing: 16) {
//                ForEach(educationLevels.indices, id: \.self) { index in
//                    Button(action: {
//                        selectedEducationLevel = index
//                    }) {
//                        HStack(alignment: .center, spacing: 8) {
//                            Image(selectedEducationLevel == index ? "Radio Button" : "Radio Button 1")
//                                .resizable()
//                                .frame(width: 20, height: 20)
//                            
//                            Text(educationLevels[index])
//                                .font(.system(size: 16, weight: .semibold))
//                                .foregroundStyle(Constants.Gray900)
//                        }
//                    }
//                }
//            }
//            .padding(.bottom, 12)
//            
//            if showValidationError && selectedEducationLevel == nil {
//                HStack {
//                    Image("CircleWarning")
//                        .resizable()
//                        .frame(width: 12, height: 12)
//                    
//                    Text("최종학력 선택은 필수입니다")
//                        .font(.system(size: 14))
//                        .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
//                }
//                .padding(.bottom, 12)
//            }
//            
//            HStack(alignment: .top, spacing: 4) {
//                Text("제목")
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(Constants.Gray900)
//                
//                Image("dot-badge")
//                    .resizable()
//                    .frame(width: 4, height: 4)
//            }
//            .padding(.bottom, 12)
//            .padding(.top, 20)
//            .frame(maxWidth: .infinity, alignment: .topLeading)
//            
//            // 제목 텍스트 필드 생성
//            VStack(alignment: .leading, spacing: 4) {
//                ZStack(alignment: .leading) {
//                    if titleText.isEmpty {
//                        Text("")
//                            .foregroundColor(showValidationError ? Color(red: 1, green: 0.29, blue: 0.29) : Constants.Gray500)
//                            .padding(.horizontal, 8)
//                    }
//                    TextField("제목을 입력해주세요", text: $titleText)
//                        .padding()
//                        .background(showValidationError && titleText.isEmpty ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100))
//                        .cornerRadius(8, corners: [.topLeft, .topRight])
//                        .overlay(
//                            Rectangle()
//                                .frame(height: 2)
//                                .foregroundColor(titleText.isEmpty && showValidationError ? Color.red : Color(Constants.Gray300))
//                                .padding(.top, 44)
//                                .padding(.horizontal, 8),
//                            alignment: .bottom
//                        )
//                        .foregroundColor(showValidationError && titleText.isEmpty ? Color(red: 1, green: 0.29, blue: 0.29) : Color(Constants.Gray900))
//                }
//                if showValidationError && titleText.isEmpty {
//                    HStack {
//                        Image("CircleWarning")
//                            .resizable()
//                            .frame(width: 12, height: 12)
//                        
//                        Text("제목은 필수 입력입니다")
//                            .font(.system(size: 14))
//                            .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
//                    }
//                }
//            }
//            
//            HStack(alignment: .top, spacing: 4) {
//                Text("내용")
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(Constants.Gray900)
//                
//                Image("dot-badge")
//                    .resizable()
//                    .frame(width: 4, height: 4)
//            }
//            .padding(.bottom, 12)
//            .padding(.top, 20)
//            .frame(maxWidth: .infinity, alignment: .topLeading)
//            
//            // 내용 텍스트 필드 생성
//            VStack(alignment: .leading, spacing: 4) {
//                ZStack(alignment: .leading) {
//                    if postText.isEmpty {
//                        Text("")
//                            .foregroundColor(showValidationError ? Color(red: 1, green: 0.29, blue: 0.29) : Constants.Gray500)
//                            .padding(.horizontal, 8)
//                    }
//                    TextField("내용을 입력해주세요", text: $postText)
//                        .frame(height: 100, alignment: .topLeading)
//                        .padding()
//                        .background(showValidationError && postText.isEmpty ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100))
//                        .cornerRadius(8, corners: [.topLeft, .topRight])
//                        .overlay(
//                            Rectangle()
//                                .frame(height: 2)
//                                .foregroundColor(postText.isEmpty && showValidationError ? Color.red : Color(Constants.Gray300))
//                                .padding(.top, 100)
//                                .padding(.horizontal, 8),
//                            alignment: .bottom
//                        )
//                        .foregroundColor(showValidationError && postText.isEmpty ? Color(red: 1, green: 0.29, blue: 0.29) : Color(Constants.Gray900))
//                }
//                if showValidationError && postText.isEmpty {
//                    HStack {
//                        Image("CircleWarning")
//                            .resizable()
//                            .frame(width: 12, height: 12)
//                        
//                        Text("내용은 필수 입력입니다")
//                            .font(.system(size: 14))
//                            .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
//                    }
//                }
//            }
//
//            // 유의사항 텍스트
//            if selectedCategoryIndex == 0 {
//                VStack(alignment: .leading, spacing: 10) {
//                    HStack(alignment: .center, spacing: 0) {
//                        Image("Warning")
//                            .resizable()
//                            .frame(width: 20, height: 20, alignment: .center)
//                        
//                        Text("질문 게시판 유의사항")
//                            .font(.system(size: 16, weight: .semibold))
//                            .foregroundStyle(Constants.Gray900)
//                            .padding(.leading, 8)
//                    }
//                    .padding(.top, 20)
//                    
//                    Text("답변 등록시 수정 및 삭제가 불가능하니 유의해 주세요.")
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundStyle(Constants.Gray600)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//            }
//        }
//        .padding(.horizontal, 24)
//        .padding(.top, 20)
//        .padding(.bottom, 12)
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}
//
//
//// MARK: -- 취업 후기 카테고리 드롭다운 바
//struct EmploymentCategoryDropDownMenu: View {
//    
//    let options: [String]
//    var menuWidth: CGFloat = 150
//    var buttonHeight: CGFloat = 44
//    var maxItemDisplayed: Int = 4
//    
//    @Binding var selectedOptionIndex: Int?
//    @Binding var showDropdown: Bool
//    @Binding var showValidationError: Bool // Validation error state
//    
//    @State private var scrollPosition: Int?
//    
//    var body: some View {
//        VStack {
//            // Dropdown Menu
//            VStack(spacing: 0) {
//                if showDropdown {
//                    let scrollViewHeight: CGFloat = options.count > maxItemDisplayed ? (buttonHeight * CGFloat(maxItemDisplayed)) : (buttonHeight * CGFloat(options.count))
//                    ScrollView {
//                        LazyVStack(spacing: 0) {
//                            ForEach(0..<options.count, id: \.self) { index in
//                                Button(action: {
//                                    withAnimation {
//                                        selectedOptionIndex = index
//                                        showDropdown.toggle()
//                                    }
//                                }, label: {
//                                    HStack {
//                                        Text(options[index])
//                                            .foregroundColor(Color(Constants.Gray900))
//                                            .fontWeight(selectedOptionIndex == index ? .bold : .regular)
//                                            .underline(selectedOptionIndex == index)
//                                    }
//                                })
//                                .padding(.leading, 16)
//                                .frame(width: menuWidth, height: buttonHeight, alignment: .leading)
//                            }
//                        }
//                        .scrollTargetLayout()
//                    }
//                    .scrollPosition(id: $scrollPosition)
//                    .scrollDisabled(options.count <= maxItemDisplayed)
//                    .frame(height: scrollViewHeight)
//                    .onAppear {
//                        scrollPosition = selectedOptionIndex
//                    }
//                }
//            }
//            
//            // Selected Item or Placeholder
//            VStack(alignment: .leading, spacing: 4) {
//                Button(action: {
//                    withAnimation {
//                        showDropdown.toggle()
//                    }
//                }, label: {
//                    HStack {
//                        if let selectedIndex = selectedOptionIndex {
//                            Text(options[selectedIndex])
//                        } else {
//                            Text("게시판 카테고리를 선택해 주세요")
//                                .foregroundColor(showValidationError ? Color(red: 1, green: 0.29, blue: 0.29) : Constants.Gray500)
//                        }
//                        Spacer()
//                        Image(systemName: "chevron.down")
//                            .foregroundStyle(Color(red: 0.46, green: 0.46, blue: 0.46))
//                            .padding(.trailing, 12)
//                            .rotationEffect(.degrees(showDropdown ? -180 : 0))
//                    }
//                })
//                .padding(.leading, 16)
//                .padding(.vertical, 13)
//                .background(RoundedRectangle(cornerRadius: 8).fill(showValidationError && selectedOptionIndex == nil ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100)))
//
//                if showValidationError && selectedOptionIndex == nil {
//                    HStack {
//                        Image("CircleWarning")
//                            .resizable()
//                            .frame(width: 12, height: 12)
//                        
//                        Text("카테고리는 필수 선택입니다")
//                            .font(.system(size: 14))
//                            .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
//                    }
//                }
//            }
//        }
//        .foregroundColor(Color(Constants.Gray900))
//    }
//}
//
//struct EmploymentCategoryDropDownMenuView: View {
//    @Binding var selectedOptionIndex: String? // Binding을 String? 타입으로 변경
//    @Binding var showValidationError: Bool // Validation error state
//    @Binding var showDropdown: Bool
//    
//    var body: some View {
//        CategoryDropDownMenu(
//            options: ["질문 게시판", "취업후기 게시판", "대학원생활 게시판", "연구주제 게시판"],
//            selectedOptionIndex: $selectedOptionIndex, // Binding 전달
//            showDropdown: $showDropdown,
//            showValidationError: $showValidationError
//        )
//    }
//}
//
//
//
//// MARK: -- 지원분야 드롭다운메뉴 바 선택된 항목의 텍스트 속성 변경하기
////struct fieldOfSupportDropDown: View {
////    
////    let options: [String]
////    var menuWidth: CGFloat = 300
////    var buttonHeight: CGFloat = 44
////    var maxItemDisplayed: Int = 4
////    
////    @Binding var selectedSupportFieldIndex: Int?
////    @Binding var showDropdown: Bool
////    @Binding var showValidationError: Bool // Validation error state
////    
////    @State private var scrollPosition: Int?
////    
////    var body: some View {
////        VStack {
////            // Dropdown Menu
////            VStack(spacing: 0) {
////                if showDropdown {
////                    let scrollViewHeight: CGFloat = options.count > maxItemDisplayed ? (buttonHeight * CGFloat(maxItemDisplayed)) : (buttonHeight * CGFloat(options.count))
////                    ScrollView {
////                        LazyVStack(spacing: 0) {
////                            ForEach(0..<options.count, id: \.self) { index in
////                                Button(action: {
////                                    withAnimation {
////                                        selectedSupportFieldIndex = index
////                                        showDropdown.toggle()
////                                    }
////                                }, label: {
////                                    HStack {
////                                        Text(options[index])
////                                            .foregroundColor(Color(Constants.Gray900))
////                                            .fontWeight(selectedSupportFieldIndex == index ? .bold : .regular)
////                                            .underline(selectedSupportFieldIndex == index)
////                                    }
////                                })
////                                .padding(.leading, 16)
////                                .frame(width: menuWidth, height: buttonHeight, alignment: .leading)
////                            }
////                        }
////                        .scrollTargetLayout()
////                    }
////                    .scrollPosition(id: $scrollPosition)
////                    .scrollDisabled(options.count <= maxItemDisplayed)
////                    .frame(height: scrollViewHeight)
////                    .onAppear {
////                        scrollPosition = selectedSupportFieldIndex
////                    }
////                }
////            }
////            
////            // Selected Item or Placeholder
////            VStack(alignment: .leading, spacing: 4) {
////                Button(action: {
////                    withAnimation {
////                        showDropdown.toggle()
////                    }
////                }, label: {
////                    HStack {
////                        if let selectedIndex = selectedSupportFieldIndex {
////                            Text(options[selectedIndex])
////                        } else {
////                            Text("지원분야를 선택해 주세요")
////                                .foregroundColor(showValidationError ? Color(red: 1, green: 0.29, blue: 0.29) : Constants.Gray500)
////                        }
////                        Spacer()
////                        Image(systemName: "chevron.down")
////                            .foregroundStyle(Color(red: 0.46, green: 0.46, blue: 0.46))
////                            .padding(.trailing, 12)
////                            .rotationEffect(.degrees(showDropdown ? -180 : 0))
////                    }
////                })
////                .padding(.leading, 16)
////                .padding(.vertical, 13)
////                .background(RoundedRectangle(cornerRadius: 8).fill(showValidationError && selectedSupportFieldIndex == nil ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100)))
////
////                if showValidationError && selectedSupportFieldIndex == nil {
////                    HStack {
////                        Image("CircleWarning")
////                            .resizable()
////                            .frame(width: 12, height: 12)
////                        
////                        Text("지원분야는 필수 선택입니다")
////                            .font(.system(size: 14))
////                            .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
////                    }
////                }
////            }
////        }
////        .foregroundColor(Color(Constants.Gray900))
////    }
////}
//
//#Preview {
//    EmploymentReviewWriteBoardViewController()
//}

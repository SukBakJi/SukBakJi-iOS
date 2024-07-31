import SwiftUI

struct BoardWriteBoardViewController: View {
    
    @State private var selectedCategory: Int? = nil
    @State private var titleText: String = "" // 제목 텍스트 필드의 상태를 관리하기 위한 변수
    @State private var postText: String = "" // 내용 텍스트 필드의 상태를 관리하기 위한 변수
    @State private var selectedOptionIndex: Int? = nil // DropDown 메뉴에서 선택된 옵션의 인덱스
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showValidationError = false // Validation error state

    var isFormValid: Bool {
        selectedCategory != nil && !titleText.isEmpty && !postText.isEmpty
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // 뒤로가기 버튼
                    Button(action: {
                        // 뒤로가기 버튼 클릭 시 동작할 코드
                        print("뒤로가기 버튼 tapped")
                        self.presentationMode.wrappedValue.dismiss()
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
                                     postText: $postText,
                                     selectedOptionIndex: $selectedOptionIndex,
                                     showValidationError: $showValidationError) // 전달 추가
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .center, spacing: 0) {
                            Button(action: {
                                if isFormValid {
                                    print("게시물 등록하기 버튼 tapped")
                                } else {
                                    showValidationError = true
                                }
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
                        .frame(alignment: .center)
                    }
                    
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .frame(alignment: .topLeading)
                .background(Constants.White)
                .shadow(color: .black.opacity(0.15), radius: 3.5, x: 0, y: 0)
            }
        }
        .navigationBarBackButtonHidden()
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
    @Binding var selectedOptionIndex: Int? // DropDown 메뉴에서 선택된 옵션의 인덱스
    @Binding var showValidationError: Bool // Validation error state

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top, spacing: 4) {
                        Text("게시판 선택")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Constants.Gray900)
                        
                        Image("dot-badge")
                            .resizable()
                            .frame(width: 4, height: 4)
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
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text("카테고리")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Constants.Gray900)
                        
                        Image("dot-badge")
                            .resizable()
                            .frame(width: 4, height: 4)
                    }
                    .padding(.bottom, 12)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    DropDownMenuView(selectedOptionIndex: $selectedOptionIndex, showValidationError: $showValidationError) // 전달 추가
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text("제목")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Constants.Gray900)
                        
                        Image("dot-badge")
                            .resizable()
                            .frame(width: 4, height: 4)
                    }
                    .padding(.bottom, 12)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    // 텍스트 필드 생성
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("제목을 입력해주세요", text: $titleText)
                            .padding() // 텍스트 필드 내부 여백
                            .background(showValidationError && titleText.isEmpty ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100))
                            .cornerRadius(8) // 모서리 둥글게
                            .foregroundColor(showValidationError && titleText.isEmpty ? Color(red: 1, green: 0.29, blue: 0.29) : Color(Constants.Gray900)) // 텍스트 색상 (선택 사항)
                        
                        if showValidationError && titleText.isEmpty {
                            Text("제목은 필수 입력입니다")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text("내용")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Constants.Gray900)
                        
                        Image("dot-badge")
                            .resizable()
                            .frame(width: 4, height: 4)
                    }
                    .padding(.bottom, 12)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    // 텍스트 필드 생성
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("내용을 입력해주세요", text: $postText)
                            .frame(height: 100, alignment: .topLeading)
                            .padding() // 텍스트 필드 내부 여백
                            .background(showValidationError && postText.isEmpty ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100))
                            .cornerRadius(8) // 모서리 둥글게
                            .foregroundColor(showValidationError && postText.isEmpty ? Color(red: 1, green: 0.29, blue: 0.29) : Color(Constants.Gray900)) // 텍스트 색상 (선택 사항)
                        
                        if showValidationError && postText.isEmpty {
                            Text("내용은 필수 입력입니다")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                        }
                    }

                    // 유의사항 텍스트
                    if selectedOptionIndex == 0 {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .center, spacing: 0) {
                                Image("Warning")
                                    .resizable()
                                    .frame(width:20, height: 20, alignment: .center)
                                
                                
                                Text("질문 게시판 유의사항")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Constants.Gray900)
                                    .padding(.leading, 8)
                            }
                            .padding(.top, 20)
                            
                            Text("답변 등록시 수정 및 삭제가 불가능하니 유의해 주세요.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Constants.Gray600)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
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
    @Binding var showValidationError: Bool // Validation error state
    
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
                                            .fontWeight(selectedOptionIndex == index ? .bold : .regular)
                                            .underline(selectedOptionIndex == index)
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
            VStack(alignment: .leading, spacing: 4) {
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
                                .foregroundColor(showValidationError ? Color(red: 1, green: 0.29, blue: 0.29) : Constants.Gray500)
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
                .background(RoundedRectangle(cornerRadius: 8).fill(showValidationError && selectedOptionIndex == nil ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100)))

                if showValidationError && selectedOptionIndex == nil {
                    Text("카테고리는 필수 선택입니다")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                }
            }
        }
        .foregroundColor(Color(Constants.Gray900))
    }
}


struct DropDownMenuView: View {
    @Binding var selectedOptionIndex: Int? // Binding 추가
    @Binding var showValidationError: Bool // Validation error state
    @State private var showDropdown = false
    
    var body: some View {
        DropDownMenu(options: ["질문 게시판", "취업후기 게시판", "대학원생활 게시판", "연구주제 게시판"],
                     selectedOptionIndex: $selectedOptionIndex, // Binding 전달
                     showDropdown: $showDropdown,
                     showValidationError: $showValidationError)
    }
}


#Preview {
    BoardWriteBoardViewController()
}


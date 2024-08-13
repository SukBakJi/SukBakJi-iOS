import SwiftUI
import Foundation
import Alamofire

struct BoardWriteBoardViewController: View {
    
    @State private var selectedCategory: Int? = nil
    @State private var titleText: String = "" // 제목 텍스트 필드의 상태를 관리하기 위한 변수
    @State private var postText: String = "" // 내용 텍스트 필드의 상태를 관리하기 위한 변수
    @State private var selectedOptionIndex: Int? = nil // DropDown 메뉴에서 선택된 옵션의 인덱스
    @State private var selectedSupportFieldIndex: Int? = nil // 지원분야 드롭다운 메뉴에서 선택된 옵션의 인덱스
    @State private var selectedJob: String? = nil // 직무
    @State private var selectedEmploymentType: Int? = nil // 채용 형태 선택
    @State private var selectedEducationLevel: Int? = nil // 최종학력 선택
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showValidationError = false // Validation error state
    @State private var showCategoryDropdown = false // 카테고리 드롭다운 메뉴 표시 상태
    @State private var showSupportFieldDropdown = false // 지원분야 드롭다운 메뉴 표시 상태
    
    // MARK: - api 연결 변수
    @State private var postResult: BoardWriteGetModel? = nil // 응답 결과를 저장할 상태 변수


    var isFormValid: Bool {
        selectedCategory != nil && selectedOptionIndex != nil && (!showExtraFields || (selectedSupportFieldIndex != nil && selectedEmploymentType != nil && selectedEducationLevel != nil)) && !titleText.isEmpty && !postText.isEmpty
    }

    var showExtraFields: Bool {
        return (selectedCategory == 0 || selectedCategory == 1) && selectedOptionIndex == 1
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
                    SeokBakji()
                    WriteBoardDetail(
                        selectedCategory: $selectedCategory,
                        titleText: $titleText,
                        postText: $postText,
                        selectedOptionIndex: $selectedOptionIndex,
                        selectedSupportFieldIndex: $selectedSupportFieldIndex,
                        selectedJob: $selectedJob,
                        selectedEmploymentType: $selectedEmploymentType,
                        selectedEducationLevel: $selectedEducationLevel,
                        showValidationError: $showValidationError,
                        showCategoryDropdown: $showCategoryDropdown,
                        showSupportFieldDropdown: $showSupportFieldDropdown,
                        showExtraFields: showExtraFields
                    )
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
    func BoardWriteApi() {
        let url = "https://54.180.165.121:8080/api/posts/create"

        // 옵셔널 바인딩을 통해 nil이 아닌 값을 추출하거나, 기본값을 사용할 수 있습니다.
        let supportField = selectedSupportFieldIndex != nil ? "Some Support Field" : nil // 실제 데이터에 따라 적절히 설정
        let job = selectedJob ?? ""
        let hiringType = selectedEmploymentType != nil ? "Some Hiring Type" : nil // 실제 데이터에 따라 적절히 설정
        let finalEducation = selectedEducationLevel != nil ? "Some Education Level" : nil // 실제 데이터에 따라 적절히 설정

        // POST 요청에 필요한 파라미터 구성
        let postParameters = BoardWritePostModel(
            menu: selectedCategory ?? 0,
            boardName: "Some Board Name", // 실제 데이터에 따라 적절히 설정
            title: titleText,
            content: postText,
            supportField: supportField,
            job: job,
            hiringType: hiringType,
            finalEducation: finalEducation
        )

        AF.request(url,
                   method: .post,
                   parameters: postParameters,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoardWriteGetModel.self) { response in
                switch response.result {
                case .success(let data):
                    // 서버로부터 데이터를 정상적으로 받아왔을 때
                    print("Success: \(data)")
                    
                    // 필요한 경우 받아온 데이터를 사용하여 UI 업데이트 등 수행
                    self.postResult = data
                    
                case .failure(let error):
                    // 오류가 발생했을 때
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
}

struct SeokBakji: View {
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
    
    let boardCategory: [String] = ["박사", "석사", "입학예정"]
    
    @Binding var selectedCategory: Int? // 선택된 카테고리
    @Binding var titleText: String // 제목 텍스트 필드의 상태
    @Binding var postText: String // 내용 텍스트 필드의 상태
    @Binding var selectedOptionIndex: Int? // DropDown 메뉴에서 선택된 옵션의 인덱스
    @Binding var selectedSupportFieldIndex: Int? // 지원분야 드롭다운 메뉴에서 선택된 옵션의 인덱스
    @Binding var selectedJob: String? // 직무 텍스트 필드
    @Binding var selectedEmploymentType: Int? // 채용 형태 선택
    @Binding var selectedEducationLevel: Int? // 최종학력 선택
    @Binding var showValidationError: Bool // Validation error state
    @Binding var showCategoryDropdown: Bool
    @Binding var showSupportFieldDropdown: Bool
    var showExtraFields: Bool

    var boardCategories: [String] {
        switch selectedCategory {
        case 0:
            return ["질문 게시판", "취업후기 게시판", "대학원생활 게시판", "연구주제 게시판"]
        case 1:
            return ["질문 게시판", "취업후기 게시판", "박사지원 게시판", "대학원생활 게시판", "박사합격 후기", "연구주제 게시판"]
        case 2:
            return ["질문 게시판", "석사합격 후기", "학부연구생 게시판", "석사지원 게시판", "석박사통합지원 게시판"]
        default:
            return []
        }
    }

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
                            ForEach(boardCategory.indices, id: \.self) { index in
                                Button(action: {
                                    selectedCategory = index
                                    selectedOptionIndex = nil // Reset the selected option when category changes
                                    selectedSupportFieldIndex = nil
                                    selectedEmploymentType = nil
                                    selectedEducationLevel = nil
                                }) {
                                    HStack(alignment: .center, spacing: 8) {
                                        Image(selectedCategory == index ? "Radio Button" : "Radio Button 1")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        
                                        Text(boardCategory[index])
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
                    
                    CategoryDropDownMenuView(options: boardCategories, selectedOptionIndex: $selectedOptionIndex, showValidationError: $showValidationError, showDropdown: $showCategoryDropdown) // 전달 추가
                    
                    if showExtraFields {
                        // 지원분야 드롭다운
                        HStack(alignment: .top, spacing: 4) {
                            Text("지원분야")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Constants.Gray900)
                            
                            Image("dot-badge")
                                .resizable()
                                .frame(width: 4, height: 4)
                        }
                        .padding(.bottom, 12)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        fieldOfSupportDropDown(
                            options: ["기획·전략", "법무", "인사·HR", "회계·세무", "마케팅·광고·MD", "개발·데이터", "디자인", "물류·무역", "운전·운송·배송", "영업", "고객상담·TM", "금융·보험", "식·음료", "고객서비스·리테일", "엔지니어링·설계", "제조·생산", "교육", "건축·시설", "의료·바이오", "미디어·문화·스포츠", "공공·복지", "기타"],
                            selectedSupportFieldIndex: $selectedSupportFieldIndex,
                            showDropdown: $showSupportFieldDropdown,
                            showValidationError: $showValidationError
                        )
                        
                        // 직무
                        HStack(alignment: .top, spacing: 4) {
                            Text("직무")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Constants.Gray900)
                            
                            Image("dot-badge")
                                .resizable()
                                .frame(width: 4, height: 4)
                        }
                        .padding(.bottom, 12)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        // 제목 텍스트 필드 생성
                        VStack(alignment: .leading, spacing: 4) {
                            ZStack(alignment: .leading) {
                                if titleText.isEmpty {
                                    Text("")
                                        .foregroundColor(showValidationError ? Color(red: 1, green: 0.29, blue: 0.29) : Constants.Gray500)
                                        .padding(.horizontal, 8)
                                }
                                TextField("직무를 입력해주세요", text: $titleText)
                                    .padding()
                                    .background(showValidationError && titleText.isEmpty ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100))
                                    .cornerRadius(8, corners: [.topLeft, .topRight])
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundColor(titleText.isEmpty && showValidationError ? Color.red : Color(Constants.Gray300))
                                            .padding(.top, 44)
                                            .padding(.horizontal, 8),
                                        alignment: .bottom
                                    )
                                    .foregroundColor(showValidationError && titleText.isEmpty ? Color(red: 1, green: 0.29, blue: 0.29) : Color(Constants.Gray900))
                            }
                            if showValidationError && titleText.isEmpty {
                                HStack {
                                    Image("CircleWarning")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    
                                    Text("제목은 필수 입력입니다")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                                }
                            }
                        }
                        
                        // 채용 형태
                        HStack(alignment: .top, spacing: 4) {
                            Text("채용 형태")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Constants.Gray900)
                            
                            Image("dot-badge")
                                .resizable()
                                .frame(width: 4, height: 4)
                        }
                        .padding(.bottom, 12)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        HStack(spacing: 16) {
                            ForEach(["신입", "경력"].indices, id: \.self) { index in
                                Button(action: {
                                    selectedEmploymentType = index
                                }) {
                                    HStack(alignment: .center, spacing: 8) {
                                        Image(selectedEmploymentType == index ? "Radio Button" : "Radio Button 1")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        
                                        Text(["신입", "경력"][index])
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(Constants.Gray900)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 12)
                        
                        if showValidationError && selectedEmploymentType == nil {
                            HStack {
                                Image("CircleWarning")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                
                                Text("채용 형태 선택은 필수입니다")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                            }
                            .padding(.bottom, 12)
                        }

                        // 최종학력
                        HStack(alignment: .top, spacing: 4) {
                            Text("최종학력")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Constants.Gray900)
                            
                            Image("dot-badge")
                                .resizable()
                                .frame(width: 4, height: 4)
                        }
                        .padding(.bottom, 12)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        HStack(spacing: 16) {
                            ForEach(["박사", "석사"].indices, id: \.self) { index in
                                Button(action: {
                                    selectedEducationLevel = index
                                }) {
                                    HStack(alignment: .center, spacing: 8) {
                                        Image(selectedEducationLevel == index ? "Radio Button" : "Radio Button 1")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        
                                        Text(["박사", "석사"][index])
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(Constants.Gray900)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 12)
                        
                        if showValidationError && selectedEducationLevel == nil {
                            HStack {
                                Image("CircleWarning")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                
                                Text("최종학력 선택은 필수입니다")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                            }
                            .padding(.bottom, 12)
                        }
                    }
                    
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
                    
                    // 제목 텍스트 필드 생성
                    VStack(alignment: .leading, spacing: 4) {
                        ZStack(alignment: .leading) {
                            if titleText.isEmpty {
                                Text("")
                                    .foregroundColor(showValidationError ? Color(red: 1, green: 0.29, blue: 0.29) : Constants.Gray500)
                                    .padding(.horizontal, 8)
                            }
                            TextField("제목을 입력해주세요", text: $titleText)
                                .padding()
                                .background(showValidationError && titleText.isEmpty ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100))
                                .cornerRadius(8, corners: [.topLeft, .topRight])
                                .overlay(
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(titleText.isEmpty && showValidationError ? Color.red : Color(Constants.Gray300))
                                        .padding(.top, 44)
                                        .padding(.horizontal, 8),
                                    alignment: .bottom
                                )
                                .foregroundColor(showValidationError && titleText.isEmpty ? Color(red: 1, green: 0.29, blue: 0.29) : Color(Constants.Gray900))
                        }
                        if showValidationError && titleText.isEmpty {
                            HStack {
                                Image("CircleWarning")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                
                                Text("제목은 필수 입력입니다")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                            }
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
                    
                    // 내용 텍스트 필드 생성
                    VStack(alignment: .leading, spacing: 4) {
                        ZStack(alignment: .leading) {
                            if postText.isEmpty {
                                Text("")
                                    .foregroundColor(showValidationError ? Color(red: 1, green: 0.29, blue: 0.29) : Constants.Gray500)
                                    .padding(.horizontal, 8)
                            }
                            TextField("내용을 입력해주세요", text: $postText)
                                .frame(height: 100, alignment: .topLeading)
                                .padding()
                                .background(showValidationError && postText.isEmpty ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100))
                                .cornerRadius(8, corners: [.topLeft, .topRight])
                                .overlay(
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(postText.isEmpty && showValidationError ? Color.red : Color(Constants.Gray300))
                                        .padding(.top, 100)
                                        .padding(.horizontal, 8),
                                    alignment: .bottom
                                )
                                .foregroundColor(showValidationError && postText.isEmpty ? Color(red: 1, green: 0.29, blue: 0.29) : Color(Constants.Gray900))
                        }
                        if showValidationError && postText.isEmpty {
                            HStack {
                                Image("CircleWarning")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                
                                Text("내용은 필수 입력입니다")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                            }
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

struct CategoryDropDownMenu: View {
    
    let options: [String]
    var menuWidth: CGFloat = 150
    var buttonHeight: CGFloat = 44
    var maxItemDisplayed: Int = 6
    
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
                                            .foregroundColor(selectedOptionIndex == index ? Constants.Orange700 : Constants.Gray900)
                                            .padding(16)
                                            .frame(height: buttonHeight, alignment: .leading)
                                            .background(selectedOptionIndex == index ? Color(red: 0.99, green: 0.91, blue: 0.9) : Color.clear)
                                            .cornerRadius(8, corners: .allCorners)
                                    }
                                })
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
                    HStack {
                        Image("CircleWarning")
                            .resizable()
                            .frame(width: 12, height: 12)
                        
                        Text("카테고리는 필수 선택입니다")
                            .font(.system(size: 14))
                        .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                    }
                }
            }
        }
        .foregroundColor(Color(Constants.Gray900))
    }
}

struct CategoryDropDownMenuView: View {
    let options: [String]
    @Binding var selectedOptionIndex: Int? // Binding 추가
    @Binding var showValidationError: Bool // Validation error state
    @Binding var showDropdown: Bool
    
    var body: some View {
        CategoryDropDownMenu(options: options,
                     selectedOptionIndex: $selectedOptionIndex, // Binding 전달
                     showDropdown: $showDropdown,
                     showValidationError: $showValidationError)
    }
}

struct fieldOfSupportDropDown: View {
    
    let options: [String]
    var menuWidth: CGFloat = 300
    var buttonHeight: CGFloat = 44
    var maxItemDisplayed: Int = 4
    
    @Binding var selectedSupportFieldIndex: Int?
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
                                        selectedSupportFieldIndex = index
                                        showDropdown.toggle()
                                    }
                                }, label: {
                                    HStack {
                                        Text(options[index])
                                            .foregroundColor(selectedSupportFieldIndex == index ? Constants.Orange700 : Constants.Gray900)
                                            .fontWeight(selectedSupportFieldIndex == index ? .bold : .regular)
                                            .underline(selectedSupportFieldIndex == index)
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
                        scrollPosition = selectedSupportFieldIndex
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
                        if let selectedIndex = selectedSupportFieldIndex {
                            Text(options[selectedIndex])
                        } else {
                            Text("지원분야를 선택해 주세요")
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
                .background(RoundedRectangle(cornerRadius: 8).fill(showValidationError && selectedSupportFieldIndex == nil ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100)))

                if showValidationError && selectedSupportFieldIndex == nil {
                    HStack {
                        Image("CircleWarning")
                            .resizable()
                            .frame(width: 12, height: 12)
                        
                        Text("지원분야는 필수 선택입니다")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                    }
                }
            }
        }
        .foregroundColor(Color(Constants.Gray900))
    }
}

#Preview {
    BoardWriteBoardViewController()
}


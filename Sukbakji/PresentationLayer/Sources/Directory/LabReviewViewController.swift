import SwiftUI
import Alamofire

struct LabReviewViewController: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isSearchActive: Bool = false // 검색 바 클릭 상태 변수
    @State private var reviews: [LabReviewListInfo] = [] // 초기 리뷰 목록
    @State private var searchResults: [DirectoryLabReviewSearchGetResult] = [] // 검색 결과 목록
    @State private var showMoreReviews: Bool = false // '연구실 후기 더보기' 버튼 상태 변수
    @State private var isLoading: Bool = true // 로딩 상태 변수
    @State private var errorMessage: String? = nil // 에러 메시지 상태 변수
    @State private var searchQuery: String = "" // 검색어 저장 변수

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // 뒤로가기 버튼
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        print("뒤로가기 버튼 tapped")
                    }) {
                        Image("BackButton")
                            .frame(width: Constants.nav, height: Constants.nav)
                    }
                    
                    Spacer()
                    
                    Text("연구실 후기")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXl)
                                .weight(Constants.fontWeightSemiBold)
                        )
                        .foregroundColor(Constants.Gray900)
                        .frame(alignment: .center)
                    
                    Spacer()
                    
                    // 더보기 버튼 (공간 확보용)
                    Image("")
                        .resizable()
                        .frame(width: Constants.nav, height: Constants.nav)
                }
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            VStack(alignment: .center, spacing: 8) {
                                Text("지도교수명을 검색해 주세요")
                                    .font(Font.custom("Pretendard", size: 18).weight(.semibold))
                                    .foregroundColor(Constants.Gray900)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("연구실에 대한 정보를 한 눈에 보세요")
                                    .font(Font.custom("Pretendard", size: 14))
                                    .foregroundColor(Constants.Gray500)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .overlay(
                                Image("Folder 1")
                                    .resizable()
                                    .opacity(0.5)
                                    .offset(x: 8, y: 11.25)
                                    .frame(width: 107.16239, height: 87.06912), alignment: .topTrailing
                            )
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        .padding(.bottom, 16)
                        
                        // 검색창
                        VStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8)
                                
                                TextField("지도교수명을 입력해 주세요", text: $searchQuery, onCommit: {
                                    searchForProfessor()
                                })
                                .font(.system(size: 14))
                                .foregroundColor(Constants.Gray900)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 4)
                                
                                Spacer()
                            }
                            .padding(.leading, 4)
                            .background(Constants.Gray50)
                            .cornerRadius(8)
                            .padding(.horizontal, 24)
                        }
                        .offset(y: -20) // 원하는 만큼의 위쪽 이동 (값은 조정 가능)

                        // 검색 결과 표시
                        if !searchResults.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("검색 결과")
                                        .font(Font.custom("Pretendard", size: 18).weight(Constants.fontWeightSemiBold))
                                        .foregroundColor(Constants.Gray900)
                                        .padding(.top, 28)
                                    
                                    Spacer() // 최신 연구실 후기와 일치하도록 추가
                                }
                                .padding(.horizontal, 24)

                                ForEach(searchResults, id: \.content) { review in
                                    DirectoryLabReviewSearchResultView(review: review)
                                }
                                .padding(.horizontal, 24)
                            }
                        } else if !isSearchActive {
                            // 최신 연구실 후기
                            if isLoading {
                                ProgressView("로딩 중...")
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()
                            } else if let errorMessage = errorMessage {
                                Text("Error: \(errorMessage)")
                                    .foregroundColor(.red)
                                    .padding()
                            } else {
                                // 최신 연구실 후기 부분 (수정된 ForEach와 버튼)
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Text("최신 연구실 후기")
                                            .font(Font.custom("Pretendard", size: 18).weight(Constants.fontWeightSemiBold))
                                            .foregroundColor(Constants.Gray900)
                                            .padding(.top, 28)
                                        
                                        Spacer() // 검색 결과와 일치하도록 추가
                                    }
                                    .padding(.horizontal, 24)

                                    ForEach(reviews.prefix(showMoreReviews ? reviews.count : 3), id: \.content) { review in
                                        LabReviewView(review: review)
                                            .transition(.move(edge: .bottom).combined(with: .opacity))
                                    }
                                    .padding(.horizontal, 24)
                                    
                                    if reviews.count > 3 {
                                        Button(action: {
                                            withAnimation(.easeInOut) {
                                                showMoreReviews.toggle()
                                            }
                                            print("연구실 후기 더보기 버튼 tapped")
                                        }) {
                                            Spacer()
                                            
                                            HStack {
                                                Text(showMoreReviews ? "숨기기" : "연구실 후기 더보기")
                                                    .font(Font.custom("Pretendard", size: Constants.fontSize7).weight(.regular))
                                                    .foregroundColor(Constants.Gray900)
                                                
                                                Image(showMoreReviews ? "hide" : "More 2")
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
                                            
                                            Spacer()
                                        }
                                        .padding(.top, 16)
                                        .padding(.bottom, 48)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            loadLabReviews()
        }
    }
    
    func loadLabReviews() {
        let url = APIConstants.baseURL + "/labs/reviews"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        NetworkAuthManager.shared.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LabReviewListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        self.reviews = data.result
                    } else {
                        self.errorMessage = data.message
                    }
                    self.isLoading = false
                case .failure(let error):
                    if let data = response.data,
                       let errorMessage = String(data: data, encoding: .utf8) {
                        print("Server error response: \(errorMessage)")
                    }
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
    }
    
    func searchForProfessor() {
        guard !searchQuery.isEmpty else { return }
        
        let url = APIConstants.baseURL + "/labs/reviews/search"
        let parameters = DirectoryLabReviewSearchPostModel(professorName: searchQuery)
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        NetworkAuthManager.shared.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DirectoryLabReviewSearchGetModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        self.searchResults = data.result
                    } else {
                        self.errorMessage = data.message
                    }
                    self.isSearchActive = true
                case .failure(let error):
                    if let data = response.data,
                       let errorMessage = String(data: data, encoding: .utf8) {
                        print("Server error response: \(errorMessage)")
                    }
                    self.errorMessage = error.localizedDescription
                    self.isSearchActive = true
                }
            }
    }
}

struct LabReviewView: View {
    var review: LabReviewListInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(review.universityName)
                .font(Font.custom("Pretendard", size: Constants.fontSize6).weight(Constants.fontWeightMedium))
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(review.departmentName)
                .font(Font.custom("Pretendard", size: Constants.fontSize5).weight(Constants.fontWeightSemiBold))
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(review.content)
                .font(Font.custom("Pretendard", size: Constants.fontSize6).weight(Constants.fontWeightMedium))
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            HStack(alignment: .center, spacing: 6) {
                KeywordView(keywordName: "지도력이 \(review.leadershipStyle)")
                KeywordView(keywordName: "인건비가 \(review.salaryLevel)")
                KeywordView(keywordName: "자율성이 \(review.autonomy)")
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

struct DirectoryLabReviewSearchResultView: View {
    var review: DirectoryLabReviewSearchGetResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(review.universityName)
                .font(Font.custom("Pretendard", size: Constants.fontSize6).weight(Constants.fontWeightMedium))
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(review.departmentName)
                .font(Font.custom("Pretendard", size: Constants.fontSize5).weight(Constants.fontWeightSemiBold))
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(review.content)
                .font(Font.custom("Pretendard", size: Constants.fontSize6).weight(Constants.fontWeightMedium))
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            HStack(alignment: .center, spacing: 6) {
                KeywordView(keywordName: "지도력이 \(review.leadershipStyle)")
                KeywordView(keywordName: "인건비가 \(review.salaryLevel)")
                KeywordView(keywordName: "자율성이 \(review.autonomy)")
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
            .font(
                Font.custom("Pretendard", size: Constants.fontSizeXs)
                    .weight(Constants.fontWeightMedium)
            )
            .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
            .padding(.horizontal, 6) // 패딩 줄임
            .padding(.vertical, 3)
            .background(Color(red: 0.99, green: 0.91, blue: 0.9))
            .cornerRadius(4)
            .lineLimit(1) // 한 줄 유지
            .minimumScaleFactor(0.8) // 너무 길면 글씨 크기 줄이기
            .fixedSize(horizontal: true, vertical: false) // 자동 줄바꿈 방지
    }
}

#Preview {
    LabReviewViewController()
}


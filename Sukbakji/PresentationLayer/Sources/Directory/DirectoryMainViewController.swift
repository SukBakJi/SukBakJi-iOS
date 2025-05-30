import SwiftUI
import Alamofire

struct DirectoryMainViewController: View {
    
    @State private var selectedButton: String? = "" // 기본값을 '메인'으로 설정
    @State private var searchText: String = "" // 검색 텍스트 상태 변수
    @State private var isSearchActive: Bool = false // 검색 바 클릭 상태 변수
    @State private var hasScrappedLaboratories: Bool = true // 연구실이 있는지 여부를 나타내는 Bool 변수
    @State private var latestReview: LabReviewListInfo? = nil // 가장 최근 연구실 후기
    @State private var isLoading: Bool = true // 로딩 상태 변수
    @State private var errorMessage: String? = nil // 에러 메시지 상태 변수
    @State private var interestTopics: [String] = [] // 관심 주제 상태 변수
    @State private var scrappedLaboratories: [ScrappedLabResult] = [] // 즐겨찾기 연구실 목록
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Text("연구실 디렉토리")
                            .font(.system(size: 22, weight: .bold))
                        
                        Spacer()
                        
                        Button(action: {
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let rootVC = windowScene.windows.first?.rootViewController as? UINavigationController {
                                let notificationVC = NotificationViewController()
                                rootVC.pushViewController(notificationVC, animated: true)
                            }
                        }) {
                            Image("Bell")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                        
                        Button(action: {
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let rootVC = windowScene.windows.first?.rootViewController as? UINavigationController {
                                let mypageVC = MypageViewController()
                                rootVC.pushViewController(mypageVC, animated: true)
                            }
                        }) {
                            Image("MyPage")
                                .resizable()
                                .frame(width: 48, height: 48)
                        }
                    }
                    .padding(.leading, 24)
                    .padding(.trailing, 8)
                    
                    Divider()
                    
                    // MARK: -- 검색창
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            NavigationLink(destination: DirectorySearchViewController(searchText: $searchText)) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 8) // 아이콘 왼쪽 여백
                                    
                                    Text("학과와 연구 주제로 검색해 보세요")
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
                                .font(Font.custom("Pretendard", size: 18).weight(.semibold))
                                .foregroundColor(Constants.Gray900)
                            
                            Image("Magnifier 1")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Spacer()
                            
                            // Only show "더보기" button if there are scrapped laboratories
                            if !scrappedLaboratories.isEmpty {
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
                        .padding(.top, 28)
                        .padding(.bottom, 12)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Constants.White)
                        .padding(.horizontal, 24)
                        
                        // Show EmptyScrappedLaboratory if no scrapped laboratories
                        if scrappedLaboratories.isEmpty {
                            EmptyScrappedLaboratory()
                                .frame(maxWidth: .infinity, minHeight: 150)
                                .background(Constants.Gray50)
                                .cornerRadius(12)
                                .padding(.horizontal, 24)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(scrappedLaboratories, id: \.labId) { lab in
                                        ScrappedLaboratory(
                                            title: lab.universityName,
                                            universityName: lab.universityName,
                                            labName: lab.labName,
                                            professorName: lab.professorName,
                                            labId: lab.labId,
                                            researchTopics: lab.researchTopics
                                        )
                                        .frame(width: 300)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        
                        HStack(alignment: .center) {
                            Text("관심 주제 모아보기")
                                .font(Font.custom("Pretendard", size: 18).weight(.semibold))
                                .foregroundColor(Constants.Gray900)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .frame(alignment: .center)
                        .background(Constants.White)
                        
                        // 관심 주제 표시
                        if isLoading {
                            ProgressView("로딩 중...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        } else if !interestTopics.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(interestTopics, id: \.self) { topic in
                                        TagView(tagName: topic)
                                            .padding(.top, 12)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        } else if let errorMessage = errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            Text("관심 주제가 없습니다.")
                                .foregroundColor(Constants.Gray500)
                                .padding(.horizontal, 24)
                        }
                        
                        // 광고 배너 뷰
                        AdvertisementView()
                            .padding(.top, 20)
                        
                        // 연구실 후기 표시
                        if isLoading {
                            ProgressView("로딩 중...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        } else if let latestReview = latestReview {
                            HStack(alignment: .center) {
                                Text("연구실 후기")
                                    .font(Font.custom("Pretendard", size: 18).weight(.semibold))
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
                            
                            LabReviewView(review: latestReview)
                                .padding(.horizontal, 24)
                                .padding(.bottom, 48)
                        } else if let errorMessage = errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            Text("아직 연구실 후기가 없습니다.")
                                .foregroundColor(Constants.Gray500)
                                .padding(.horizontal, 24)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadLatestLabReview()
            loadInterestTopics()
            loadScrappedLaboratories()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("BookmarkStatusChanged"))) { _ in
            // 즐겨찾기 상태 변경 알림을 받으면 즐겨찾기 데이터를 다시 로드
            loadScrappedLaboratories()
        }
    }
    
    func loadLatestLabReview() {
        let url = APIConstants.baseURL + "/labs/reviews?limit=1" // 최신 1개의 연구실 후기만 가져오기
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        NetworkAuthManager.shared.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LabReviewListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess, let review = data.result.first {
                        self.latestReview = review
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
    
    func loadInterestTopics() {
        let url = APIConstants.baseURL + "/labs/mypage/interest-topics"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        NetworkAuthManager.shared.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DirectoryInterestTopicGetModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        self.interestTopics = data.result.topics
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
    
    func loadScrappedLaboratories() {
        let url = APIConstants.baseURL + "/labs/mypage/favorite-labs"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        NetworkAuthManager.shared.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ScrappedLabModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        self.scrappedLaboratories = data.result
                    } else {
                        self.errorMessage = data.message
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
    }
}

// MARK: -- 즐겨찾는 연구실 테이블 뷰
struct ScrappedLaboratory: View {
    var title: String
    var universityName: String
    var labName: String
    var professorName: String
    var labId: Int // Add labId to the view
    var researchTopics: [String] // researchTopics를 배열로 받음
    
    var body: some View {
        NavigationLink(destination: LabDetailViewController(labId: labId)) {
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
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeXs)
                                    .weight(Constants.fontWeightMedium)
                            )
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(labName)
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeS)
                                    .weight(Constants.fontWeightSemiBold)
                            )
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
                                        .font(
                                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                                .weight(Constants.fontWeightSemiBold)
                                        )
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Text("교수")
                                        .font(
                                            Font.custom("Pretendard", size: Constants.fontSizeXs)
                                                .weight(Constants.fontWeightMedium)
                                        )
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                
                                Text("\(universityName) \(labName)")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSizeXs)
                                            .weight(Constants.fontWeightMedium)
                                    )
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        // 연구 주제들 출력
                        HStack(spacing: 6) {
                            ForEach(researchTopics, id: \.self) { topic in
                                KeywordView(keywordName: topic)
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
        }
    }
}

// MARK: -- 해시태그 뷰
struct TagView: View {
    var tagName: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text("\(tagName)")
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
                    .padding(.horizontal, 24)
            }
        }
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

// MARK: -- 즐겨찾는 연구실 없을 경우
struct EmptyScrappedLaboratory: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("아직 즐겨찾기 연구실이 없어요")
                .font(
                    Font.custom("Pretendard", size: Constants.fontSize5)
                        .weight(Constants.fontWeightSemiBold)
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

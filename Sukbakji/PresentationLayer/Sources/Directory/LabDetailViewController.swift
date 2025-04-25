//
//  LabDetailViewController.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import SwiftUI
import Alamofire

import SwiftUI
import Alamofire

struct LabDetailViewController: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isBookmarked = false
    @State private var selectedTab: String = "연구실 정보"  // 세그먼트 컨트롤 선택 상태
    private let tabs = ["연구실 정보", "후기"]
    
    var labId: Int
    @State private var labInfo: DirectoryLabInfoResult?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 50)
            } else if let labInfo = labInfo {
                VStack(spacing: 0) {
                    // 상단 네비게이션 바
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            print("뒤로가기 버튼 tapped")
                        }) {
                            Image("BackButton")
                                .frame(width: 24, height: 24)
                        }
                        
                        Spacer()
                        
                        Text("연구실 정보")
                            .font(.system(size: 22, weight: .bold))
                        
                        Spacer()
                        
                        Button(action: {
                            print("더보기 버튼 클릭됨")
                        }) {
                            Image("MoreButton 1")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    
                    // 세그먼트 컨트롤 및 탭 전환: 수직 패딩을 줄여 간격을 좁게 함
                    VStack {
                        HStack {
                            CustomSegmentedControl(selectedTab: $selectedTab, tabs: tabs)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 6)
                            Spacer()
                        }
                        
                        TabView(selection: $selectedTab) {
                            LabInfoView(
                                universityName: labInfo.universityName,
                                labName: labInfo.departmentName,
                                professorName: labInfo.professorName,
                                professorEmail: labInfo.professorEmail,
                                departmentName: labInfo.departmentName,
                                hasLabURL: !labInfo.labLink.isEmpty,
                                labURL: labInfo.labLink,
                                isBookmarked: $isBookmarked,
                                researchTopics: labInfo.researchTopics,
                                labId: labId
                            )
                            .tag("연구실 정보")
                            
                            LabDetailReviewViewController(
                                labId: labId,
                                universityName: labInfo.universityName,
                                departmentName: labInfo.departmentName,
                                professorName: labInfo.professorName
                            )
                            .tag("후기")
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .animation(.easeInOut(duration: 0.25), value: selectedTab)
                    }
                }
                .background(Color.white)
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden()
        .onAppear {
            fetchLabDetail()
            checkBookmarkStatus()
        }
    }
    
    func fetchLabDetail() {
        isLoading = true
        errorMessage = nil
        
        guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user"),
              !accessToken.isEmpty else {
            errorMessage = "인증 토큰이 없습니다."
            isLoading = false
            return
        }
        
        let url = APIConstants.baseURL + "/labs/\(labId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DirectoryLabInfoGetModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        labInfo = data.result
                    } else {
                        errorMessage = data.message
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
                isLoading = false
            }
    }
    
    func checkBookmarkStatus() {
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
                        isBookmarked = data.result.contains(where: { $0.labId == labId })
                    } else {
                        print("즐겨찾기 조회 실패: \(data.message)")
                    }
                case .failure(let error):
                    print("즐겨찾기 조회 API 에러: \(error.localizedDescription)")
                }
            }
    }
}

struct CustomSegmentedControl: View {
    @Binding var selectedTab: String
    let tabs: [String]
    
    @Namespace private var animationNamespace
    @State private var tabFrames: [CGRect] = Array(repeating: .zero, count: 2)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 36) {
                ForEach(tabs.indices, id: \.self) { index in
                    Text(tabs[index])
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeM)
                                .weight(Constants.fontWeightSemiBold)
                        )
                        .foregroundColor(selectedTab == tabs[index] ? Constants.Orange700 : Constants.Gray600)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        tabFrames[index] = geo.frame(in: .global)
                                    }
                            }
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = tabs[index]
                            }
                        }
                }
            }
            .padding(0)
            .background(
                GeometryReader { geo in
                    let selectedIndex = tabs.firstIndex(of: selectedTab) ?? 0
                    let frame = tabFrames[selectedIndex]
                    Rectangle()
                        .fill(Color(red: 0.93, green: 0.29, blue: 0.03))
                        .frame(width: frame.width + 20, height: 2)
                        .offset(x: frame.minX - geo.frame(in: .global).minX - 10,
                                y: geo.size.height + 12)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
                }
            )
        }
    }
}

struct LabInfoView: View {
    var universityName: String
    var labName: String
    var professorName: String
    var professorEmail: String // 교수 이메일 추가
    var departmentName: String
    var hasLabURL: Bool
    var labURL: String
    @Binding var isBookmarked: Bool
    var researchTopics: [String]
    var labId: Int
    
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
                        Image("symbol")
                            .resizable()
                            .frame(width: 56, height: 56)
                            .padding(22)
                    }
                    .background(Constants.White)
                    .cornerRadius(20)
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
                    
                    Button(action: {
                        toggleBookmark()
                    }) {
                        Image(isBookmarked ? "BookmarkButton Fill" : "BookmarkButton")
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
            
            HStack {
                Text("교수 정보")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 24)
                Image("SearchRecommend 1")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)

                Spacer()
            }
            .padding(.top, 28)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("최종학력")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize6)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.Gray600)
                        .frame(width: 50, alignment: .leading)

                    Text("이메일")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize6)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.Gray600)
                        .frame(width: 50, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 17) {
                    Text("\(universityName) \(departmentName)")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize5)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.Gray900)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 8) {
                        Text(professorEmail)
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSize5)
                                    .weight(Constants.fontWeightMedium)
                            )
                            .underline()
                            .foregroundColor(Constants.Gray900)
                            .frame(alignment: .leading)
                        
                        Button(action: {
                            UIPasteboard.general.string = professorEmail
                        }) {
                            Image("copy")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 17)
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
                                .weight(Constants.fontWeightSemiBold)
                        )
                        .foregroundColor(Constants.Gray900)
                    
                    if hasLabURL, labURL.lowercased() != "nan", let url = URL(string: labURL) {
                        Link(destination: url) {
                            Text(labURL)
                                .font(
                                    Font.custom("Pretendard", size: 16)
                                        .weight(Constants.fontWeightSemiBold)
                                )
                                .underline()
                                .foregroundColor(Constants.Orange700)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .minimumScaleFactor(0.5)
                        }
                    } else {
                        Text("해당 연구실은 홈페이지가 없습니다.")
                            .font(
                                Font.custom("Pretendard", size: 12)
                                    .weight(Constants.fontWeightSemiBold)
                            )
                            .foregroundColor(Constants.Gray600)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 17)
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
                    ForEach(researchTopics, id: \.self) { topic in
                        LabTopic(topicName: topic)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    func toggleBookmark() {
        let url = APIConstants.baseURL + "/labs/\(labId)/favorite"
        let parameters: [String: Any] = ["labId": labId]
        let headers: HTTPHeaders = ["Accept": "application/json"]

        NetworkAuthManager.shared.request(url, method: .post, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DirectoryFavoriteGetModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        self.isBookmarked.toggle()

                        // 즐겨찾기 상태 변경 성공 알림 발송
                        NotificationCenter.default.post(name: NSNotification.Name("BookmarkStatusChanged"), object: nil)
                        
                        print("북마크 상태 변경 성공: \(data.message)")
                    } else {
                        print("북마크 상태 변경 실패: \(data.message)")
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
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

#Preview {
    LabDetailViewController(labId: 1)
}

//
//  LabDetailViewController.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import SwiftUI
import Alamofire

struct LabDetailViewController: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isBookmarked = false
    @State private var selectedButton: String? = "연구실 정보"
    
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
                                            .padding(.horizontal, 10)
                                    }
                                    .padding(.vertical, 8)
                                    .background(
                                        GeometryReader { geometry in
                                            if selectedButton == title {
                                                Rectangle()
                                                    .fill(Color(red: 0.93, green: 0.29, blue: 0.03))
                                                    .frame(width: geometry.size.width, height: 3)
                                                    .offset(y: 16)
                                            }
                                        }
                                            .frame(height: 0)
                                    )
                                }
                                .padding(.leading, title == "연구실 정보" ? 0 : 16)
                            }
                        }
                        .padding(.leading, 24)
                        .padding(.trailing, 24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color.white)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .background(Color.white)
                
                VStack {
                    switch selectedButton {
                    case "연구실 정보":
                        LabInfoView(
                            universityName: labInfo.universityName,
                            labName: labInfo.departmentName,
                            professorName: labInfo.professorName,
                            professorEmail: labInfo.professorEmail, departmentName: labInfo.departmentName, // 이메일 전달
                            hasLabURL: !labInfo.labLink.isEmpty,
                            labURL: labInfo.labLink,
                            isBookmarked: $isBookmarked,
                            researchTopics: labInfo.researchTopics,
                            labId: labId
                        )
                    case "후기":
                        LabDetailReviewViewController(labId: labId, universityName: labInfo.universityName, departmentName: labInfo.departmentName, professorName: labInfo.professorName)
                    default:
                        Text("오류 발생. 관리자에게 문의하세요.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 2)
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.red)
                    .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            fetchLabDetail()
        }
    }

    func fetchLabDetail() {
        isLoading = true
        errorMessage = nil
        
        guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self), !accessToken.isEmpty else {
            self.errorMessage = "인증 토큰이 없습니다."
            self.isLoading = false
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
                        self.labInfo = data.result
                    } else {
                        self.errorMessage = data.message
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
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
                        Image("Symbol")
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
                        .frame(width: 50, alignment: .leading)

                    Text("\(universityName) \(departmentName)")
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
                        .frame(width: 50, alignment: .leading)

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
                                Font.custom("Pretendard", size: 12)
                                    .weight(Constants.fontWeightSemibold)
                            )
                            .foregroundColor(Constants.Gray600)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 17)
            .frame(width: 342, alignment: .topLeading)
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
                    ForEach(researchTopics, id: \.self) { topic in
                        LabTopic(topicName: topic)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    func toggleBookmark() {
        // labId를 쿼리 파라미터로 전달
        let url = APIConstants.baseURL + "/labs/\(labId)/favorite"
        let parameters: [String: Any] = ["labId": labId]
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]

        NetworkManager.shared.request(url, method: .post, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DirectoryFavoriteGetModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        self.isBookmarked.toggle() // 즐겨찾기 상태 토글
                        print("북마크 상태 변경 성공: \(data.message)")
                    } else {
                        print("북마크 상태 변경 실패: \(data.message)")
                    }
                case .failure(let error):
                    if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                        print("Error response from server: \(responseString)")
                    }
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

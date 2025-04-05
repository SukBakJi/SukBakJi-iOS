//
//  BoardEditViewController.swift
//  Sukbakji
//
//  Created by KKM on 4/5/25.
//

import SwiftUI
import Alamofire

struct BoardEditViewController: View {
    var postId: Int
    var originalTitle: String
    var originalContent: String
    var memberId: Int // 게시글 작성자 ID
    var currentUserId: Int // 현재 로그인된 사용자 ID
    
    @State private var titleText: String = ""
    @State private var postText: String = ""
    @State private var showValidationError: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            SeokBakji()
            
            HStack(alignment: .top, spacing: 4) {
                Text("제목")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Constants.Gray900)
                
                Image("dot-badge")
                    .resizable()
                    .frame(width: 4, height: 4)
            }
            .padding(.horizontal, 24)
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
            .padding(.horizontal, 24)
            
            HStack(alignment: .top, spacing: 4) {
                Text("내용")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Constants.Gray900)
                
                Image("dot-badge")
                    .resizable()
                    .frame(width: 4, height: 4)
            }
            .padding(.horizontal, 24)
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
            .padding(.horizontal, 24)
            
            Button(action: {
                if titleText.isEmpty || postText.isEmpty {
                    showValidationError = true
                } else if memberId == currentUserId {
                    updatePost()
                } else {
                    print("게시글 수정 권한이 없습니다.")
                }
            }) {
                Text("수정 완료")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Constants.Orange700)
                    .cornerRadius(10)
                    .padding(.top, 20)
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            titleText = originalTitle
            postText = originalContent
        }
    }
    
    func updatePost() {
        let url = APIConstants.baseURL + "/posts/update/\(postId)"
        
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            print("토큰이 존재하지 않습니다.")
            return
        }

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]

        let request = BoardEditPostRequestModel(
            title: titleText,
            content: postText,
            supportField: nil,
            job: nil,
            hiringType: nil,
            finalEducation: nil
        )

        NetworkAuthManager.shared.request(url, method: .put, parameters: request, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoardEditPostResponseModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        print("게시글 수정 성공: \(data.message)")
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        print("게시글 수정 실패: \(data.message)")
                    }
                case .failure(let error):
                    if let errorData = response.data,
                       let errorMessage = String(data: errorData, encoding: .utf8) {
                        print("에러 응답: \(errorMessage)")
                    } else {
                        print("요청 실패: \(error.localizedDescription)")
                    }
                }
            }
    }
}

#Preview {
    BoardEditViewController(postId: 1, originalTitle: "example", originalContent: "example", memberId: 1, currentUserId: 1)
}

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
    var boardName: String
    var supportField: String?
    var job: String?
    var hiringType: String?
    var finalEducation: String?

    @State private var titleText: String = ""
    @State private var postText: String = ""
    @State private var showValidationError: Bool = false
    @Environment(\ .presentationMode) var presentationMode
    
    @Binding var shouldReload: Bool

    var isJobPost: Bool {
        return boardName == "취업후기 게시판"
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image("BackButton")
                        .frame(width: Constants.nav, height: Constants.nav)
                }

                Spacer()

                Text("게시물 수정")
                    .font(.system(size: 20, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.Gray900)

                Spacer()

                Rectangle()
                    .frame(width: Constants.nav, height: Constants.nav)
                    .foregroundStyle(.clear)
            }

            Divider()

            SeokBakji()

            VStack(alignment: .leading) {
                TextFieldSection(title: "제목", text: $titleText, isError: showValidationError && titleText.isEmpty, placeholder: "제목을 입력해주세요")

                TextFieldSection(title: "내용", text: $postText, isError: showValidationError && postText.isEmpty, placeholder: "내용을 입력해주세요", isMultiline: true)
            }
            .padding(.horizontal, 24)

            Spacer()

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
            .padding(.bottom, 23)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            titleText = originalTitle
            postText = originalContent
        }
        .onAppear(perform: UIApplication.shared.hideKeyboard)
    }

    func updatePost() {
        let url = APIConstants.baseURL + "/posts/\(postId)/update"

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
            supportField: isJobPost ? supportField : nil,
            job: isJobPost ? job : nil,
            hiringType: isJobPost ? hiringType : nil,
            finalEducation: isJobPost ? finalEducation : nil
        )

        NetworkAuthManager.shared.request(url, method: .put, parameters: request, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoardEditPostResponseModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        print("게시글 수정 성공: \(data.message)")
                        shouldReload = true
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

struct TextFieldSection: View {
    let title: String
    @Binding var text: String
    var isError: Bool
    var placeholder: String
    var isMultiline: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Constants.Gray900)
                Image("dot-badge")
                    .resizable()
                    .frame(width: 4, height: 4)
            }
            .padding(.bottom, 12)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("")
                        .foregroundColor(isError ? Color(red: 1, green: 0.29, blue: 0.29) : Constants.Gray500)
                        .padding(.horizontal, 8)
                }
                TextField(placeholder, text: $text, axis: isMultiline ? .vertical : .horizontal)
                    .frame(height: isMultiline ? 100 : 44, alignment: .topLeading)
                    .padding()
                    .background(isError ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100))
                    .cornerRadius(8, corners: [.topLeft, .topRight])
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(isError ? Color.red : Color(Constants.Gray300))
                            .padding(.top, isMultiline ? 100 : 44)
                            .padding(.horizontal, 8),
                        alignment: .bottom
                    )
                    .foregroundColor(isError ? Color(red: 1, green: 0.29, blue: 0.29) : Color(Constants.Gray900))
            }
            
            if isError {
                HStack {
                    Image("CircleWarning")
                        .resizable()
                        .frame(width: 12, height: 12)
                    Text("\(title)은 필수 입력입니다")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 1, green: 0.29, blue: 0.29))
                }
            }
        }
        .padding(.top, 20)
    }
}


//#Preview {
//    BoardEditViewController(postId: 1, originalTitle: "예제 제목", originalContent: "예제 내용", memberId: 1, currentUserId: 1, boardName: "취업후기 게시판", supportField: "기획·전략", job: "마케터", hiringType: "신입", finalEducation: "석사", shouldReload: Bool.random())
//}

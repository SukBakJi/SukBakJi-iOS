import SwiftUI
import Alamofire

struct LabReviewWriteViewController: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var postText: String = "" // 한줄평 텍스트 상태 변수
    @State private var showValidationError: Bool = false // 유효성 검사 오류 상태 변수
    
    // State variables to hold user selections
    @State private var leadershipStyle: String = ""
    @State private var salaryLevel: String = ""
    @State private var autonomy: String = ""
    
    // Properties to hold lab details
    var labId: Int // 연구실 ID
    var universityName: String
    var departmentName: String
    var professorName: String

    // Computed property to check if the form is valid
    var isFormValid: Bool {
        !leadershipStyle.isEmpty && !salaryLevel.isEmpty && !autonomy.isEmpty && !postText.isEmpty && postText.count >= 30
    }

    var body: some View {
        VStack {
            HStack {
                // 뒤로가기 버튼
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image("BackButton")
                        .frame(width: Constants.nav, height: Constants.nav)
                }

                Spacer()

                Text("연구실 후기 작성")
                    .font(.system(size: 20, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.Gray900)

                Spacer()

                Rectangle()
                    .frame(width: Constants.nav, height: Constants.nav)
                    .foregroundStyle(.clear)
            }

            Divider()

            ScrollView(showsIndicators: false) {
                VStack {
                    VStack(alignment: .leading) {
                        Text("연구실에 대한 정보")
                            .font(
                                Font.custom("Pretendard", size: 18)
                                    .weight(Constants.fontWeightSemiBold)
                            )
                            .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
                        + Text("를 \n석박지에서 공유해 보세요")
                            .font(
                                Font.custom("Pretendard", size: 18)
                                    .weight(Constants.fontWeightSemiBold)
                            )
                    }
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .center, spacing: 8) {
                            Image("Rectangle")
                                .resizable()
                                .frame(width: 14, height: 14)

                            Text(universityName)
                                .font(
                                    Font.custom("Pretendard", size: 16)
                                        .weight(Constants.fontWeightSemiBold)
                                )
                                .foregroundColor(Constants.Gray900)

                            Text(departmentName)
                                .font(
                                    Font.custom("Pretendard", size: 16)
                                        .weight(Constants.fontWeightSemiBold)
                                )
                                .foregroundColor(Constants.Orange700)
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

                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .center, spacing: 8) {
                            Image("SearchRecommend 1")
                                .resizable()
                                .frame(width: 20, height: 20)

                            Text("\(professorName) 교수")
                                .font(
                                    Font.custom("Pretendard", size: 16)
                                        .weight(Constants.fontWeightSemiBold)
                                )
                                .foregroundColor(Constants.Gray900)
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
                }

                HStack(alignment: .top, spacing: 4) {
                    Text("키워드 선택")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Constants.Gray900)

                    Image("dot-badge")
                        .resizable()
                        .frame(width: 4, height: 4)
                }
                .padding(.bottom, 12)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .topLeading)

                // 지도력은 어떤가요?
                Text("지도력은 어떤가요?")
                    .font(
                        Font.custom("Pretendard", size: 16)
                            .weight(Constants.fontWeightSemiBold)
                    )
                    .foregroundColor(Constants.Gray900)
                    .frame(maxWidth: .infinity, alignment: .topLeading)

                HStack {
                    Button(action: {
                        leadershipStyle = "좋았어요"
                    }) {
                        LabelView(labelName: "좋았어요", isSelected: leadershipStyle == "좋았어요")
                    }
                    Button(action: {
                        leadershipStyle = "보통이에요"
                    }) {
                        LabelView(labelName: "보통이에요", isSelected: leadershipStyle == "보통이에요")
                    }
                    Button(action: {
                        leadershipStyle = "아쉬워요"
                    }) {
                        LabelView(labelName: "아쉬워요", isSelected: leadershipStyle == "아쉬워요")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 8)
                .padding(.leading, 8)

                // 인건비는 어떤가요?
                Text("인건비는 어떤가요?")
                    .font(
                        Font.custom("Pretendard", size: 16)
                            .weight(Constants.fontWeightSemiBold)
                    )
                    .padding(.top, 13)
                    .foregroundColor(Constants.Gray900)
                    .frame(maxWidth: .infinity, alignment: .topLeading)

                HStack {
                    Button(action: {
                        salaryLevel = "높아요"
                    }) {
                        LabelView(labelName: "높아요", isSelected: salaryLevel == "높아요")
                    }
                    Button(action: {
                        salaryLevel = "보통이에요"
                    }) {
                        LabelView(labelName: "보통이에요", isSelected: salaryLevel == "보통이에요")
                    }
                    Button(action: {
                        salaryLevel = "낮아요"
                    }) {
                        LabelView(labelName: "낮아요", isSelected: salaryLevel == "낮아요")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 8)
                .padding(.leading, 8)

                // 자율성은 어떤가요?
                Text("자율성은 어떤가요?")
                    .font(
                        Font.custom("Pretendard", size: 16)
                            .weight(Constants.fontWeightSemiBold)
                    )
                    .padding(.top, 13)
                    .foregroundColor(Constants.Gray900)
                    .frame(maxWidth: .infinity, alignment: .topLeading)

                HStack {
                    Button(action: {
                        autonomy = "높아요"
                    }) {
                        LabelView(labelName: "높아요", isSelected: autonomy == "높아요")
                    }
                    Button(action: {
                        autonomy = "보통이에요"
                    }) {
                        LabelView(labelName: "보통이에요", isSelected: autonomy == "보통이에요")
                    }
                    Button(action: {
                        autonomy = "낮아요"
                    }) {
                        LabelView(labelName: "낮아요", isSelected: autonomy == "낮아요")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, 8)
                .padding(.leading, 8)

                // MARK: - 한줄평
                HStack(alignment: .top, spacing: 4) {
                    Text("한줄평")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Constants.Gray900)

                    Image("dot-badge")
                        .resizable()
                        .frame(width: 4, height: 4)
                }
                .padding(.bottom, 12)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .topLeading)

                // MARK: - 한줄평 텍스트 필드 생성
                VStack(alignment: .leading, spacing: 4) {
                    ZStack(alignment: .leading) {
                        if postText.isEmpty {
                            Text("")
                                .foregroundColor(showValidationError ? Color(red: 1, green: 0.29, blue: 0.29) : Constants.Gray500)
                                .padding(.horizontal, 8)
                        }
                        TextField("연구실 분위기, 지도자의 인품 등 후기를 알려 주세요", text: $postText)
                            .font(
                                Font.custom("Pretendard", size: 14)
                                .weight(.medium)
                            )
                            .frame(height: 100, alignment: .topLeading)
                            .padding()
                            .background(showValidationError && postText.isEmpty ? Color(red: 1, green: 0.92, blue: 0.93) : Color(Constants.Gray100))
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
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center, spacing: 0) {
                        Image("Warning")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                        
                        Text("연구실 후기 작성시 유의사항")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Constants.Gray900)
                            .padding(.leading, 8)
                    }
                    .padding(.top, 20)
                    
                    Text("석박지는 투명하고 정확한 연구실 후기 제공을 위해 커뮤니티 이용규칙을 제정하여 운영하고 있습니다. 위반 시 게시물이 삭제되고 서비스 이용이 일정기간 제한될 수 있습니다.\n\n · 후기 조작 금지    불공정한 방식으로 아이디를 이용하여 재학 및 졸업생이 아님에도 \n   불구하고 후기를 작성하는 행위 \n · 후기 작성자 유추 금지    후기 작성자에 대한 과도한 유추(신상정보 유출 등)를 하는 행위 \n · 비난 및 비하 금지    연구실 구성원에 대한 비난 및 비하에 해당하는 내용 게시를 하는 행위")
                      .font(
                        Font.custom("Pretendard", size: Constants.fontSize6)
                          .weight(Constants.fontWeightMedium)
                      )
                      .foregroundColor(Constants.Gray600)
                      .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding(.bottom, 60)
                
                Button(action: {
                    submitReview()
                }) {
                    HStack(alignment: .center) {
                        Text("작성하기")
                            .font(
                                Font.custom("Pretendard", size: 16)
                                .weight(Constants.fontWeightMedium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(isFormValid ? Color.white : Constants.Gray500)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.nav, alignment: .center)
                    .background(isFormValid ? Color(red: 0.93, green: 0.29, blue: 0.03) : Constants.Gray200) // 배경색 조건부 변경
                    .cornerRadius(8)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden()
    }
    
    func submitReview() {
            if !isFormValid {
                showValidationError = true
                return
            }
            
            let reviewRequest = LabReviewRequest(
                content: postText,
                leadershipStyle: leadershipStyle,
                salaryLevel: salaryLevel,
                autonomy: autonomy
            )
            
            // 요청 전송 전에 요청 데이터를 출력
            do {
                let jsonData = try JSONEncoder().encode(reviewRequest)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("Request JSON: \(jsonString)")
                }
            } catch {
                print("Error encoding request data: \(error)")
            }
            
            // 네트워크 요청을 보냅니다
        NetworkAuthManager.shared.request(
                APIConstants.baseURL + "/labs/reviews/\(labId)",
                method: .post,
                parameters: reviewRequest,
                encoder: JSONParameterEncoder.default
            )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LabReviewResponse.self) { response in
                switch response.result {
                case .success(let reviewResponse):
                    if reviewResponse.isSuccess {
                        print("후기 작성 성공: \(reviewResponse.message)")
                        self.presentationMode.wrappedValue.dismiss() // 작성 완료 후 화면 닫기
                    } else {
                        print("후기 작성 실패: \(reviewResponse.message)")
                    }
                case .failure(let error):
                    print("에러: \(error.localizedDescription)")
                    if response.response?.statusCode == 400 {
                        print("잘못된 요청으로 인해 실패하였습니다.")
                    }
                    
                    if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("서버 응답: \(errorMessage)")
                    }
                }
            }
        }
}

struct LabelView: View {
    var labelName: String
    var isSelected: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(labelName)
                .font(
                    Font.custom("Pretendard", size: Constants.fontSize6)
                        .weight(Constants.fontWeightMedium)
                )
                .foregroundColor(isSelected ? Color(red: 0.98, green: 0.31, blue: 0.06) : Constants.Gray500)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(isSelected ? Color(red: 0.99, green: 0.91, blue: 0.9) : Constants.Gray50)
        .cornerRadius(4)
    }
}

#Preview {
    LabReviewWriteViewController(
        labId: 1,
        universityName: "성신여자대학교",
        departmentName: "화학에너지융합학부",
        professorName: "구본재"
    )
}

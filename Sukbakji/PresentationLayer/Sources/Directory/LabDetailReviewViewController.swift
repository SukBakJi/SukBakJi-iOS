import SwiftUI
import Alamofire

struct LabDetailReviewViewController: View {
    var labId: Int
    var universityName: String
    var departmentName: String
    var professorName: String

    @State private var reviews: [LabReviewInfo] = [] // 연구실 후기 배열
    @State private var triangleGraphData: TriangleGraphData? // 삼각형 그래프 데이터
    @State private var showMoreReviews: Bool = false // '연구실 후기 더보기' 버튼 상태 변수
    @State private var isLoading: Bool = true // 로딩 상태 변수
    @State private var highestAttributesText: String = "" // 가장 높은 항목을 표시할 텍스트

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 8) {
                Text("연구실의 후기를 확인해 보세요")
                    .font(
                        Font.custom("Pretendard", size: 18)
                            .weight(.semibold)
                    )
                    .foregroundColor(Constants.Gray900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("키워드 3개로 보는 간단 Check")
                    .font(Font.custom("Pretendard", size: 14))
                    .foregroundColor(Constants.Gray500)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            
            HStack(alignment: .center, spacing: 8) {
                Text("간단 Check")
                  .font(
                    Font.custom("Pretendard", size: 18)
                      .weight(Constants.fontWeightSemiBold)
                  )
                  .foregroundColor(Constants.Gray900)
                
                Image("Simplecheck")
                    .resizable()
                    .frame(width: 18, height: 18)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            
            if let triangleGraphData = triangleGraphData {
                // 삼각형 그래프 표시
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(highestAttributesText)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
                    }
                    
                    Text("키워드를 통해 간단하게 볼 수 있어요")
                        .font(Font.custom("Pretendard", size: 14))
                        .foregroundColor(Constants.Gray500)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 16)
                .frame(width: 390, alignment: .topLeading)
                
                RadarChart(triangleGraphData: triangleGraphData)
                    .frame(width: 300, height: 270)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
            }
            
            // 연구실 한줄평
            HStack(alignment: .center, spacing: 8) {
                Text("연구실 한줄평")
                  .font(
                    Font.custom("Pretendard", size: 18)
                      .weight(Constants.fontWeightSemiBold)
                  )
                  .foregroundColor(Constants.Gray900)
                
                Image("Chat 2")
                    .resizable()
                    .frame(width: 18, height: 18)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            
            VStack(spacing: 15) {
                if isLoading {
                    ProgressView("로딩 중...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    // 리뷰를 최대 3개까지 보여주고, showMoreReviews가 true이면 모든 리뷰를 보여줌
                    VStack(spacing: 16) {
                        ForEach(0..<min(reviews.count, showMoreReviews ? reviews.count : 3), id: \.self) { index in
                            LabReviewInfoView(review: reviews[index])
                        }
                    }
                    
                    // 리뷰가 4개 이상일 경우에만 '연구실 후기 더보기' 버튼을 표시
                    if reviews.count > 3 {
                        Button(action: {
                            // 리뷰가 4개 이상일 경우에만 동작하도록 설정
                            if reviews.count > 3 {
                                showMoreReviews.toggle()
                                print("연구실 후기 더보기 버튼 tapped")
                            }
                        }) {
                            HStack {
                                Text(showMoreReviews ? "연구실 후기 접기" : "연구실 후기 더보기")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSize7)
                                            .weight(.regular)
                                    )
                                    .foregroundColor(Constants.Gray900)
                                
                                Image("More 2")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .rotationEffect(.degrees(showMoreReviews ? 180 : 0))
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
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 48)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
        .onAppear {
            loadLabReviews(labId: labId)
        }
        .overlay(
            DirectoryOverlayButton(
                labId: labId,
                universityName: universityName,
                departmentName: departmentName,
                professorName: professorName
            )
            .padding(.trailing, 24)
            .padding(.bottom, 48),
            alignment: .bottomTrailing
        )
    }
    
    func loadLabReviews(labId: Int) {
        let url = APIConstants.baseURL + "/labs/reviews/\(labId)"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        NetworkAuthManager.shared.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LabReviewInfoListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    reviews = data.result.reviews
                    triangleGraphData = data.result.triangleGraphData
                    isLoading = false
                    calculateHighestAttributes()
                case .failure(let error):
                    print("Error loading reviews: \(error.localizedDescription)")
                    isLoading = false
                }
            }
    }
    
    func calculateHighestAttributes() {
        guard let triangleGraphData = triangleGraphData else { return }
        
        let attributes = [
            ("지도력", triangleGraphData.leadershipAverage),
            ("인건비", triangleGraphData.salaryAverage),
            ("자율성", triangleGraphData.autonomyAverage)
        ]
        
        let maxValue = attributes.map { $0.1 }.max()
        let highestAttributes = attributes.filter { $0.1 == maxValue }.map { $0.0 }
        
        highestAttributesText = highestAttributes.joined(separator: ", ") + "이 가장 높게 나타났어요"
    }
}

// LabReviewInfoView 구조체를 사용하여 각 리뷰를 표시합니다.
struct LabReviewInfoView: View {
    let review: LabReviewInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(review.universityName)
                .font(
                    Font.custom("Pretendard", size: Constants.fontSize6)
                        .weight(Constants.fontWeightMedium)
                )
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(review.departmentName)
                .font(
                    Font.custom("Pretendard", size: Constants.fontSize5)
                        .weight(Constants.fontWeightSemiBold)
                )
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(review.content)
                .font(
                    Font.custom("Pretendard", size: Constants.fontSize6)
                        .weight(Constants.fontWeightMedium)
                )
                .foregroundColor(Constants.Gray900)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            HStack(alignment: .center, spacing: 6) {
                Text("지도력이 \(review.leadershipStyle)")
                    .font(
                    Font.custom("Pretendard", size: Constants.fontSize6)
                    .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(red: 0.99, green: 0.91, blue: 0.9))
                    .cornerRadius(4)
                
                Text("인건비가 \(review.salaryLevel)")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSize6)
                        .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(red: 0.99, green: 0.91, blue: 0.9))
                    .cornerRadius(4)
                    .lineLimit(1) // Ensure the text is on one line
                    .minimumScaleFactor(0.5) // Scale the text down if it overflows
                
                Text("자율성이 \(review.autonomy)")
                    .font(
                    Font.custom("Pretendard", size: Constants.fontSize6)
                    .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(red: 0.99, green: 0.91, blue: 0.9))
                    .cornerRadius(4)
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
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

// RadarChart and related structs remain unchanged.

struct RadarChart: View {
    let triangleGraphData: TriangleGraphData

    var body: some View {
        let values = [
            triangleGraphData.leadershipAverage / 10,
            triangleGraphData.salaryAverage / 10,
            triangleGraphData.autonomyAverage / 10
        ]
        
        return GeometryReader { geometry in
            ZStack {
                radarChartBackground(geometry: geometry)
                radarChartShape(geometry: geometry, values: values)
                radarChartLabels(geometry: geometry)
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func radarChartBackground(geometry: GeometryProxy) -> some View {
        let background = RadarChartBackground(categories: ["지도력", "자율성", "인건비"])
            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        
        return ZStack {
            ForEach(1..<4) { i in
                RadarChartBackground(categories: ["지도력", "자율성", "인건비"])
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                    .scaleEffect(CGFloat(i) / 4)
            }
            background
        }
    }

    private func radarChartShape(geometry: GeometryProxy, values: [Double]) -> some View {
        let shape = RadarChartShape(values: values)
            .fill(LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 1, green: 0.84, blue: 0.77).opacity(0.5), location: 0.00),
                    Gradient.Stop(color: Color(red: 1, green: 0.44, blue: 0.23).opacity(0.5), location: 1.00),
                ],
                startPoint: .top,
                endPoint: .bottom
            ))
        
        return shape
    }

    private func radarChartLabels(geometry: GeometryProxy) -> some View {
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius = min(geometry.size.width, geometry.size.height) / 2
        let angles = calculateAngles()

        return ForEach(0..<3) { i in
            let angle = angles[i]
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)

            Text(["지도력", "자율성", "인건비"][i])
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Constants.Gray900)
                .position(x: x, y: y)
        }
    }

    private func calculateAngles() -> [Double] {
        let angleIncrement = 2 * Double.pi / 3
        return (0..<3).map { i in
            return angleIncrement * Double(i) - Double.pi / 2
        }
    }
}

struct RadarChartBackground: Shape {
    let categories: [String]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let angle = 2 * Double.pi / Double(categories.count)
        let radius = min(rect.width, rect.height) / 2

        for i in 0..<categories.count {
            let x = center.x + radius * cos(angle * Double(i) - Double.pi / 2)
            let y = center.y + radius * sin(angle * Double(i) - Double.pi / 2)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()

        return path
    }
}

struct RadarChartShape: Shape {
    let values: [Double]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let angle = 2 * Double.pi / Double(values.count)
        let radius = min(rect.width, rect.height) / 2

        for i in 0..<values.count {
            let valueRadius = radius * CGFloat(values[i])
            let x = center.x + valueRadius * cos(angle * Double(i) - Double.pi / 2)
            let y = center.y + valueRadius * sin(angle * Double(i) - Double.pi / 2)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()

        return path
    }
}

struct DirectoryOverlayButton: View {
    
    var labId: Int
    var universityName: String
    var departmentName: String
    var professorName: String

    var body: some View {
        Button(action: {
            print("글쓰기 버튼 tapped!")
        }) {
            NavigationLink(destination: LabReviewWriteViewController(
                labId: labId, universityName: universityName,
                departmentName: departmentName,
                professorName: professorName
            )) {
                ZStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .background(.clear)
                        .foregroundStyle(Color(Constants.Orange700))
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
                    
                    Image("Write")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    LabDetailReviewViewController(labId: 1, universityName: "성신여자대학교", departmentName: "화학에너지융합학부 에너지재료연구실", professorName: "구본재")
}

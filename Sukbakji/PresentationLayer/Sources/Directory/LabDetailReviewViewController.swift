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
    @State private var highestAttributeName: String = ""
    @State private var highestAttributeSuffix: String = ""

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
            .padding(.bottom, 12)
            
            if let triangleGraphData = triangleGraphData {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 0) {
                        Text(highestAttributeName)
                            .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
                        Text(highestAttributeSuffix)
                            .foregroundColor(Constants.Gray900)
                    }
                    .font(.system(size: 18, weight: .semibold))
                    
                    Text("키워드를 통해 간단하게 볼 수 있어요")
                        .font(Font.custom("Pretendard", size: 14))
                        .foregroundColor(Constants.Gray500)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal, 24)
                .padding(.top, 12)
                
                // 삼각형 그래프 표시
                RadarChart(triangleGraphData: triangleGraphData)
                    .padding(.top, 53)
                    .padding(.horizontal, 58)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
            .padding(.trailing, 24),
            alignment: .bottomTrailing
        )
    }
    
    func loadLabReviews(labId: Int) {
        print("labId: \(labId)")
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
        
        // 가장 높은 점수를 가진 단일 항목 선택 (tie가 있을 경우 배열 순서대로 첫번째가 선택됩니다)
        guard let highestAttribute = attributes.max(by: { $0.1 < $1.1 }) else { return }
        
        // 인건비만 "가", 나머지는 "이"를 사용
        let marker = (highestAttribute.0 == "인건비") ? "가" : "이"
        
        highestAttributeName = highestAttribute.0
        highestAttributeSuffix = "\(marker) 가장 높게 나타났어요"
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
                KeywordView(keywordName: "지도력이 \(review.leadershipStyle)")
                KeywordView(keywordName: "인건비가 \(review.salaryLevel)")
                KeywordView(keywordName: "자율성이 \(review.autonomy)")
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.06))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Constants.White)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.5)
                .stroke(Constants.Gray100, lineWidth: 1)
        )
    }
}

struct RadarChart: View {
    let triangleGraphData: TriangleGraphData

    var body: some View {
        // 0~10 범위 값을 0~1 비율로 변환하여 배열 순서를 지도력, 자율성, 인건비 순으로 재배열합니다.
        let values = [
            triangleGraphData.leadershipAverage / 10,   // index 0: 지도력 (상단)
            triangleGraphData.autonomyAverage / 10,       // index 1: 자율성 (오른쪽)
            triangleGraphData.salaryAverage / 10          // index 2: 인건비 (왼쪽)
        ]
        
        return GeometryReader { geometry in
            ZStack {
                radarChartBackground(geometry: geometry)
                radarChartShape(geometry: geometry, values: values)
                radarChartLabels(geometry: geometry)
            }
//            .padding()
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    // 정삼각형의 배경 (동심원 삼각형)
    private func radarChartBackground(geometry: GeometryProxy) -> some View {
        let center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
        let radius = min(geometry.size.width, geometry.size.height)/2
        let angleIncrement = 2 * Double.pi / 3
        let angles = (0..<3).map { -Double.pi/2 + angleIncrement * Double($0) }
        
        return ZStack {
            ForEach(1..<4) { i in
                let scale = CGFloat(i) / 3.0
                Path { path in
                    for j in 0..<3 {
                        let angle = angles[j]
                        let point = CGPoint(
                            x: center.x + radius * scale * CGFloat(cos(angle)),
                            y: center.y + radius * scale * CGFloat(sin(angle))
                        )
                        if j == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                    path.closeSubpath()
                }
                .stroke(Constants.Gray200, lineWidth: 0.5)
            }
            // 외곽선
            Path { path in
                for j in 0..<3 {
                    let angle = angles[j]
                    let point = CGPoint(
                        x: center.x + radius * CGFloat(cos(angle)),
                        y: center.y + radius * CGFloat(sin(angle))
                    )
                    if j == 0 {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
                path.closeSubpath()
            }
            .stroke(Constants.Gray300, lineWidth: 1)
        }
    }
    
    // 실제 데이터 값에 따라 채워지는 영역 그리기
    private func radarChartShape(geometry: GeometryProxy, values: [Double]) -> some View {
        let center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
        let radius = min(geometry.size.width, geometry.size.height)/2
        let angleIncrement = 2 * Double.pi / 3
        let angles = (0..<3).map { -Double.pi/2 + angleIncrement * Double($0) }
        
        // 각 점의 좌표 계산
        let points = values.enumerated().map { (index, value) -> CGPoint in
            let valueRadius = radius * CGFloat(value)
            let angle = angles[index]
            return CGPoint(
                x: center.x + valueRadius * CGFloat(cos(angle)),
                y: center.y + valueRadius * CGFloat(sin(angle))
            )
        }
        
        return Path { path in
            if let first = points.first {
                path.move(to: first)
                for point in points.dropFirst() {
                    path.addLine(to: point)
                }
                path.closeSubpath()
            }
        }
        .fill(LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 1, green: 0.84, blue: 0.77).opacity(0.5), location: 0.00),
                Gradient.Stop(color: Color(red: 1, green: 0.44, blue: 0.23).opacity(0.5), location: 1.00),
            ],
            startPoint: .top,
            endPoint: .bottom
        ))
    }
    
    // 정점(레이블) 그리기: 순서대로 지도력(상단), 자율성(오른쪽), 인건비(왼쪽)
    private func radarChartLabels(geometry: GeometryProxy) -> some View {
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius = min(geometry.size.width, geometry.size.height) / 2
        let angleIncrement = 2 * Double.pi / 3
        let angles = (0..<3).map { -Double.pi/2 + angleIncrement * Double($0) }
        
        // 속성 순서: index 0: 지도력, index 1: 자율성, index 2: 인건비
        let labels = ["지도력", "자율성", "인건비"]
        let originalValues = [triangleGraphData.leadershipAverage,
                              triangleGraphData.autonomyAverage,
                              triangleGraphData.salaryAverage]
        // 최고 점수를 가진 항목의 인덱스
        let maxIndex = originalValues.enumerated().max(by: { $0.element < $1.element })?.offset
        
        return ZStack {
            ForEach(0..<3) { i in
                let angle = angles[i]
                let point = CGPoint(
                    x: center.x + radius * CGFloat(cos(angle)),
                    y: center.y + radius * CGFloat(sin(angle))
                )
                
                // 인덱스에 따라 offset을 적용합니다.
                let offset = offsetForLabel(index: i)
                
                Text(labels[i])
                    .font(
                        Font.custom("Pretendard", size: 12)
                            .weight(.semibold)
                    )
                    .foregroundColor(i == maxIndex ? Color(red: 0.98, green: 0.31, blue: 0.06) : Constants.Gray900)
                    .position(x: point.x + offset.width, y: point.y + offset.height)
            }
        }
    }
    
    // 인덱스에 따른 오프셋 반환 (index 0: 지도력 - 상단, index 1: 자율성 - 오른쪽, index 2: 인건비 - 왼쪽)
    private func offsetForLabel(index: Int) -> CGSize {
        switch index {
        case 0: return CGSize(width: 0, height: -20)    // 지도력
        case 1: return CGSize(width: 30, height: 0)      // 자율성
        case 2: return CGSize(width: -30, height: 0)     // 인건비
        default: return .zero
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
            let swiftUIView = LabReviewWriteViewController(
                labId: labId,
                universityName: universityName,
                departmentName: departmentName,
                professorName: professorName
            )
            let hostingVC = UIHostingController(rootView: swiftUIView)
            hostingVC.hidesBottomBarWhenPushed = true

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController,
               let nav = findNavigationController(from: rootVC) {
                nav.pushViewController(hostingVC, animated: true)
            }
        }) {
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(Color(Constants.Orange700))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
                
                Image("Write")
                    .resizable()
                    .frame(width: 32, height: 32)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    // 네비게이션 컨트롤러 찾는 재귀 함수
    func findNavigationController(from vc: UIViewController) -> UINavigationController? {
        if let nav = vc as? UINavigationController {
            return nav
        }
        for child in vc.children {
            if let found = findNavigationController(from: child) {
                return found
            }
        }
        return nil
    }
}

#Preview {
    LabDetailReviewViewController(labId: 1, universityName: "성신여자대학교", departmentName: "화학에너지융합학부 에너지재료연구실", professorName: "구본재")
}

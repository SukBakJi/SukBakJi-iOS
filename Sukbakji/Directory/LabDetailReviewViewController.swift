//
//  LabDetailReviewViewController.swift
//  Sukbakji
//
//  Created by KKM on 8/21/24.
//

import SwiftUI

struct LabDetailReviewViewController: View {
    var universityName: String
    var departmentName: String
    var professorName: String

    @State private var reviews: [LabReview] = [LabReview(), LabReview(), LabReview()] // 초기 리뷰 목록
    @State private var showMoreReviews: Bool = false // '연구실 후기 더보기' 버튼 상태 변수

    var body: some View {
        ScrollView {
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
                      .weight(Constants.fontWeightSemibold)
                  )
                  .foregroundColor(Constants.Gray900)
                
                Image("Simplecheck")
                    .resizable()
                    .frame(width: 18, height: 18)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            
            // MARK: - 가장 높은 후기
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("자율성")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
                    + Text("이 가장 높게 나타났어요")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Constants.Gray900)
                }
                
                Text("키워드를 통해 간단하게 볼 수 있어요")
                    .font(Font.custom("Pretendard", size: 14))
                    .foregroundColor(Constants.Gray500)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // VStack을 왼쪽 정렬
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 16)
            .frame(width: 390, alignment: .topLeading) // 전체 프레임을 왼쪽 상단으로 정렬
            
            // MARK: - 삼각형 그래프
            RadarChart()
                .frame(width: 300, height: 270) // 차트 크기 지정
                .padding(.horizontal, 24)
                .padding(.top, 20)
            
            // MARK: - 연구실 한줄평
            HStack(alignment: .center, spacing: 8) {
                Text("연구실 한줄평")
                  .font(
                    Font.custom("Pretendard", size: 18)
                      .weight(Constants.fontWeightSemibold)
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
                // 기존 리뷰들을 표시
                ForEach(reviews) { review in
                    LabReviewView(review: review)
                }
                
                // '연구실 후기 더보기' 버튼
                if showMoreReviews {
                    ForEach(reviews) { review in
                        LabReviewView(review: review)
                    }
                }
                
                Button(action: {
                    // '연구실 후기 더보기' 버튼 클릭 시 동작할 코드
                    showMoreReviews.toggle()
                    print("연구실 후기 더보기 버튼 tapped")
                }) {
                    HStack {
                        Text("연구실 후기 더보기")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSize7)
                                    .weight(.regular)
                            )
                            .foregroundColor(Constants.Gray900)
                        
                        Image("More 2")
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
                }
                .padding(.top, 16)
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 24)
        }
        .overlay(
            DirectoryOverlayButton(
                universityName: universityName,
                departmentName: departmentName,
                professorName: professorName
            )
            .padding(.trailing, 24) // 오른쪽 여백
            .padding(.bottom, 48) // 아래 여백
            , alignment: .bottomTrailing // 오른쪽 아래에 위치
        )
    }
}

struct RadarChart: View {
    let categories = ["지도력", "자율성", "인건비"]
    let values: [Double] = [0.8, 0.9, 0.6] // 각 항목의 점수 (0.0 ~ 1.0 사이의 값)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                radarChartBackground(geometry: geometry)
                radarChartShape(geometry: geometry)
                radarChartLabels(geometry: geometry)
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.width) // 차트가 정사각형이 되도록 설정
        }
        .aspectRatio(1, contentMode: .fit) // 정사각형 비율을 유지하도록 설정
    }

    private func radarChartBackground(geometry: GeometryProxy) -> some View {
        let background = RadarChartBackground(categories: categories)
            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        
        return ZStack {
            ForEach(1..<4) { i in
                RadarChartBackground(categories: categories)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                    .scaleEffect(CGFloat(i) / 4)
            }
            background
        }
    }

    private func radarChartShape(geometry: GeometryProxy) -> some View {
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

        return ForEach(0..<categories.count, id: \.self) { i in
            let angle = angles[i]
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)

            Text(categories[i])
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Constants.Gray900)
                .position(x: x, y: y)
        }
    }

    private func calculateAngles() -> [Double] {
        let angleIncrement = 2 * .pi / Double(categories.count)
        return (0..<categories.count).map { i in
            return angleIncrement * Double(i) - .pi / 2
        }
    }
}

struct RadarChartBackground: Shape {
    let categories: [String]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let angle = 2 * .pi / Double(categories.count)
        let radius = min(rect.width, rect.height) / 2

        for i in 0..<categories.count {
            let x = center.x + radius * cos(angle * Double(i) - .pi / 2)
            let y = center.y + radius * sin(angle * Double(i) - .pi / 2)
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
        let angle = 2 * .pi / Double(values.count)
        let radius = min(rect.width, rect.height) / 2

        for i in 0..<values.count {
            let valueRadius = radius * CGFloat(values[i])
            let x = center.x + valueRadius * cos(angle * Double(i) - .pi / 2)
            let y = center.y + valueRadius * sin(angle * Double(i) - .pi / 2)
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

struct ContentView: View {
    var body: some View {
        RadarChart()
            .frame(width: 200, height: 150)
    }
}

struct RadarChartApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct DirectoryOverlayButton: View {
    
    var universityName: String
    var departmentName: String
    var professorName: String

    var body: some View {
        Button(action: {
            // 버튼 클릭 시 동작할 코드를 여기에 작성합니다.
            print("글쓰기 버튼 tapped!")
        }) {
            NavigationLink(destination: LabReviewWriteViewController(
                universityName: universityName,
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
                .buttonStyle(PlainButtonStyle()) // 버튼의 기본 스타일을 제거합니다.
            }
        }
    }
}

#Preview {
    LabDetailReviewViewController(universityName: "성신여자대학교", departmentName: "화학에너지융합학부 에너지재료연구실", professorName: "구본재")
}

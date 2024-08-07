//
//  RadarChart.swift
//  Sukbakji
//
//  Created by KKM on 7/31/24.
//

import SwiftUI

struct RadarChart: View {
    let categories = ["지도력", "인건비", "자율성"]
    let values: [Double] = [0.8, 0.6, 0.9] // 각 항목의 점수 (0.0 ~ 1.0 사이의 값)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Draw radar chart background
                RadarChartBackground(categories: categories)
                    .stroke(Color.gray, lineWidth: 1)
                
                // Draw radar chart values with gradient
                RadarChartShape(values: values)
                    .fill(LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 1, green: 0.84, blue: 0.77).opacity(0.5), location: 0.00),
                            Gradient.Stop(color: Color(red: 1, green: 0.44, blue: 0.23).opacity(0.5), location: 1.00),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.width) // 차트가 정사각형이 되도록 설정
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
            path.move(to: center)
            path.addLine(to: CGPoint(x: x, y: y))
        }

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
            .frame(width: 300, height: 300)
    }
}

struct RadarChartApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#Preview {
    RadarChart()
}

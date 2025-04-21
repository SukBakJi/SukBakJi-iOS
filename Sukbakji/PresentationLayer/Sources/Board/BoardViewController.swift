//
//  BoardViewController.swift
//  Sukbakji
//
//  Created by KKM on 7/25/24.
//

import SwiftUI

struct BoardViewController: View {
    @State private var selectedTab: String = "메인" // 기본 선택 탭
    private let tabs = ["메인", "박사", "석사", "진학 예정", "자유"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                // 상단 네비게이션 바
                HStack {
                    Text("게시판")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSizeXxl)
                                .weight(Constants.fontWeightSemiBold)
                        )
                        .foregroundColor(Constants.Gray900)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
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
                }
                .padding(.leading, 24)
                .padding(.trailing, 8)
                
                // 커스텀 세그먼트 컨트롤 – BoardSegmentedControl 사용
                BoardSegmentedControl(selectedTab: $selectedTab, tabs: tabs)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                
                // 탭 전환 콘텐츠 – 좌우 스와이프로 전환 가능
                TabView(selection: $selectedTab) {
                    MainView().tag("메인")
                    DoctoralView().tag("박사")
                    MasterView().tag("석사")
                    AdmissionView().tag("진학 예정")
                    FreeView().tag("자유")
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .navigationBarHidden(true)
        .accessibilityIdentifier("BoardViewController")
    }
}

struct BoardSegmentedControl: View {
    @Binding var selectedTab: String
    let tabs: [String]
    
    @Namespace private var animationNamespace
    @State private var tabFrames: [CGRect]
    
    init(selectedTab: Binding<String>, tabs: [String]) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self._tabFrames = State(initialValue: Array(repeating: .zero, count: tabs.count))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 탭 버튼들을 가로로 나열
            HStack(spacing: 36) {
                ForEach(tabs.indices, id: \.self) { index in
                    Text(tabs[index])
                        .font(Font.custom("Pretendard", size: Constants.fontSizeM)
                            .weight(Constants.fontWeightSemiBold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(selectedTab == tabs[index] ? Constants.Orange700 : Constants.Gray600)
                        .background(
                            GeometryReader { geo in
                                Color.clear.onAppear {
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
            .padding(.vertical, 5)
            .background(
                GeometryReader { geo in
                    let selectedIndex = tabs.firstIndex(of: selectedTab) ?? 0
                    if tabFrames.indices.contains(selectedIndex) {
                        let frame = tabFrames[selectedIndex]
                        Rectangle()
                            .fill(Color(red: 0.93, green: 0.29, blue: 0.03))
                            .frame(width: frame.width + 20, height: 2)
                            .offset(x: frame.minX - geo.frame(in: .global).minX - 10,
                                    y: geo.size.height + 6)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
                    } else {
                        EmptyView()
                    }
                }
            )
        }
    }
}

struct MainView: View {
    var body: some View {
        BoardMainViewController()
    }
}

struct DoctoralView: View {
    var body: some View {
        BoardDoctoralViewController()
    }
}

struct MasterView: View {
    var body: some View {
        BoardMasterViewController()
    }
}

struct AdmissionView: View {
    var body: some View {
        BoardAdmissionViewController()
    }
}

struct FreeView: View {
    var body: some View {
        BoardFreeViewController()
    }
}

#Preview {
    BoardViewController()
}

//
//  ScrappedLabDetailViewController.swift
//  Sukbakji
//
//  Created by KKM on 8/9/24.
//

import SwiftUI

struct ScrappedLabDetailViewController: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    // 뒤로가기 버튼
                    Button(action: {
                        // 뒤로가기 버튼 클릭 시 동작할 코드
                        self.presentationMode.wrappedValue.dismiss()
                        print("뒤로가기 버튼 tapped")
                    }) {
                        Image("BackButton")
                            .frame(width: Constants.nav, height: Constants.nav)
                    }
                    
                    Spacer()
                    
                    Text("즐겨찾는 연구실")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.Gray900)
                    
                    Spacer()
                    
                    // 더보기 버튼
                    Button(action: {
                        // 더보기 버튼 클릭 시 동작할 코드
                        print("수정 버튼 tapped")
                    }) {
                        Text("수정")
                            .font(
                            Font.custom("Pretendard", size: Constants.fontSize5)
                            .weight(Constants.fontWeightMedium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Constants.Gray800)
                    }
                    .padding(12)
                }
                
                Divider()
                
                ScrollView {
                    ScrappedLaboratory(
                                title: "성신여자대학교",
                                universityName: "성신여자대학교",
                                labName: "화학에너지융합학부 에너지재료연구실",
                                professorName: "구본재"
                            )
                    ScrappedLaboratory(
                                title: "성신여자대학교",
                                universityName: "성신여자대학교",
                                labName: "화학에너지융합학부 에너지재료연구실",
                                professorName: "구본재"
                            )
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ScrappedLabDetailViewController()
}

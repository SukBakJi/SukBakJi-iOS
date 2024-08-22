//
//  ScrappedLabDetailViewController.swift
//  Sukbakji
//
//  Created by KKM on 8/9/24.
//

import SwiftUI
import Alamofire

struct ScrappedLabDetailViewController: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var scrappedLaboratories: [ScrappedLabResult] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil
    
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
                    
                    // 수정 버튼
                    Button(action: {
                        // 수정 버튼 클릭 시 동작할 코드
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
                
                if isLoading {
                    ProgressView("로딩 중...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        ForEach(scrappedLaboratories, id: \.labId) { lab in
                            ScrappedLaboratory(
                                title: lab.universityName,
                                universityName: lab.universityName,
                                labName: lab.labName,
                                professorName: lab.professorName
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            loadScrappedLaboratories()
        }
    }
    
    func loadScrappedLaboratories() {
        let url = APIConstants.baseURL + "/labs/mypage/favorite-labs"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        NetworkManager.shared.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ScrappedLabModel.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isSuccess {
                        self.scrappedLaboratories = data.result
                        self.isLoading = false
                    } else {
                        self.errorMessage = data.message
                        self.isLoading = false
                    }
                case .failure(let error):
                    if let data = response.data,
                       let errorMessage = String(data: data, encoding: .utf8) {
                        print("Server error response: \(errorMessage)")
                    }
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
    }
}

#Preview {
    ScrappedLabDetailViewController()
}

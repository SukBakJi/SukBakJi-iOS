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
    @State private var isEditing: Bool = false // 수정 모드 활성화
    @State private var selectedLabs: Set<Int> = [] // 선택된 연구실들의 ID
    @State private var isAllSelected: Bool = false // 전체 선택 상태
    @State private var showAlert: Bool = false // 삭제 확인 알림
    
    var body: some View {
        NavigationView {
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
                    
                    Text("즐겨찾는 연구실")
                        .font(Font.custom("Pretendard", size: Constants.fontSizeXl).weight(Constants.fontWeightSemiBold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.Gray900)
                    
                    Spacer()
                    
                    // 수정 버튼 / 취소 버튼 토글
                    if isEditing {
                        Button(action: cancelEditing) {
                            Text("취소")
                                .font(Font.custom("Pretendard", size: Constants.fontSize5).weight(Constants.fontWeightMedium))
                                .foregroundColor(Constants.Gray800)
                        }
                    } else {
                        Button(action: startEditing) {
                            Text("수정")
                                .font(Font.custom("Pretendard", size: Constants.fontSize5).weight(Constants.fontWeightMedium))
                                .foregroundColor(Constants.Gray800)
                        }
                    }
                }
                .padding(.horizontal, 8)
                
                Divider()
                
                // 수정 모드에서 "전체 선택 (0/4)" 텍스트와 체크 이모지
                if isEditing {
                    HStack {
                        Text("전체 선택 (\(selectedLabs.count)/\(scrappedLaboratories.count))")
                        Button(action: toggleAllSelection) {
                            Image(systemName: isAllSelected ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isAllSelected ? .green : .gray)
                        }
                    }
                    .padding()
                }
                
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
                            HStack {
                                if isEditing {
                                    // 체크 이모지
                                    Button(action: {
                                        toggleSelection(for: lab.labId)
                                    }) {
                                        Image(systemName: selectedLabs.contains(lab.labId) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(selectedLabs.contains(lab.labId) ? .green : .gray)
                                    }
                                }
                                
                                ScrappedLaboratory(
                                    title: lab.universityName,
                                    universityName: lab.universityName,
                                    labName: lab.labName,
                                    professorName: lab.professorName,
                                    labId: lab.labId,
                                    researchTopics: lab.researchTopics
                                )
                                .padding(.horizontal, 24)
                            }
                        }
                        .padding(.top, 12)
                    }
                }
                
                if isEditing {
                    Button(action: deleteSelectedLabs) {
                        Text("삭제하기")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Constants.Orange700)
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            loadScrappedLaboratories()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("삭제 확인"),
                message: Text("선택한 연구실을 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("삭제")) {
                    confirmDelete()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func loadScrappedLaboratories() {
        let url = APIConstants.baseURL + "/labs/mypage/favorite-labs"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        NetworkAuthManager.shared.request(url, method: .get, headers: headers)
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
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
    }
    
    func startEditing() {
        isEditing = true
        selectedLabs.removeAll()
        isAllSelected = false
    }
    
    func cancelEditing() {
        isEditing = false
        selectedLabs.removeAll()
        isAllSelected = false
    }
    
    func toggleAllSelection() {
        if isAllSelected {
            selectedLabs.removeAll()
        } else {
            selectedLabs = Set(scrappedLaboratories.map { $0.labId })
        }
        isAllSelected.toggle()
    }
    
    func toggleSelection(for labId: Int) {
        if selectedLabs.contains(labId) {
            selectedLabs.remove(labId)
        } else {
            selectedLabs.insert(labId)
        }
    }
    
    func deleteSelectedLabs() {
        showAlert = true
    }
    
    func confirmDelete() {
        let labIdsToDelete = Array(selectedLabs)
        
        // 각 labId에 대해 개별적으로 삭제 요청 보내기
        for labId in labIdsToDelete {
            let url = APIConstants.baseURL + "/labs/\(labId)/cancel-favorite"
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            // DirectoryFavoriteCancelPostModel의 필드 이름을 labIds로 변경한 후 모델 생성
            let model = DirectoryFavoriteCancelPostModel(labIds: labIdsToDelete)
            
            NetworkAuthManager.shared.request(url, method: .post, parameters: model, encoder: JSONParameterEncoder.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DirectoryFavoriteCancelGetModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        if data.isSuccess {
                            // 삭제 후 연구실 목록 갱신
                            self.scrappedLaboratories.removeAll { selectedLabs.contains($0.labId) }
                            self.selectedLabs.removeAll()
                            self.isAllSelected = false
                            
                            // NotificationCenter를 사용하여 DirectoryMainViewController에 데이터 변경 알림
                            NotificationCenter.default.post(name: Notification.Name("BookmarkStatusChanged"), object: nil)
                            
                            // 뒤로가기
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.errorMessage = data.message
                        }
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
        }
    }
}

#Preview {
    ScrappedLabDetailViewController()
}

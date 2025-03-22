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
                                .padding(.trailing, 12)
                        }
                    } else {
                        Button(action: startEditing) {
                            Text("수정")
                                .font(Font.custom("Pretendard", size: Constants.fontSize5).weight(Constants.fontWeightMedium))
                                .foregroundColor(Constants.Gray800)
                                .padding(.trailing, 12)
                        }
                    }
                }
                .padding(.horizontal, 8)
                
                // 수정 모드에서 "전체 선택 (0/4)" 텍스트와 체크 이모지
                if isEditing {
                    HStack {
                        Button(action: toggleAllSelection) {
                            Image(isAllSelected ? "CheckFill" : "Check")
                            
                            Text("전체 선택 (\(selectedLabs.count)/\(scrappedLaboratories.count))")
                                .font(
                                    Font.custom("Pretendard", size: Constants.fontSizeS)
                                        .weight(Constants.fontWeightMedium)
                                )
                                .foregroundColor(Constants.Gray900)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .animation(.easeInOut(duration: 0.3))
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
                            HStack(spacing: 5) {
                                if isEditing {
                                    // 체크 이모지
                                    Button(action: {
                                        toggleSelection(for: lab.labId)
                                    }) {
                                        Image(selectedLabs.contains(lab.labId) ? "CheckFill" : "Check")
                                            .padding(.leading, 31)
                                    }
                                }
                                
                                // ScrappedLaboratory를 눌러도 정보 화면으로 넘어가지 않음
                                ScrappedLaboratory(
                                    title: lab.universityName,
                                    universityName: lab.universityName,
                                    labName: lab.labName,
                                    professorName: lab.professorName,
                                    labId: lab.labId,
                                    researchTopics: lab.researchTopics
                                )
                                .padding(.leading, isEditing ? 10 : 24)
                                .padding(.trailing, 24)
                            }
                        }
                        .padding(.top, 12)
                    }
                }
                
                if isEditing {
                    Button(action: deleteSelectedLabs) {
                        Text("삭제하기")
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeM)
                                    .weight(Constants.fontWeightSemiBold)
                            )
                            .foregroundColor(selectedLabs.isEmpty ? Constants.Gray500 : .white) // 텍스트 색상 변경
                            .padding(.vertical, 14.5)
                            .frame(maxWidth: .infinity)
                            .background(selectedLabs.isEmpty ? Constants.Gray200 : Constants.Orange700) // 배경색 변경
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .disabled(selectedLabs.isEmpty)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            loadScrappedLaboratories()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("즐겨찾는 연구실 삭제하기")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeL)
                            .weight(Constants.fontWeightSemiBold)
                    )
                    .foregroundStyle(Constants.Gray900),
                message: Text("선택한 연구실을 삭제할까요? 삭제 후 복구되지 않습니다")
                    .font(
                        Font.custom("Pretendard", size: 14)
                            .weight(.medium)
                    )
                    .foregroundColor(Constants.Gray800),
                primaryButton: .destructive(Text("삭제할게요")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeM)
                            .weight(Constants.fontWeightSemiBold)
                    )) {
                    confirmDelete()
                },
                secondaryButton: .cancel(Text("닫기"))
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
        withAnimation(.easeInOut(duration: 0.3)) {
            isEditing = true
            selectedLabs.removeAll()
            isAllSelected = false
        }
    }

    func cancelEditing() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isEditing = false
            selectedLabs.removeAll()
            isAllSelected = false
        }
    }
    
    func toggleAllSelection() {
        if isAllSelected {
            selectedLabs.removeAll()
        } else {
            selectedLabs = Set(scrappedLaboratories.map { $0.labId }) // 모든 항목을 선택
        }
        
        // 전체 선택 상태를 반영
        isAllSelected = selectedLabs.count == scrappedLaboratories.count
    }
    
    func toggleSelection(for labId: Int) {
        if selectedLabs.contains(labId) {
            selectedLabs.remove(labId)
        } else {
            selectedLabs.insert(labId)
        }
        
        // 전체 선택 상태를 반영
        isAllSelected = selectedLabs.count == scrappedLaboratories.count
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

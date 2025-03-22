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
        ZStack {
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
                                .foregroundColor(selectedLabs.isEmpty ? Constants.Gray500 : .white)
                                .padding(.vertical, 14.5)
                                .frame(maxWidth: .infinity)
                                .background(selectedLabs.isEmpty ? Constants.Gray200 : Constants.Orange700)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        .disabled(selectedLabs.isEmpty)
                    }
                }
            }
            // 커스텀 DeleteAlertView를 overlay로 띄움
            if showAlert {
                DeleteAlertView(
                    cancelAction: {
                        // "닫기" 버튼: 단순 취소(알림창 닫기)
                        showAlert = false
                    },
                    confirmAction: {
                        // "삭제할게요" 버튼: 삭제 함수 호출 후 알림창 닫기
                        confirmDelete()
                        showAlert = false
                    }
                )
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
            selectedLabs = Set(scrappedLaboratories.map { $0.labId })
        }
        isAllSelected = selectedLabs.count == scrappedLaboratories.count
    }
    
    func toggleSelection(for labId: Int) {
        if selectedLabs.contains(labId) {
            selectedLabs.remove(labId)
        } else {
            selectedLabs.insert(labId)
        }
        isAllSelected = selectedLabs.count == scrappedLaboratories.count
    }
    
    func deleteSelectedLabs() {
        // 기존에는 .alert를 사용했으나, 이제 커스텀 DeleteAlertView로 대체
        showAlert = true
    }
    
    func confirmDelete() {
        let labIdsToDelete = Array(selectedLabs)
        
        for labId in labIdsToDelete {
            let url = APIConstants.baseURL + "/labs/\(labId)/cancel-favorite"
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            let model = DirectoryFavoriteCancelPostModel(labIds: labIdsToDelete)
            
            NetworkAuthManager.shared.request(url, method: .post, parameters: model, encoder: JSONParameterEncoder.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DirectoryFavoriteCancelGetModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        if data.isSuccess {
                            self.scrappedLaboratories.removeAll { selectedLabs.contains($0.labId) }
                            self.selectedLabs.removeAll()
                            self.isAllSelected = false
                            
                            NotificationCenter.default.post(name: Notification.Name("BookmarkStatusChanged"), object: nil)
                            
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

struct DeleteAlertView: View {
    // 두 가지 액션 클로저를 받아 처리
    var cancelAction: () -> Void
    var confirmAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(spacing: 20) {
                    Text("즐겨찾는 연구실 삭제하기")
                        .font(Font.custom("Pretendard", size: Constants.fontSizeL).weight(Constants.fontWeightSemiBold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Constants.Gray900)
                    
                    Text("선택한 연구실을 삭제할까요? 삭제 후 복구되지 않습니다")
                        .font(Font.custom("Pretendard", size: 14).weight(.medium))
                        .foregroundColor(Constants.Gray800)
                        .padding(.bottom, 6)
                    
                    HStack(alignment: .center, spacing: 12) {
                        Button(action: {
                            cancelAction()
                        }) {
                            Text("닫기")
                                .font(Font.custom("Pretendard", size: Constants.fontSizeM).weight(Constants.fontWeightMedium))
                                .foregroundStyle(Constants.Gray500)
                                .padding(.vertical, 14.5)
                                .padding(.horizontal, 46)
                                .background(Constants.Gray200)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            confirmAction()
                        }) {
                            Text("삭제할게요")
                                .font(Font.custom("Pretendard", size: Constants.fontSizeM).weight(Constants.fontWeightSemiBold))
                                .foregroundStyle(.white)
                                .padding(.vertical, 14.5)
                                .padding(.horizontal, 26)
                                .background(Constants.Orange700)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 20)
                .background(Constants.White)
                .cornerRadius(16)
            }
            .padding(.horizontal, 48)
        }
    }
}

#Preview {
    ScrappedLabDetailViewController()
}

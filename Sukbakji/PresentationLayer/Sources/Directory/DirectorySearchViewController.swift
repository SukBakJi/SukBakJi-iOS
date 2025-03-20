//
//  DirectorySearchViewController().swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import SwiftUI
import Alamofire

struct DirectorySearchViewController: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var searchText: String
    @FocusState private var isSearchFieldFocused: Bool
    @State private var hasSearchResults: Bool = true // 검색 결과 상태 변수
    @State private var filteredResults: [LabResult] = [] // 검색 결과를 저장할 상태 변수
    @State private var recentSearches: [String] = ["열화학", "딥러닝", "HCI", "로보틱스"] // 최근 검색어 저장
    @State private var selectedUniversity: String? = "대학교 정렬" // 선택된 대학교를 저장할 변수, 기본값 설정
    @State private var isLoading: Bool = false // 로딩 상태를 나타내는 변수

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        Image("Search")
                            .resizable()
                            .frame(width: 24, height: 24)

                        TextField("학과와 연구 주제로 검색해 보세요", text: $searchText, onCommit: performSearch)
                            .focused($isSearchFieldFocused)
                            .padding(.leading, 12)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Constants.Gray900)

                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = "" // 텍스트 지우기
                                performSearch() // 텍스트 지우기 후 검색 결과 갱신
                            }) {
                                Image("Circle X")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .padding(.trailing, 6)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Constants.Gray50)
                    .cornerRadius(12)

                    Button("취소") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Constants.Gray800)
                    .padding(.leading, 10)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                ScrollView {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.top, 50)
                    } else if !filteredResults.isEmpty {
                        // 검색 결과가 있을 때의 뷰
                        SearchView(searchResults: filteredResults, selectedUniversity: $selectedUniversity, performSearch: performSearch)
                    } else {
                        if !searchText.isEmpty {
                            // 검색 결과가 없을 때의 뷰
                            VStack(alignment: .center, spacing: 8) {
                                Image("Warning")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .padding(.bottom, 20)

                                Text("\(searchText)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 0.93, green: 0.29, blue: 0.03))
                                + Text("에 대한 검색 결과가 없어요")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Constants.Gray900)
                                Text("이렇게 검색해 보는 건 어때요?")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSize5)
                                        .weight(Constants.fontWeightMedium)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Constants.Gray500)

                                Spacer()
                                    
                                SearchRecommendView()
                                    .padding(.top, 12)
                                    
                            }
                            .padding(.vertical, 80)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            // 최근 검색어 뷰
                            if recentSearches.isEmpty {
                                VStack(alignment: .center, spacing: 8) {
                                    Text("최근에 검색한 결과가 없어요")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Constants.Gray900)

                                    Spacer()
                                }
                                .padding(.vertical, 144)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("최근 검색")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(Constants.Gray900)

                                        Spacer()

                                        Button("전체 삭제") {
                                            recentSearches.removeAll()
                                        }
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Constants.Gray800)
                                    }
                                    .padding(.horizontal, 24)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(recentSearches, id: \.self) { search in
                                                HStack {
                                                    Text(search)
                                                        .font(Font.custom("Pretendard", size: Constants.fontSize5)
                                                            .weight(Constants.fontWeightMedium))
                                                        .foregroundColor(Constants.Gray500)

                                                    Button(action: {
                                                        deleteSearch(search)
                                                    }) {
                                                        Image("cross")
                                                            .resizable()
                                                            .frame(width: 12, height: 12)
                                                            .foregroundColor(Constants.Gray300)
                                                    }
                                                }
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 6)
                                                .background(Constants.Gray50)
                                                .cornerRadius(999)
                                            }
                                        }
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                    }
                                }
                                .padding(.top, 20)
                            }
                        }
                    }
                }
                AdvertisementView()
            }
            .onAppear {
                isSearchFieldFocused = true // 화면이 나타날 때 검색창에 자동으로 포커스를 설정
                performSearch() // 화면이 나타날 때 검색 수행
            }
        }
        .navigationBarBackButtonHidden()
    }

    func performSearch() {
        guard !searchText.isEmpty else { return }

        isLoading = true
        filteredResults = []

        guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user"), !accessToken.isEmpty else {
            print("토큰이 없습니다.")
            isLoading = false
            return
        }

        DirectoryLabSearchApi(keyword: searchText, userToken: accessToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self.filteredResults = results
                case .failure(let error):
                    print("Error searching labs: \(error.localizedDescription)")
                }
                self.isLoading = false
            }
        }

        if !searchText.isEmpty && !recentSearches.contains(searchText) {
            recentSearches.insert(searchText, at: 0)
        }
    }

    func DirectoryLabSearchApi(keyword: String, userToken: String, completion: @escaping (Result<[LabResult], Error>) -> Void) {
        // API 엔드포인트에 Query Parameters 추가
        let url = "\(APIConstants.baseURL)/labs/search?topicName=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&page=0&size=6"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(userToken)"
        ]
        
        print("Request URL: \(url)")

        AF.request(url,
                   method: .post,
                   encoding: JSONEncoding.default, // body를 보내지 않으므로 encoding 제거 가능
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: DirectoryLabSearchGetModel.self) { response in
            switch response.result {
            case .success(let data):
                if data.isSuccess {
                    completion(.success(data.result.responseDTOList))
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: data.message])
                    completion(.failure(error))
                }
            case .failure(let error):
                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                }
                print("Response Error: \(response.debugDescription)")
                completion(.failure(error))
            }
        }
    }

    func deleteSearch(_ search: String) {
        if let index = recentSearches.firstIndex(of: search) {
            recentSearches.remove(at: index)
        }
    }
}

struct SearchView: View {
    var searchResults: [LabResult]
    @Binding var selectedUniversity: String?
    var performSearch: () -> Void
    
    var filteredResults: [LabResult] {
        // selectedUniversity가 설정된 경우 해당 학교에 속한 연구실만 필터링
        if let selectedUniversity = selectedUniversity, selectedUniversity != "대학교 정렬" {
            return searchResults.filter { $0.universityName == selectedUniversity }
        } else {
            return searchResults
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("\(filteredResults.count)건")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Constants.Gray900)
                
                Spacer()
                
                Menu {
                    Button("대학교 정렬") {
                        selectedUniversity = "대학교 정렬"
                        performSearch()
                    }
                    Button("서울대학교") {
                        selectedUniversity = "서울대학교"
                        performSearch()
                    }
                    Button("연세대학교") {
                        selectedUniversity = "연세대학교"
                        performSearch()
                    }
                    Button("고려대학교") {
                        selectedUniversity = "고려대학교"
                        performSearch()
                    }
                    Button("카이스트") {
                        selectedUniversity = "카이스트"
                        performSearch()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedUniversity ?? "대학교 정렬")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Constants.Gray800)
                        
                        Image("More 2")
                            .resizable()
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .padding(.horizontal, 24)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredResults, id: \.labId) { result in
                        NavigationLink(destination: LabDetailViewController(labId: result.labId)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(result.universityName)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Constants.Gray900)
                                
                                Text(result.professorName)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Constants.Gray800)
                                
                                Text(result.departmentName)
                                    .font(.system(size: 14))
                                    .foregroundColor(Constants.Gray600)
                                
                                Text(result.researchTopics.joined(separator: ", "))
                                    .font(.system(size: 14))
                                    .foregroundColor(Constants.Gray600)
                                    .lineLimit(2) // 최대 2줄로 제한
                                    .multilineTextAlignment(.leading) // 여러 줄일 때도 왼쪽 정렬
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Constants.Gray50)
                            .cornerRadius(8)
                            .padding(.horizontal, 24)
                        }
                    }
                }
            }
            
            Button(action: {
                print("연구실 정보 더보기 tapped!")
            }) {
                HStack {
                    Text("연구실 정보 더보기")
                        .font(.system(size: 14))
                        .foregroundColor(Constants.Gray900)
                        
                    Image("More 2")
                        .resizable()
                        .frame(width: 12, height: 12)
                }
                .padding(10)
                .padding(.horizontal, 10)
                .frame(alignment: .center)
                .cornerRadius(999)
                .overlay(
                    RoundedRectangle(cornerRadius: 999)
                        .inset(by: 0.5)
                        .stroke(Constants.Gray300, lineWidth: 1)
                )
            }
            .padding(.top, 16)
        }
        .padding(.vertical, 16)
    }
}


struct SearchRecommendView: View {
    var body: some View {
        HStack() { // HStack 간의 간격을 16으로 설정
            VStack(alignment: .leading, spacing: 8) {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(Constants.Gray100)
                    .overlay(
                        Image("SearchRecommend")
                            .resizable()
                            .frame(width: 19, height: 19)
                            .cornerRadius(999)
                    )
                
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(Constants.Gray100)
                    .overlay(
                        Image("SearchRecommend 1")
                            .resizable()
                            .frame(width: 19, height: 19)
                            .cornerRadius(999)
                    )
                
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(Constants.Gray100)
                    .overlay(
                        Image("SearchRecommend 2")
                            .resizable()
                            .frame(width: 19, height: 19)
                            .cornerRadius(999)
                    )
                
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(Constants.Gray100)
                    .overlay(
                        Image("SearchRecommend 3")
                            .resizable()
                            .frame(width: 19, height: 19)
                            .cornerRadius(999)
                    )
                
                
            }
            
            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading) {
                    Text("정확한 대학교명")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize6)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.Gray800)
                    
                    Text("석박지대학교")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize7)
                                .weight(.regular)
                        )
                        .foregroundColor(Constants.Gray600)
                }
                
                VStack(alignment: .leading) {
                    Text("다시 확인해 보는 교수명")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize6)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.Gray800)
                    
                    Text("석박지 교수")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize7)
                                .weight(.regular)
                        )
                        .foregroundColor(Constants.Gray600)
                }
                
                VStack(alignment: .leading) {
                    Text("철자가 맞는 연구실 이름")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize6)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.Gray800)
                    
                    Text("석박지 연구실")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize7)
                                .weight(.regular)
                        )
                        .foregroundColor(Constants.Gray600)
                }
                
                VStack(alignment: .leading) {
                    Text("알맞은 연구 주제명")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize6)
                                .weight(Constants.fontWeightMedium)
                        )
                        .foregroundColor(Constants.Gray800)
                    
                    Text("석박지는 어떻게 담궈야 할까?")
                        .font(
                            Font.custom("Pretendard", size: Constants.fontSize7)
                                .weight(.regular)
                        )
                        .foregroundColor(Constants.Gray600)
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }
}

// 미리보기 제공
struct DirectorySearchViewController_Previews: PreviewProvider {
    static var previews: some View {
        DirectorySearchViewController(searchText: .constant(""))
    }
}

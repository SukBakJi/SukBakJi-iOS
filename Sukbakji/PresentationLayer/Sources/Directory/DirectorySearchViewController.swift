//
//  DirectorySearchViewController.swift
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
    @State private var hasSearchResults: Bool = true
    @State private var filteredResults: [LabResult] = []
    @State private var recentSearches: [String] = [] // 최근 검색어 저장
    @State private var selectedUniversity: String? = "전체"
    @State private var isLoading: Bool = false
    @State private var hasSearched: Bool = false // 사용자가 실제 검색을 시도했는지 여부

    init(searchText: Binding<String>) {
        self._searchText = searchText
        loadRecentSearches()
    }

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
                                // 검색어 텍스트 및 검색 결과 초기화하여 최근 검색어 화면으로 복귀
                                searchText = ""
                                filteredResults = []
                                hasSearched = false // 검색 시도가 초기화되면 false로 설정
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
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 50)
                    
                    Spacer()
                } else if !filteredResults.isEmpty {
                    SearchView(searchResults: filteredResults, selectedUniversity: $selectedUniversity, performSearch: performSearch)
                } else if hasSearched {
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
                            .font(Font.custom("Pretendard", size: Constants.fontSize5)
                                .weight(Constants.fontWeightMedium))
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
                        NoRecentSearchView()
                    } else {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("최근 검색어")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSizeM)
                                            .weight(Constants.fontWeightSemiBold)
                                    )
                                    .foregroundColor(Constants.Gray900)
                                Spacer()
                                
                                Button("전체 삭제") {
                                    recentSearches.removeAll()
                                    saveRecentSearches()  // Save empty list when deleted
                                }
                                .font(
                                    Font.custom("Pretendard", size: Constants.fontSizeXxs)
                                        .weight(Constants.fontWeightRegular)
                                )
                                .foregroundColor(Constants.Gray500)
                            }
                            .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(recentSearches, id: \.self) { search in
                                        HStack(spacing: 8) {
                                            Button(action: {
                                                searchText = search
                                                performSearch()
                                            }) {
                                                Text(search)
                                                    .font(Font.custom("Pretendard", size: Constants.fontSize5)
                                                        .weight(Constants.fontWeightMedium))
                                                    .foregroundColor(Constants.Gray500)
                                            }
                                            
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
                    
                    Spacer()
                }
            }
            .onAppear {
                loadRecentSearches()  // 화면이 나타날 때마다 최근 검색어 로드
                isSearchFieldFocused = true
            }
        }
        .navigationBarBackButtonHidden()
    }

    // 검색어를 추가하거나 업데이트 할 때마다 UserDefaults에 저장
    func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }

    // UserDefaults에서 검색 기록을 불러오는 함수
    func loadRecentSearches() {
        if let savedSearches = UserDefaults.standard.array(forKey: "recentSearches") as? [String] {
            recentSearches = savedSearches
        }
    }

    func performSearch() {
        guard !searchText.isEmpty else { return }

        hasSearched = true
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
            saveRecentSearches()  // Save the updated search history
        }
    }

    // DirectoryLabSearchApi 함수 수정
    func DirectoryLabSearchApi(keyword: String, userToken: String, page: Int = 0, size: Int = 1000, completion: @escaping (Result<[LabResult], Error>) -> Void) {
        let url = "\(APIConstants.baseURL)/labs/search?topicName=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&page=\(page)&size=\(size)"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(userToken)"
        ]
        
        print("Request URL: \(url)")

        AF.request(url,
                   method: .post,
                   encoding: JSONEncoding.default,
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
            saveRecentSearches()  // Save the updated search history after deletion
        }
    }
}

struct NoRecentSearchView: View {
    var body: some View {
        VStack {
            Text("최근에 검색한 결과가 없어요")
                .font(
                    Font.custom("Pretendard", size: Constants.fontSizeS)
                        .weight(Constants.fontWeightSemiBold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Constants.Gray500)
                .padding(.vertical, 80)

            
            Spacer()
            
//            AdvertisementView()
//                .padding(.bottom, 12)
        }
    }
}

struct SearchView: View {
    var searchResults: [LabResult]
    @Binding var selectedUniversity: String?
    var performSearch: () -> Void

    var distinctUniversities: [String] {
        let universities = searchResults.map { $0.universityName }
        return Array(Set(universities)).sorted()
    }

    var filteredResults: [LabResult] {
        if let selected = selectedUniversity, selected != "전체" {
            return searchResults.filter { $0.universityName == selected }
        } else {
            return searchResults
        }
    }
    
    // GridItem을 사용하여 두 개의 열을 설정
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // visibleCount를 6으로 초기화
    @State private var visibleCount: Int = 6

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("\(filteredResults.count) 건")
                    .font(
                        Font.custom("Pretendard", size: Constants.fontSizeS)
                            .weight(Constants.fontWeightMedium)
                    )
                    .foregroundColor(Constants.Gray900)
                
                Spacer()
                
                let filterColor: Color = (selectedUniversity != "전체" && selectedUniversity != nil) ? Color(red: 0.93, green: 0.29, blue: 0.03) : Constants.Gray800
                
                Menu {
                    Button("전체") {
                        selectedUniversity = "전체"
                        performSearch()
                    }
                    
                    ForEach(distinctUniversities, id: \.self) { uni in
                        Button(uni) {
                            selectedUniversity = uni
                            performSearch()
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        let labelText = (selectedUniversity == "전체" || selectedUniversity == nil) ? "대학교 정렬" : selectedUniversity!
                        Text(labelText)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(filterColor)
                        Image("More 2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(filterColor)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 13.5)
            
            Divider()
            
            Text("검색 결과")
                .font(
                    Font.custom("Pretendard", size: Constants.fontSizeM)
                        .weight(Constants.fontWeightSemiBold)
                )
                .foregroundColor(Constants.Gray900)
                .padding(.horizontal, 24)

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(filteredResults.prefix(visibleCount), id: \.labId) { result in
                        SearchedLaboratory(
                            title: result.universityName,
                            universityName: result.universityName,
                            labName: result.labName,
                            professorName: result.professorName,
                            labId: result.labId,
                            researchTopics: result.researchTopics
                        )
                    }
                }
                .padding(.horizontal, 24)

                // "연구실 정보 더보기" 버튼은 visibleCount가 filteredResults.count 미만일 때만 보임
                if visibleCount < filteredResults.count {
                    Button(action: {
                        // 6개씩 추가로 보이도록 visibleCount를 6씩 증가
                        withAnimation(.easeInOut) {
                            visibleCount = min(visibleCount + 6, filteredResults.count)
                        }
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
                        .cornerRadius(999)
                        .overlay(
                            RoundedRectangle(cornerRadius: 999)
                                .inset(by: 0.5)
                                .stroke(Constants.Gray300, lineWidth: 1)
                        )
                    }
                    .padding(.vertical, 16)
                }
            }
        }
        .onChange(of: filteredResults.count) { _ in
            // 새로운 검색 결과가 도착하면 visibleCount를 초기화
            visibleCount = 6
        }
    }
}

struct SearchedLaboratory: View {
    var title: String
    var universityName: String
    var labName: String
    var professorName: String
    var labId: Int // Add labId to the view
    var researchTopics: [String] // researchTopics를 배열로 받음
    
    var body: some View {
        NavigationLink(destination: LabDetailViewController(labId: labId)) {
            HStack {
                ZStack(alignment: .topLeading) {
                    VStack(spacing: 0) {
                        Constants.White
                            .frame(height: 70) // 상단 흰색 배경
                        Constants.Gray50
                    }
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: 0.5)
                            .stroke(Constants.Gray100, lineWidth: 1)
                    )
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(title)
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeXs)
                                    .weight(Constants.fontWeightMedium)
                            )
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                        
                        Text(labName)
                            .font(
                                Font.custom("Pretendard", size: Constants.fontSizeS)
                                    .weight(Constants.fontWeightSemiBold)
                            )
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        
                        HStack(alignment: .center, spacing: 12) {
                            Image("Profile Image")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(professorName)
                                        .font(
                                            Font.custom("Pretendard", size: Constants.fontSizeS)
                                                .weight(Constants.fontWeightSemiBold)
                                        )
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Text("교수")
                                        .font(
                                            Font.custom("Pretendard", size: Constants.fontSizeXs)
                                                .weight(Constants.fontWeightMedium)
                                        )
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                
                                Text("\(universityName) \(labName)")
                                    .font(
                                        Font.custom("Pretendard", size: Constants.fontSizeXs)
                                            .weight(Constants.fontWeightMedium)
                                    )
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.top, 12)
                        .padding(.horizontal, 16)
                        
                        // 연구 주제들 출력
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(researchTopics, id: \.self) { topic in
                                    KeywordView(keywordName: topic)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.bottom, 16)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct SearchRecommendView: View {
    var body: some View {
        HStack {
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
                        .font(Font.custom("Pretendard", size: Constants.fontSize6)
                            .weight(Constants.fontWeightMedium))
                        .foregroundColor(Constants.Gray800)
                    
                    Text("석박지대학교")
                        .font(Font.custom("Pretendard", size: Constants.fontSize7)
                            .weight(.regular))
                        .foregroundColor(Constants.Gray600)
                }
                
                VStack(alignment: .leading) {
                    Text("다시 확인해 보는 교수명")
                        .font(Font.custom("Pretendard", size: Constants.fontSize6)
                            .weight(Constants.fontWeightMedium))
                        .foregroundColor(Constants.Gray800)
                    
                    Text("석박지 교수")
                        .font(Font.custom("Pretendard", size: Constants.fontSize7)
                            .weight(.regular))
                        .foregroundColor(Constants.Gray600)
                }
                
                VStack(alignment: .leading) {
                    Text("철자가 맞는 연구실 이름")
                        .font(Font.custom("Pretendard", size: Constants.fontSize6)
                            .weight(Constants.fontWeightMedium))
                        .foregroundColor(Constants.Gray800)
                    
                    Text("석박지 연구실")
                        .font(Font.custom("Pretendard", size: Constants.fontSize7)
                            .weight(.regular))
                        .foregroundColor(Constants.Gray600)
                }
                
                VStack(alignment: .leading) {
                    Text("알맞은 연구 주제명")
                        .font(Font.custom("Pretendard", size: Constants.fontSize6)
                            .weight(Constants.fontWeightMedium))
                        .foregroundColor(Constants.Gray800)
                    
                    Text("석박지는 어떻게 담궈야 할까?")
                        .font(Font.custom("Pretendard", size: Constants.fontSize7)
                            .weight(.regular))
                        .foregroundColor(Constants.Gray600)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }
}

struct DirectorySearchViewController_Previews: PreviewProvider {
    static var previews: some View {
        DirectorySearchViewController(searchText: .constant(""))
    }
}

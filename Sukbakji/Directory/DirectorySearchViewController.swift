//
//  DirectorySearchViewController().swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import SwiftUI

struct DirectorySearchViewController: View {

    @Environment(\.presentationMode) var presentationMode
    @Binding var searchText: String
    @FocusState private var isSearchFieldFocused: Bool
    @State private var hasSearchResults: Bool = true // 검색 결과 상태 변수
    @State private var filteredResults: [ScrappedLaboratory] = [] // 검색 결과를 저장할 상태 변수
    @State private var recentSearches: [String] = ["열화학", "딥러닝", "HCI", "로보틱스"] // 최근 검색어 저장
    @State private var selectedUniversity: String? = "대학교 정렬" // 선택된 대학교를 저장할 변수, 기본값 설정

    var body: some View {
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

                    // 'X' 버튼 추가: 텍스트가 있을 때만 표시되도록 조건 설정
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
                if !filteredResults.isEmpty {
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
                        .padding(.vertical, 144)
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
                                                    Image("Cross")
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
        .navigationBarBackButtonHidden()
        .onAppear {
            isSearchFieldFocused = true // 화면이 나타날 때 검색창에 자동으로 포커스를 설정
            performSearch() // 화면이 나타날 때 검색 수행
        }
    }

    func performSearch() {
        // 모든 데이터를 합쳐 검색할 수 있는 데이터 배열 생성
        let allData = [
            ScrappedLaboratory(
                title: "성신여자대학교",
                universityName: "성신여자대학교",
                labName: "화학에너지융합학부 에너지재료연구실",
                professorName: "구본재"
            ),
            ScrappedLaboratory(
                title: "서울대학교",
                universityName: "서울대학교",
                labName: "화학에너지융합학부 에너지재료연구실",
                professorName: "구본재"
            ),
            ScrappedLaboratory(
                title: "연세대학교",
                universityName: "연세대학교",
                labName: "화학에너지융합학부 에너지재료연구실",
                professorName: "구본재"
            ),
            ScrappedLaboratory(
                title: "고려대학교",
                universityName: "고려대학교",
                labName: "화학에너지융합학부 에너지재료연구실",
                professorName: "구본재"
            ),
            ScrappedLaboratory(
                title: "카이스트",
                universityName: "카이스트",
                labName: "화학에너지융합학부 에너지재료연구실",
                professorName: "구본재"
            ),
        ]
        
        // 검색 결과 필터링
        filteredResults = allData.filter { lab in
            (selectedUniversity == "대학교 정렬" || selectedUniversity == nil || lab.universityName == selectedUniversity) &&
            (lab.title.contains(searchText) ||
             lab.universityName.contains(searchText) ||
             lab.labName.contains(searchText) ||
             lab.professorName.contains(searchText))
        }

        // 검색 결과가 있는지 확인
        hasSearchResults = !filteredResults.isEmpty
        
        // 검색어를 최근 검색어 목록에 추가
        if !searchText.isEmpty && !recentSearches.contains(searchText) {
            recentSearches.insert(searchText, at: 0)
        }
    }

    func deleteSearch(_ search: String) {
        if let index = recentSearches.firstIndex(of: search) {
            recentSearches.remove(at: index)
        }
    }
}

struct SearchView: View {
    var searchResults: [ScrappedLaboratory]
    @Binding var selectedUniversity: String?
    var performSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("\(searchResults.count)건")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Constants.Gray900)
                
                Spacer()
                
                // 드롭다운 메뉴
                Menu {
                    Button("대학교 정렬") {
                        selectedUniversity = "대학교 정렬"
                        performSearch() // 대학 선택 시 검색 수행
                    }
                    Button("서울대학교") {
                        selectedUniversity = "서울대학교"
                        performSearch() // 대학 선택 시 검색 수행
                    }
                    Button("연세대학교") {
                        selectedUniversity = "연세대학교"
                        performSearch() // 대학 선택 시 검색 수행
                    }
                    Button("고려대학교") {
                        selectedUniversity = "고려대학교"
                        performSearch() // 대학 선택 시 검색 수행
                    }
                    Button("카이스트") {
                        selectedUniversity = "카이스트"
                        performSearch() // 대학 선택 시 검색 수행
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
            
            VStack(spacing: 16) {
                ForEach(0..<searchResults.count, id: \.self) { index in
                    searchResults[index]
                        .padding(.horizontal, 24) // 각 항목의 좌우 여백을 24로 지정
                }
            }
            
            Button(action: {
                // 연구실 정보 더보기 버튼 클릭 시 동작할 코드
                print("연구실 정보 더보기 tapped!")
            }) {
                HStack {
                    Text("연구실 정보 더보기")
                        .font(
                        Font.custom("Pretendard", size: Constants.fontSize7)
                            .weight(.regular)
                        )
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
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 8) {
                Image("SearchRecommend")
                    .resizable()
                    .frame(width: 19, height: 19)
                    .cornerRadius(999)
                
                VStack(alignment: .leading, spacing: 4) {
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .center, spacing: 8) {
                Image("SearchRecommend 1")
                    .resizable()
                    .frame(width: 19, height: 19)
                    .cornerRadius(999)
                
                VStack(alignment: .leading, spacing: 4) {
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .center, spacing: 8) {
                Image("SearchRecommend 2")
                    .resizable()
                    .frame(width: 19, height: 19)
                    .cornerRadius(999)
                
                VStack(alignment: .leading, spacing: 4) {
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .center, spacing: 8) {
                Image("SearchRecommend 3")
                    .resizable()
                    .frame(width: 19, height: 19)
                    .cornerRadius(999)
                
                VStack(alignment: .leading, spacing: 4) {
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .center) // 가운데 정렬
        .padding(.horizontal, 24) // 전체 패딩 추가
    }
}


// 미리보기 제공
struct DirectorySearchViewController_Previews: PreviewProvider {
    static var previews: some View {
        DirectorySearchViewController(searchText: .constant(""))
    }
}

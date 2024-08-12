//
//  SwiftUIView.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import SwiftUI

// 게시글 모델
struct Post: Identifiable {
    var id = UUID()
    var title: String
    var content: String
}

// 게시글 목록을 관리하는 ViewModel
class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []

    func addPost(title: String, content: String) {
        let newPost = Post(title: title, content: content)
        posts.append(newPost)
    }
}

// 게시판 목록 뷰
struct PostListView: View {
    @ObservedObject var viewModel = PostViewModel()
    @State private var showingCreatePostView = false

    var body: some View {
        NavigationView {
            List(viewModel.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.content)
                        .font(.subheadline)
                }
            }
            .navigationTitle("게시판 목록")
            .navigationBarItems(trailing: Button(action: {
                showingCreatePostView.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingCreatePostView) {
                CreatePostView(viewModel: viewModel)
            }
        }
    }
}

// 게시글 작성 뷰
struct CreatePostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PostViewModel
    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("제목")) {
                    TextField("제목을 입력하세요", text: $title)
                }
                Section(header: Text("내용")) {
                    TextField("내용을 입력하세요", text: $content)
                }
            }
            .navigationBarTitle("게시글 작성", displayMode: .inline)
            .navigationBarItems(leading: Button("취소") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("저장") {
                viewModel.addPost(title: title, content: content)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// 메인 앱 구조
struct BulletinBoardApp: App {
    var body: some Scene {
        WindowGroup {
            PostListView()
        }
    }
}


#Preview {
    PostListView()
}

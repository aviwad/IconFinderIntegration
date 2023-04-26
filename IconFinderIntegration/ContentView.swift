//
//  ContentView.swift
//  IconFinderIntegration
//
//  Created by Avi Wadhwa on 25/04/23.
//

import SwiftUI

//@MainActor class ViewModel: ObservableObject {
//    @Published var categories: [CategoryElement] = []
//    @Published var currentError: errorType = .working
//    func fetch(urlString: String) async {
//        guard let url = URL(string: urlString) else {
//            currentError = .urlError
//            return
//        }
//        var request = URLRequest(url: url)
//        let headers = [
//          "accept": "application/json",
//          "Authorization": "Bearer X0vjEUN6KRlxbp2DoUkyHeM0VOmxY91rA6BbU5j3Xu6wDodwS0McmilLPBWDUcJ1"
//        ]
//        request.allHTTPHeaderFields = headers
//        request.httpMethod = "GET"
//        do {
//            let (data, _) = try await URLSession.shared.data(for: request)
//            do {
//                let json = try JSONDecoder().decode(Category.self, from: data)
//                categories = json.categories
//                currentError = .working
//                print(json.categories)
//            }
//            catch {
//                currentError = .incorrectRequest
//            }
//        }
//        catch {
//            currentError = .urlError
//        }
//    }
//}

struct ContentView: View {
    @StateObject var viewModel = ViewModel(viewModelType: .ContentView)
    @StateObject var searchViewModel = ViewModel(viewModelType: .IconSetPage)
    @State private var searchText : String = ""
    var body: some View {
        switch viewModel.currentError {
        case .urlError:
            VStack(spacing: 30) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 100))
                VStack {
                    Text("A Network Error Occurred.")
                        .multilineTextAlignment(.center)
                    Text("Are You Connected To The Internet?")
                        .multilineTextAlignment(.center)
                }
                Button("Refresh") {
                    Task {
                        await viewModel.fetch(urlString: "https://api.iconfinder.com/v4/categories?count=100", fetchType: .regular)
                    }
                }
            }
        case .incorrectRequest:
            VStack(spacing: 30) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 100))
                VStack {
                    Text("A Network Error Occurred.")
                        .multilineTextAlignment(.center)
                    Text("The Server Must Be Down?")
                        .multilineTextAlignment(.center)
                }
                Button("Refresh") {
                    Task {
                        await viewModel.fetch(urlString: "https://api.iconfinder.com/v4/categories?count=100", fetchType: .regular)
                    }
                }
            }
        default:
            NavigationStack {
                VStack {
                    if (searchViewModel.iconList.isEmpty) {
                        if (viewModel.categories.isEmpty) {
                            ProgressView()
                        } else {
                            List {
                                ForEach(viewModel.categories) { category in
                                    NavigationLink {
                                        CategoryPage(category: category)
                                    } label: {
                                        Label(category.name, systemImage: "circle")
                                    }
                                }
                                if (viewModel.categories.count < viewModel.totalCount) {
                                    Button() {
                                        
                                        Task.init() {
                                            await viewModel.fetch(urlString: "https://api.iconfinder.com/v4/categories?count=100&after=\(viewModel.categories.last!.identifier)",fetchType: .append)
                                        }
                                    } label: {
                                        Text("Load more")
                                    }
                                }
                            }
                        }
                    } else {
                        List {
                            ForEach(searchViewModel.iconList) { icon in
                                if (!icon.isPremium) {
                                    NavigationLink {
                                        IconPage(icon: icon)
                                    } label: {
                                        HStack {
                                            AsyncImage(
                                                url: URL(string: icon.rasterSizes!.last!.formats.last!.previewURL),
                                                content: { image in
                                                    image.resizable()
                                                         .aspectRatio(contentMode: .fit)
                                                         .frame(maxWidth: 50, maxHeight: 50)
                                                },
                                                placeholder: {
                                                    ProgressView()
                                                }
                                            )
            //                                AsyncImage(url: URL(string: icon.rasterSizes!.last!.formats.last!.previewURL))
            //                                    .frame(maxWidth: 100, maxHeight: 100)
                                            Spacer()
                                            if (icon.isPremium) {
                                                Text("Only Premium Users Can Download")
                                                    .font(.footnote)
                                            } else {
                                                Button{
                                                    
                                                } label: {
                                                    HStack {
                                                        Text("Free Download")
                                                            .bold()
                                                        
                                                        Image(systemName: "arrow.down.circle.fill")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    HStack {
                                        AsyncImage(
                                            url: URL(string: icon.rasterSizes!.last!.formats.last!.previewURL),
                                            content: { image in
                                                image.resizable()
                                                     .aspectRatio(contentMode: .fit)
                                                     .frame(maxWidth: 50, maxHeight: 50)
                                            },
                                            placeholder: {
                                                ProgressView()
                                            }
                                        )
        //                                AsyncImage(url: URL(string: icon.rasterSizes!.last!.formats.last!.previewURL))
        //                                    .frame(maxWidth: 100, maxHeight: 100)
                                        Spacer()
                                        if (icon.isPremium) {
                                            Text("Only Premium Users Can Download")
                                                .font(.footnote)
                                        } else {
                                            Button{
                                                
                                            } label: {
                                                HStack {
                                                    Text("Free Download")
                                                        .bold()
                                                    
                                                    Image(systemName: "arrow.down.circle.fill")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("All Categories")
                .searchable(text: $searchText)
                .onChange(of: searchText) { searchText in
                    viewModel.searchTimer?.invalidate()
                    viewModel.searchTimer = Timer.scheduledTimer(withTimeInterval: 0.45, repeats: false, block: { [self] (timer) in
                      DispatchQueue.global(qos: .userInteractive).async { [self] in
                        //Use search text and perform the query
                        DispatchQueue.main.async {
                          //Update UI
                            if (searchText.count < 1) {
                                searchViewModel.cancelled = true
                                searchViewModel.iconList = []
                                //print("cancelled")
                            } else {
                                searchViewModel.cancelled = false
                                Task {
                                    await searchViewModel.fetch(urlString: "https://api.iconfinder.com/v4/icons/search?query=\(searchText)&count=50",fetchType: .search)
                                }
                                //print(searchText)
                            }
                        }
                      }
                    })
                }
            }
            .onAppear {
                //print("on appear")
                Task.init() {
                    await viewModel.fetch(urlString: "https://api.iconfinder.com/v4/categories?count=100",fetchType: .regular)
                }
            }
        }
    }
}

//
//  CategoryPage.swift
//  IconFinderIntegration
//
//  Created by Avi Wadhwa on 25/04/23.
//

import SwiftUI

//@MainActor class iconSet: ObservableObject {
//    @Published var iconSets: [Iconset] = []
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
//                print(data.debugDescription)
//                let json = try JSONDecoder().decode(IconSetParent.self, from: data)
//                iconSets = json.iconsets
//                currentError = .working
//                print(json.iconsets)
//            }
//            catch {
//                print(error)
//                currentError = .incorrectRequest
//            }
//        }
//        catch {
//            print(error)
//            currentError = .urlError
//        }
//    }
//}

struct CategoryPage: View {
    var category: CategoryElement
    //@StateObject var tempViewMod = iconSet()
    @StateObject var tempViewMod = ViewModel(viewModelType: .CategoryPage)
    var body: some View {
        VStack {
            switch tempViewMod.currentError {
            case .working:
                if (tempViewMod.iconSets.isEmpty) {
                    ProgressView()
                } else {
                    List {
                        ForEach(tempViewMod.iconSets) { iconSet in
                            NavigationLink {
                                IconSetPage(iconSet: iconSet)
                            } label: {
                                HStack {
                                    Image(systemName: iconSet.isPremium ? "dollarsign.circle.fill" : "arrow.down.circle")
                                    VStack(alignment: .leading) {
                                        Text(iconSet.name)
                                        Text(iconSet.isPremium ? "(Premium)" : "(Free Download)")
                                            .font(.footnote)
                                            //.foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .italic()
                                    
                                    }
                                }
                                //Label("\(iconSet.name) \(iconSet.isPremium ? "(Premium)" : "(Free Download)")", systemImage: "circle")
                            }
                        }
                        if (tempViewMod.iconList.count < tempViewMod.totalCount) {
                            Button() {
                                
                                Task.init() {
                                    await tempViewMod.fetchAndAdd(urlString: "https://api.iconfinder.com/v4/categories/\(category.identifier)/iconsets?count=10&after=\(tempViewMod.iconSets.last!.iconsetID)")
                                }
                            } label: {
                                Text("Load more")
                            }
                        }
                    }
                }
            default:
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
                        await tempViewMod.fetch(urlString: "https://api.iconfinder.com/v4/categories/\(category.identifier)/iconsets?count=10",fetchType: .regular)
                    }
                }
            }
        }
        .navigationTitle(category.name)
        .onAppear() {
//            print("categorypage on appear")
            if (tempViewMod.iconSets.isEmpty) {
                Task.init() {
                    await tempViewMod.fetch(urlString: "https://api.iconfinder.com/v4/categories/\(category.identifier)/iconsets?count=10",fetchType: .regular)
                }
            }
        }
    }
}

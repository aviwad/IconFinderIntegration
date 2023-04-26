//
//  IconSetPage.swift
//  IconFinderIntegration
//
//  Created by Avi Wadhwa on 25/04/23.
//

import SwiftUI

//@MainActor class iconList: ObservableObject {
//    @Published var iconList: [Icon] = []
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
//                let json = try JSONDecoder().decode(IconParent.self, from: data)
//                iconList = json.icons
//                currentError = .working
//                print(json.icons)
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

struct IconSetPage: View {
    var iconSet: Iconset
//    @StateObject var iconlist = iconList()
    @StateObject var iconlist = ViewModel(viewModelType: .IconSetPage)
    let columns = [
            GridItem(.adaptive(minimum: 2, maximum: 2))
        ]
    var body: some View {
        VStack {
            switch iconlist.currentError {
            case .working:
                if (iconlist.iconList.isEmpty) {
                    ProgressView()
                } else {
                    List {
                        ForEach(iconlist.iconList) { icon in
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
                        if (iconlist.iconList.count < iconlist.totalCount) {
                            Button() {
                                Task {
                                    await iconlist.fetchAndAdd(urlString: "https://api.iconfinder.com/v4/iconsets/\(iconSet.iconsetID)/icons?count=10&offset=\(iconlist.iconList.count)")
                                }
                            } label: {
                                Text("Load more")
                            }
                        }
                    }
//                    ScrollView {
//
//                        LazyVGrid(columns: columns) {
//                            ForEach(iconlist.iconList) { icon in
//                                AsyncImage(url: URL(string: icon.rasterSizes![3].formats.last!.previewURL))
//                                if (icon.isPremium) {
//                                    Image(systemName: "arrow.down.circle.fill")
//                                }
//                            }
//                        }
//                    }
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
                        await iconlist.fetch(urlString: "https://api.iconfinder.com/v4/iconsets/\(iconSet.iconsetID)/icons?count=10",fetchType: .regular)
                    }
                }
            }
        }
        .navigationTitle(iconSet.name)
        .onAppear() {
//            print("categorypage on appear")
            Task.init() {
                await iconlist.fetch(urlString: "https://api.iconfinder.com/v4/iconsets/\(iconSet.iconsetID)/icons?count=10",fetchType: .regular)
            }
        }
//        Text("https://api.iconfinder.com/v4/iconsets/\(iconSet.iconsetID)/icons?count=10")
//            .navigationTitle(iconSet.name)
    }
}

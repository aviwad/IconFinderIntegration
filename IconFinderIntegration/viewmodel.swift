//
//  viewmodel.swift
//  IconFinderIntegration
//
//  Created by Avi Wadhwa on 25/04/23.
//

import Foundation
@MainActor class ViewModel: ObservableObject {
    var viewModelType: viewModelType
    @Published var totalCount: Int = 0
    @Published var categories: [CategoryElement] = []
    @Published var iconSets: [Iconset] = []
    @Published var iconList: [Icon] = []
    @Published var cancelled = false;
    @Published var currentError: errorType = .working
    var searchTimer: Timer?
    
    init(viewModelType: viewModelType) {
        self.viewModelType = viewModelType
        
    }
    func fetch(urlString: String, fetchType: fetchType) async {
        guard let url = URL(string: urlString) else {
            currentError = .urlError
            return
        }
        var request = URLRequest(url: url)
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer X0vjEUN6KRlxbp2DoUkyHeM0VOmxY91rA6BbU5j3Xu6wDodwS0McmilLPBWDUcJ1"
        ]
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            do {
                if (viewModelType == .CategoryPage) {
//                    print(data.debugDescription)
                    let json = try JSONDecoder().decode(IconSetParent.self, from: data)
                    if (fetchType == .regular) {
                        iconSets = json.iconsets
                    } else if (fetchType == .append) {
                        iconSets.append(contentsOf: json.iconsets)
                    }
                    totalCount = json.totalCount
                    currentError = .working
//                    print(json.iconsets)
                } else if (viewModelType == .ContentView) {
                    let json = try JSONDecoder().decode(Category.self, from: data)
                    if (fetchType == .regular) {
                        categories = json.categories
                    }else if (fetchType == .append) {
                        categories.append(contentsOf: json.categories)
                    }
                    totalCount = json.totalCount
                    currentError = .working
//                    print(json.categories)
                } else {
//                    print(data.debugDescription)
                    let json = try JSONDecoder().decode(IconParent.self, from: data)
                    if (fetchType == .regular) {
                        iconList = json.icons
                    }else if (fetchType == .append) {
                        iconList.append(contentsOf: json.icons)
                    } else {
                        if (!cancelled) {
                            iconList = json.icons
                        }
                    }
                    totalCount = json.totalCount
                    currentError = .working
//                    print(json.icons)
                }
            }
            catch {
//                print(error)
                currentError = .incorrectRequest
            }
        }
        catch {
//            print(error)
            currentError = .urlError
        }
    }
    
    func fetchAndAdd(urlString: String) async {
        guard let url = URL(string: urlString) else {
            currentError = .urlError
            return
        }
        var request = URLRequest(url: url)
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer X0vjEUN6KRlxbp2DoUkyHeM0VOmxY91rA6BbU5j3Xu6wDodwS0McmilLPBWDUcJ1"
        ]
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            do {
                if (viewModelType == .CategoryPage) {
//                    print(data.debugDescription)
                    let json = try JSONDecoder().decode(IconSetParent.self, from: data)
                    iconSets.append(contentsOf: json.iconsets)
                    currentError = .working
//                    print(json.iconsets)
                } else if (viewModelType == .ContentView) {
                    let json = try JSONDecoder().decode(Category.self, from: data)
                    categories.append(contentsOf: json.categories)
                    currentError = .working
//                    print(json.categories)
                } else {
//                    print(data.debugDescription)
                    let json = try JSONDecoder().decode(IconParent.self, from: data)
                    iconList.append(contentsOf: json.icons)
                    currentError = .working
//                    print(json.icons)
                }
            }
            catch {
//                print(error)
                currentError = .incorrectRequest
            }
        }
        catch {
//            print(error)
            currentError = .urlError
        }
    }
}

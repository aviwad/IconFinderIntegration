//
//  StructsForJSON.swift
//  SpotPlayerFriendActivity
//
//  Created by Avi Wadhwa on 2022-04-16.
//

import Foundation

enum fetchType {
    case search
    case regular
    case append
}

enum viewModelType {
    case ContentView
    case CategoryPage
    case IconSetPage
}

// Enum of errors
enum errorType {
    case urlError
    case working
    case incorrectRequest
}
// Category Parent
struct Category: Codable {
    let totalCount: Int
    let categories: [CategoryElement]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case categories
    }
}

// Category (CategoryElement)
struct CategoryElement: Codable, Identifiable {
    let name, identifier: String
    var id: String { identifier }
}

// CategoryError: unused
struct CategoryError: Codable {
    let code, message: String
}

// icon set
// Iconset parent: only used on initial get
struct IconSetParent: Codable {
    let totalCount: Int
    let iconsets: [Iconset]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case iconsets
    }
}

// icon set element
struct Iconset: Identifiable, Codable {
    let iconsetID: Int
    let identifier, name: String
    let iconsCount: Int
    let isPremium: Bool
    let publishedAt: String
    let type: TypeEnum
    let prices: [Price]?
    let styles, categories: [CategoryElement]
    let areAllIconsGlyph: Bool
    let author: Author
    let license: License?
    var id: String {identifier}

    enum CodingKeys: String, CodingKey {
        case iconsetID = "iconset_id"
        case identifier, name
        case iconsCount = "icons_count"
        case isPremium = "is_premium"
        case publishedAt = "published_at"
        case type, prices, styles, categories
        case areAllIconsGlyph = "are_all_icons_glyph"
        case author, license
    }
}

// author: can be user or author (hence containing optionals)
struct Author: Codable {
    let userID: Int?
    let username: String?
    let name: String
    let company: String?
    let isDesigner: Bool?
    let iconsetsCount: Int
    let authorID: Int?
    let websiteURL: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case username, name, company
        case isDesigner = "is_designer"
        case iconsetsCount = "iconsets_count"
        case authorID = "author_id"
        case websiteURL = "website_url"
    }
}



// license
struct License: Codable {
    let licenseID: Int
    let name: String
    let url: String?
    let scope: Scope

    enum CodingKeys: String, CodingKey {
        case licenseID = "license_id"
        case name, url, scope
    }
}

//enum Name: String, Codable {
//    case basicLicense = "Basic license"
//    case creativeCommonsAttribution30Unported = "Creative Commons (Attribution 3.0 Unported)"
//    case creativeCommonsUnported30 = "Creative Commons (Unported 3.0)"
//    case creativeCommonsAttribution25Generic = "Creative Commons (Attribution 2.5 Generic)"
//}

enum Scope: String, Codable {
    case attribution = "attribution"
    case basic = "basic"
    case free = "free"
}

// price
struct Price: Codable {
    let license: License
    let currency: String
    let price: Int
}

enum TypeEnum: String, Codable {
    case vector = "vector"
    case raster = "raster"
}


// icons

// MARK: - IconParent
struct IconParent: Codable {
    let totalCount: Int
    let icons: [Icon]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case icons
    }
}

// MARK: - Icon
struct Icon: Identifiable,Codable {
    let iconID: Int
    let tags: [String]
    let publishedAt: String
    let isPremium: Bool
    let type: String
    let containers: [Container]
    let rasterSizes: [RasterSize]?
    let vectorSizes: [VectorSize]?
    let styles, categories: [CategoryElement]
    let isIconGlyph: Bool
    var id: Int {iconID}

    enum CodingKeys: String, CodingKey {
        case iconID = "icon_id"
        case tags
        case publishedAt = "published_at"
        case isPremium = "is_premium"
        case type, containers
        case rasterSizes = "raster_sizes"
        case vectorSizes = "vector_sizes"
        case styles, categories
        case isIconGlyph = "is_icon_glyph"
    }
}


enum Identifier: String, Codable {
    case mixed = "mixed"
    case solid = "solid"
}
//
//enum Name: String, Codable {
//    case mixed = "Mixed"
//    case solid = "Solid"
//}

// MARK: - Container
struct Container: Codable {
    let format: String
    let downloadURL: String

    enum CodingKeys: String, CodingKey {
        case format
        case downloadURL = "download_url"
    }
}

// MARK: - RasterSize
struct RasterSize: Codable {
    let formats: [FormatElement]
    let size, sizeWidth, sizeHeight: Int

    enum CodingKeys: String, CodingKey {
        case formats, size
        case sizeWidth = "size_width"
        case sizeHeight = "size_height"
    }
}

// MARK: - FormatElement
struct FormatElement: Codable {
    let format: String
    let previewURL: String
    let downloadURL: String

    enum CodingKeys: String, CodingKey {
        case format
        case previewURL = "preview_url"
        case downloadURL = "download_url"
    }
}

//enum Tag: String, Codable {
//    case iconfinder = "iconfinder"
//    case iconfinderPro = "iconfinder pro"
//    case logo = "logo"
//    case center = "center"
//    case lines = "lines"
//}

// MARK: - VectorSize
struct VectorSize: Codable {
    let formats: [Container]
    let targetSizes: [[Int]]
    let size, sizeWidth, sizeHeight: Int

    enum CodingKeys: String, CodingKey {
        case formats
        case targetSizes = "target_sizes"
        case size
        case sizeWidth = "size_width"
        case sizeHeight = "size_height"
    }
}

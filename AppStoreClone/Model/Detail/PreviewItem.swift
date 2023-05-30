//
//  PreviewItem.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import Foundation

struct PreviewItem {
    var content: PreviewContent
}

extension PreviewItem {
    static let EMPTY = PreviewItem(content: .none)
}

enum PreviewContent {
    case photo(ScreenShot)
    case video(Video)
    case none
}

struct ScreenShot {
    var url: String
}

struct Video {
    
}

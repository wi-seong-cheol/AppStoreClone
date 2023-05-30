//
//  DetailSection.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import Foundation

struct DetailSection {
    let type: DetailItemType
    var items: [Any]
}

enum DetailItemType: String {
    case title
    case briefInfo
    case preview
    case explanation
    case developer
    case event
    case evauation
    case review
    case feature
    case privacy
    case info
    case support
    case relation
    case likable
}

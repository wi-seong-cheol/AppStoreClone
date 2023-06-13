//
//  SearchResultSection.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/05.
//

import Foundation

struct SearchResultSection {
    let type: SearchResultItemType
    var items: [Any]
}

extension SearchResultSection {
    static let EMPTY = SearchResultSection(type: .searchTerm, items: [])
}

enum SearchResultItemType {
    case searchTerm
    case searchAppItem
}

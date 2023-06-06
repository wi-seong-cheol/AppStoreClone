//
//  SearchSection.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/30.
//

import Foundation

struct SearchSection {
    let type: SearchItemType
    var items: [Any]
}

enum SearchItemType {
    case new
    case recommend
}

//
//  BriefInfoItem.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/27.
//

import Foundation

struct BriefInfoItem {
    var type: BriefInfoType
}

extension BriefInfoItem {
    static let EMPTY = BriefInfoItem(type: .none)
}

enum BriefInfoType {
    case grade(GradeInfo)
    case age(AgeInfo)
    case chart(ChartInfo)
    case developer(DeveloperInfo)
    case language(LanguageInfo)
    case none
}
 
struct GradeInfo {
    var total: Double
    var score: Double
}

struct AgeInfo {
    var age: String
}

struct ChartInfo {
    var rank: Int
    var type: String
}

struct DeveloperInfo {
    var id: String
}

struct LanguageInfo {
    var language: String
    var total: Int
}

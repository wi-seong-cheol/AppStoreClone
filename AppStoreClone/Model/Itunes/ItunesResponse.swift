//
//  ItunesResponse.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation

struct ItunesResponse: Codable {
    let resultCount: Int?
    let results: [Result]?
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try container.decodeIfPresent(Int.self, forKey: .resultCount)
        
        var resultArray = try container.nestedUnkeyedContainer(forKey: .results)
        var resultData: [Result] = []
        while (!resultArray.isAtEnd) {
            let result = try resultArray.decode(Result.self)
            resultData.append(result)
        }
        results = resultData
    }
}

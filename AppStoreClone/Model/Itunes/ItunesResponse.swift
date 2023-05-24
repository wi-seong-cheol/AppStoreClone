//
//  ItunesResponse.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation

struct ItunesResponse: Codable {
    let resultCount: Int?
    let tracks: [Track]?
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case tracks = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try container.decodeIfPresent(Int.self, forKey: .resultCount)
        
        var trackArray = try container.nestedUnkeyedContainer(forKey: .tracks)
        var trackData: [Track] = []
        while (!trackArray.isAtEnd) {
            let track = try trackArray.decode(Track.self)
            trackData.append(track)
        }
        tracks = trackData
    }
}

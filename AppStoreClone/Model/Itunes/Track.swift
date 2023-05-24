//
//  Track.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation

struct Track: Codable {
    let title: String?
    let artistName: String?
    let thumbnailPath: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case artistName
        case thumbnailPath = "artworkUrl30"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        artistName = try container.decodeIfPresent(String.self, forKey: .artistName)
        thumbnailPath = try container.decodeIfPresent(String.self, forKey: .thumbnailPath)
    }
}

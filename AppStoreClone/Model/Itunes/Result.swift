//
//  Result.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation

struct Result: Codable {
    let artistViewURL: String?
    let artworkUrl60, artworkUrl100, artworkUrl512: String?
    let features: [String]?
    let isGameCenterEnabled: Bool?
    let supportedDevices, advisories: [String]?
    let screenshotUrls: [String]?
    let kind: String?
    let averageUserRating: Double?
    let contentAdvisoryRating, trackCensoredName: String?
    let trackViewURL: String?
    let releaseNotes: String?
    let languageCodesISO2A: [String]?
    let fileSizeBytes, minimumOSVersion, description: String?
    let genreIDS: [String]?
    let primaryGenreName: String?
    let primaryGenreID: Int?
    let bundleID, sellerName: String?
    let isVppDeviceBasedLicensingEnabled: Bool?
    let trackID: Int?
    let trackName, formattedPrice: String?
    let averageUserRatingForCurrentVersion: Double?
    let userRatingCountForCurrentVersion: Int?
    let trackContentRating: String?
    let releaseDate, currentVersionReleaseDate: Date?
    let currency, version, wrapperType: String?
    let price: Double?
    let artistID: Int?
    let artistName: String?
    let genres: [String]?
    let userRatingCount: Int?
    let sellerURL: String?

    enum CodingKeys: String, CodingKey {
        case artistViewURL = "artistViewUrl"
        case artworkUrl60, artworkUrl100, artworkUrl512
        case features, isGameCenterEnabled, supportedDevices, advisories, screenshotUrls, kind, averageUserRating, contentAdvisoryRating, trackCensoredName
        case trackViewURL = "trackViewUrl"
        case releaseNotes, languageCodesISO2A, fileSizeBytes
        case minimumOSVersion = "minimumOsVersion"
        case description
        case genreIDS = "genreIds"
        case primaryGenreName
        case primaryGenreID = "primaryGenreId"
        case bundleID = "bundleId"
        case sellerName, isVppDeviceBasedLicensingEnabled
        case trackID = "trackId"
        case trackName, formattedPrice, averageUserRatingForCurrentVersion, userRatingCountForCurrentVersion, trackContentRating, releaseDate, currentVersionReleaseDate
        case currency, version, wrapperType, price
        case artistID = "artistId"
        case artistName, genres, userRatingCount
        case sellerURL = "sellerUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        artistViewURL = try container.decodeIfPresent(String.self, forKey: .artistViewURL)
        artworkUrl60 = try container.decodeIfPresent(String.self, forKey: .artworkUrl60)
        artworkUrl100 = try container.decodeIfPresent(String.self, forKey: .artworkUrl100)
        artworkUrl512 = try container.decodeIfPresent(String.self, forKey: .artworkUrl512)
        features = try container.decodeIfPresent([String].self, forKey: .features)
        isGameCenterEnabled = try container.decodeIfPresent(Bool.self, forKey: .isGameCenterEnabled)
        supportedDevices = try container.decodeIfPresent([String].self, forKey: .supportedDevices)
        advisories = try container.decodeIfPresent([String].self, forKey: .advisories)
        screenshotUrls = try container.decodeIfPresent([String].self, forKey: .screenshotUrls)
        kind = try container.decodeIfPresent(String.self, forKey: .kind)
        averageUserRating = try container.decodeIfPresent(Double.self, forKey: .averageUserRating)
        contentAdvisoryRating = try container.decodeIfPresent(String.self, forKey: .contentAdvisoryRating)
        trackCensoredName = try container.decodeIfPresent(String.self, forKey: .trackCensoredName)
        trackViewURL = try container.decodeIfPresent(String.self, forKey: .trackViewURL)
        releaseNotes = try container.decodeIfPresent(String.self, forKey: .releaseNotes)
        languageCodesISO2A = try container.decodeIfPresent([String].self, forKey: .languageCodesISO2A)
        fileSizeBytes = try container.decodeIfPresent(String.self, forKey: .fileSizeBytes)
        minimumOSVersion = try container.decodeIfPresent(String.self, forKey: .minimumOSVersion)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        genreIDS = try container.decodeIfPresent([String].self, forKey: .genreIDS)
        primaryGenreName = try container.decodeIfPresent(String.self, forKey: .primaryGenreName)
        primaryGenreID = try container.decodeIfPresent(Int.self, forKey: .primaryGenreID)
        bundleID = try container.decodeIfPresent(String.self, forKey: .bundleID)
        sellerName = try container.decodeIfPresent(String.self, forKey: .sellerName)
        isVppDeviceBasedLicensingEnabled = try container.decodeIfPresent(Bool.self, forKey: .isVppDeviceBasedLicensingEnabled)
        trackID = try container.decodeIfPresent(Int.self, forKey: .trackID)
        trackName = try container.decodeIfPresent(String.self, forKey: .trackName)
        formattedPrice = try container.decodeIfPresent(String.self, forKey: .formattedPrice)
        averageUserRatingForCurrentVersion = try container.decodeIfPresent(Double.self, forKey: .averageUserRatingForCurrentVersion)
        userRatingCountForCurrentVersion = try container.decodeIfPresent(Int.self, forKey: .userRatingCountForCurrentVersion)
        trackContentRating = try container.decodeIfPresent(String.self, forKey: .trackContentRating)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
        if let date = dateFormatter.date(from: releaseDateString) {
            releaseDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .releaseDate,
                  in: container,
                  debugDescription: "Date string does not match format expected by formatter.")
        }
        let currentVersionReleaseDateString = try container.decode(String.self, forKey: .currentVersionReleaseDate)
        if let date = dateFormatter.date(from: currentVersionReleaseDateString) {
            currentVersionReleaseDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .currentVersionReleaseDate,
                  in: container,
                  debugDescription: "Date string does not match format expected by formatter.")
        }
        
        currency = try container.decodeIfPresent(String.self, forKey: .currency)
        version = try container.decodeIfPresent(String.self, forKey: .version)
        wrapperType = try container.decodeIfPresent(String.self, forKey: .wrapperType)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        artistID = try container.decodeIfPresent(Int.self, forKey: .artistID)
        artistName = try container.decodeIfPresent(String.self, forKey: .artistName)
        genres = try container.decodeIfPresent([String].self, forKey: .genres)
        userRatingCount = try container.decodeIfPresent(Int.self, forKey: .userRatingCount)
        sellerURL = try container.decodeIfPresent(String.self, forKey: .sellerURL)
    }
}

//
//  APIRequestError.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation

enum APIRequestError: Error {
    case invalidData
    case invalidURL
    case isNotConnect
}

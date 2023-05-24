//
//  APIURLService.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation

enum Path: String {
    // MARK: - Example
    case sample = "/search?"
}

class URLService {
    
    @Inject var readPList: ReadPList
    
    func serviceUrl(_ path: Path) -> String {
        guard let url = readPList.getBaseURL() else {
            return ""
        }
        return url + path.rawValue
    }
}

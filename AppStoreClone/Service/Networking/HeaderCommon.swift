//
//  HeaderCommon.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation

final class HeaderCommon {

    func headerSetting() -> [String: String] {
        let headers: [String: String] = [
            "Content-Type": "application/json"
        ]

        return headers
    }
}

//
//  ReadPList.swift
//  BoilerPlate
//
//  Created by wi_seong on 2023/05/18.
//

import Foundation

final class ReadPList {
    
    func getBaseURL() -> String? {
        guard let config = getPlist(withName: "Info") else {
            return nil
        }
        guard let API_URL = config["API_URL"] as? Dictionary<String, String> else {
            return nil
        }
        guard let url = API_URL["baseURL"] else {
            return nil
        }
        return url
    }
    
    private func getPlist(withName name: String) -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: name , ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path) else {
            return nil
        }
        return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String: Any]
    }
}

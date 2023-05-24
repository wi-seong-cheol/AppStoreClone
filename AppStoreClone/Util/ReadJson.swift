//
//  ReadJson.swift
//  BoilerPlate
//
//  Created by wi_seong on 2023/05/19.
//

import Foundation

final class ReadJson {
    
    internal func loadJson(fileName: String) -> Data? {
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
}

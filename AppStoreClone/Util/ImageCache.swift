//
//  ImageCache.swift
//  BoilerPlate
//
//  Created by wi_seong on 2023/05/18.
//

import Foundation
import UIKit

final class ImageCache {
    
    lazy var cache: NSCache<AnyObject, UIImage> = NSCache()
    
    func saveImageToCache(image: UIImage?, url: String) {
        if let image = image {
            cache.setObject(image, forKey: url as AnyObject)
        }
    }
    
    func imageFromCacheWithUrl(url: String) -> UIImage? {
        return cache.object(forKey: url as AnyObject)
    }
}

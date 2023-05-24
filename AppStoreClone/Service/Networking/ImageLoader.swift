//
//  ImageLoader.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class ImageLoader {
    
    @Inject static var cache: ImageCache
    
    static func loadImage(from url: String) -> Observable<UIImage?> {
        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                guard let data = data,
                      let image = UIImage(data: data) else {
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return
                }
                
                emitter.onNext(image)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    static func cache_loadImage(url: String) -> Observable<UIImage?> {
        return Observable.create({ observer in
            if let image = ImageLoader.cache.imageFromCacheWithUrl(url: url) {
                observer.onNext(image)
                observer.onCompleted()
            } else {
                let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                    
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    guard let data = data,
                          let image = UIImage(data: data) else {
                        observer.onNext(nil)
                        observer.onCompleted()
                        return
                    }
                    ImageLoader.cache.saveImageToCache(image: image, url: url)
                    observer.onNext(image)
                    observer.onCompleted()
                }
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
            return Disposables.create()
        }).subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .catchAndReturn(nil)
    }
}

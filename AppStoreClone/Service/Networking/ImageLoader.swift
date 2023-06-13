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
    
    static func loadImage(from urlString: String) -> Observable<UIImage?> {
        return Observable.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onCompleted()
                return Disposables.create()
            }
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
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
                
                observer.onNext(image)
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    static func cache_loadImage(from urlString: String) -> Observable<UIImage?> {
        return Observable.create({ observer in
            if let image = ImageLoader.cache.imageFromCacheWithUrl(url: urlString) {
                observer.onNext(image)
                observer.onCompleted()
            } else {
                guard let url = URL(string: urlString) else {
                    observer.onCompleted()
                    return Disposables.create()
                }
                let task = URLSession.shared.dataTask(with: url) { data, _, error in
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
                    
                    observer.onNext(image)
                    observer.onCompleted()
                }
                task.resume()
                return Disposables.create {
                    task.cancel()
                }
            }
            return Disposables.create()
        })
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .catchAndReturn(nil)
    }
}

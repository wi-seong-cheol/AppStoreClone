//
//  APIRequestService.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation
import UIKit
import SystemConfiguration

import RxSwift

protocol APIRequestServiceProtocol {
    
    var isInternetAvailable: Bool { get }
    
    func getable<T:Codable>(url: String,
                            query: [String:Any]?,
                            interceptor: Interceptor?) -> Observable<T>
    
    func postable<T:Codable>(url: String,
                             body: [String:Any]?,
                             interceptor: Interceptor?) -> Observable<T>
    
    func deletable<T:Codable>(url: String,
                              body: [String:Any]?,
                              interceptor: Interceptor?) -> Observable<T>
    
    func putable<T:Codable>(url: String,
                            body: [String:Any]?,
                            interceptor: Interceptor?) -> Observable<T>
    
    func patchable<T:Codable>(url: String,
                              body: [String:Any]?,
                              interceptor: Interceptor?) -> Observable<T>
    
    func networkConnectAlert()
}

final class APIRequestService: APIRequestServiceProtocol {
    
    @Inject var header: HeaderCommon
    @Inject var globalAlert: GlobalAlert
    
    //네트워크 연결상태 확인
    var isInternetAvailable: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    func getable<T:Codable>(url: String,
                            query: [String:Any]?,
                            interceptor: Interceptor?) -> Observable<T> {
        
        if !isInternetAvailable {
            networkConnectAlert()
            return .error(APIRequestError.isNotConnect)
        }
        
        return Observable.create { [weak self] observer in
            var urlComponents = URLComponents(string: url)
            if let query = query {
                let queryItems = query.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
                urlComponents?.queryItems = queryItems
            }
            guard let url = urlComponents?.url else {
                observer.onError(APIRequestError.invalidURL)
                return Disposables.create()
            }
            var request = URLRequest(url: url,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = self?.header.headerSetting()
            print(request)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(APIRequestError.invalidData)
                    return
                }
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(object)
                    observer.onCompleted()
                } catch {
                    print(error)
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func postable<T:Codable>(url: String,
                             body: [String:Any]?,
                             interceptor: Interceptor?) -> Observable<T> {
        
        if !isInternetAvailable {
            networkConnectAlert()
            return .error(APIRequestError.isNotConnect)
        }
        
        return Observable.create { [weak self] observer in
            guard let url = URL(string: url) else {
                observer.onError(APIRequestError.invalidURL)
                return Disposables.create()
            }
            var request = URLRequest(url: url,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = self?.header.headerSetting()
            
            do {
                let bodyData = try JSONSerialization.data(withJSONObject: body ?? [:], options: [])
                request.httpBody = bodyData
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(APIRequestError.invalidData)
                    return
                }
                
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(object)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func deletable<T:Codable>(url: String,
                              body: [String:Any]?,
                              interceptor: Interceptor?) -> Observable<T> {
        
        if !isInternetAvailable {
            networkConnectAlert()
            return .error(APIRequestError.isNotConnect)
        }
        
        return Observable.create { [weak self] observer in
            guard let url = URL(string: url) else {
                observer.onError(APIRequestError.invalidURL)
                return Disposables.create()
            }
            var request = URLRequest(url: url,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            request.httpMethod = "DELETE"
            request.allHTTPHeaderFields = self?.header.headerSetting()
            
            do {
                let bodyData = try JSONSerialization.data(withJSONObject: body ?? [:], options: [])
                request.httpBody = bodyData
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(APIRequestError.invalidData)
                    return
                }
                
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(object)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func putable<T:Codable>(url: String,
                            body: [String:Any]?,
                            interceptor: Interceptor?) -> Observable<T> {
        
        if !isInternetAvailable {
            networkConnectAlert()
            return .error(APIRequestError.isNotConnect)
        }
        
        return Observable.create { [weak self] observer in
            guard let url = URL(string: url) else {
                observer.onError(APIRequestError.invalidURL)
                return Disposables.create()
            }
            var request = URLRequest(url: url,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = self?.header.headerSetting()
            
            do {
                let bodyData = try JSONSerialization.data(withJSONObject: body ?? [:], options: [])
                request.httpBody = bodyData
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(APIRequestError.invalidData)
                    return
                }
                
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(object)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func patchable<T:Codable>(url: String,
                              body: [String:Any]?,
                              interceptor: Interceptor?) -> Observable<T> {
        
        if !isInternetAvailable {
            networkConnectAlert()
            return .error(APIRequestError.isNotConnect)
        }
        
        return Observable.create { [weak self] observer in
            guard let url = URL(string: url) else {
                observer.onError(APIRequestError.invalidURL)
                return Disposables.create()
            }
            var request = URLRequest(url: url,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            request.httpMethod = "PATCH"
            request.allHTTPHeaderFields = self?.header.headerSetting()
            
            do {
                let bodyData = try JSONSerialization.data(withJSONObject: body ?? [:], options: [])
                request.httpBody = bodyData
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(APIRequestError.invalidData)
                    return
                }
                
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(object)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func networkConnectAlert() {
        guard let vc = UIApplication.topViewController() else {
            fatalError("Is Not Found TopViewController")
        }
        
        globalAlert.commonAlert(title: "네트워크 연결 확인\n",
                                content: "네트워크 연결이 되어있지 않습니다.\n연결상태를 확인해주세요.",
                                vc: vc)
    }
}

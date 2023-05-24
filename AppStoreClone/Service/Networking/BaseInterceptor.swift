//
//  BaseInterceptor.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation

protocol Interceptor {
    func adapt(_ request: URLRequest) -> URLRequest
}

final class BaseInterceptor: Interceptor {
    private let retryLimit = 1
    private var retryCount = 0
    
    func adapt(_ request: URLRequest) -> URLRequest {
        var modifiedRequest = request
        modifiedRequest.addValue("Bearer YourAccessToken", forHTTPHeaderField: "Authorization")
        return modifiedRequest
    }
}

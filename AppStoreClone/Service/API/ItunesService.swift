//
//  ItunesService.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation

import RxSwift

protocol ItunesFetchable {
    func newDiscovery() -> Observable<ItunesResponse>
    func recommendApp() -> Observable<ItunesResponse>
    func search(_ term: String) -> Observable<ItunesResponse>
}

class ItunesService: ItunesFetchable {
    
    @Inject private var urlService: URLService
    @Inject private var apiRequestService: APIRequestService
    
    func newDiscovery() -> Observable<ItunesResponse> {
        let url: String = urlService.serviceUrl(.sample)
        let query: [String: Any] = [
            "country": "kr",
            "entity": "software",
            "term": "새로운 발견",
            "limit": 4,
            "sort": "recent"
        ]
        let interceptor: Interceptor = BaseInterceptor()
        
        return apiRequestService.getable(url: url, query: query, interceptor: interceptor)
    }
    
    func recommendApp() -> Observable<ItunesResponse> {
        let url: String = urlService.serviceUrl(.sample)
        let query: [String: Any] = [
            "country": "kr",
            "entity": "software",
            "term": "인기 어플",
            "limit": 16,
            "sort": "recent"
        ]
        let interceptor: Interceptor = BaseInterceptor()
        
        return apiRequestService.getable(url: url, query: query, interceptor: interceptor)
    }
    
    func search(_ term: String) -> Observable<ItunesResponse> {
        let url: String = urlService.serviceUrl(.sample)
        let query: [String: Any] = [
            "country": "kr",
            "entity": "software",
            "term": term,
            "limit": 14,
        ]
        let interceptor: Interceptor = BaseInterceptor()
        
        return apiRequestService.getable(url: url, query: query, interceptor: interceptor)
    }
}

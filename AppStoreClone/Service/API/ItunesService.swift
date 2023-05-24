//
//  ItunesService.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation

import RxSwift

protocol ItunesFetchable {
    func search(_ term: String) -> Observable<ItunesResponse>
}

class ItunesService: ItunesFetchable {
    
    @Inject private var urlService: URLService
    @Inject private var apiRequestService: APIRequestService
    
    func search(_ term: String) -> Observable<ItunesResponse> {
        let url: String = urlService.serviceUrl(.sample)
        let query: [String: Any] = [
            "media": "music",
            "entity": "song",
            "term": term
        ]
        let interceptor: Interceptor = BaseInterceptor()
        
        return apiRequestService.getable(url: url, query: query, interceptor: interceptor) ?? Observable.empty()
    }
}

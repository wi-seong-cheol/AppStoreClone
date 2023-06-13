//
//  SearchViewModel.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation

import RxCocoa
import RxSwift

typealias SearchViewModelInput = (fetch: AnyObserver<Void>,
                                  searchText: AnyObserver<String>,
                                  error: AnyObserver<Error>,
                                  selectedItem: AnyObserver<Result>)
typealias SearchViewModelOutput = (datasource: Driver<[SearchSection]>,
                                   appData: Driver<[Result]>,
                                   errorMessage: Observable<String>,
                                   pushDetailView: Observable<Result>)

protocol SearchViewModelType {
    var input: SearchViewModelInput { get }
    var output: SearchViewModelOutput { get }
}

final class SearchViewModel: SearchViewModelType {
    
    @Inject var service: ItunesService
    
    private let disposeBag = DisposeBag()
    
    // MARK: INPUT
    private let fetch = PublishSubject<Void>()
    private let searchText = PublishSubject<String>()
    private let error = PublishSubject<Error>()
    private let selectedItem = PublishSubject<Result>()
    
    var input: SearchViewModelInput {
        return (fetch.asObserver(),
                searchText.asObserver(),
                error.asObserver(),
                selectedItem.asObserver())
    }
    
    // MARK: OUTPUT
    private let datasource = BehaviorRelay<[SearchSection]>(value: [])
    private let appData = BehaviorRelay<[Result]>(value: [])
    private let errorMessage = PublishSubject<String>()
    private let pushDetailView = PublishSubject<Result>()
    
    var output: SearchViewModelOutput {
        return (datasource: datasource.asDriver(onErrorJustReturn: []),
                appData: appData.asDriver(onErrorJustReturn: []),
                errorMessage: errorMessage.asObserver(),
                pushDetailView: pushDetailView.asObserver())
    }
    
    init() {
        let newDiscovery = service.newDiscovery()
        let recommendApp = service.recommendApp()
        let zipped = Observable.zip(newDiscovery, recommendApp)
        
        fetch
            .flatMap { zipped.materialize() }
            .subscribe(onNext: { [weak self] materializedEvent in
                switch materializedEvent {
                case let .next((newDiscoveryResponse, recommendAppResponse)):
                    guard let newDiscoveryResults = newDiscoveryResponse.results,
                          let recommendAppResults = recommendAppResponse.results else {
                        break
                    }
                    let newItem = newDiscoveryResults.map { NewItem(title: $0.trackName) }
                    let recommendItem = recommendAppResults.map {
                        RecommendItem(appIcon: $0.artworkUrl512,
                                      title: $0.trackName,
                                      desc: $0.description)
                    }
                    self?.appData.accept(recommendAppResults)
                    self?.datasource.accept([
                        SearchSection(type: .new, items: newItem),
                        SearchSection(type: .recommend, items: recommendItem)
                    ])
                case let .error(error):
                    self?.error.onNext(error)
                case .completed: break
                }
            })
            .disposed(by: disposeBag)
        
        selectedItem
            .bind(to: pushDetailView)
            .disposed(by: disposeBag)
        
        error
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                guard let error = error as? APIRequestError else {
                    self.errorMessage.onNext(error.localizedDescription)
                    return
                }
                
                switch error {
                case .invalidData:
                    self.errorMessage.onNext("잘못된 요청입니다. 다시 시도해 주세요.")
                case .invalidURL:
                    self.errorMessage.onNext("잘못된 URL입니다. 다시 시도해 주세요.")
                case .isNotConnect:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

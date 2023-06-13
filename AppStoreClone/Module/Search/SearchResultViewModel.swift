//
//  RelatedSearchViewModel.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/05.
//

import Foundation

import RxCocoa
import RxSwift

typealias SearchResultViewModelInput = (error: AnyObserver<Error>,
                                        searchText: AnyObserver<String>,
                                        searchClick: AnyObserver<Int>,
                                        search: AnyObserver<String>)
typealias SearchResultViewModelOutput = (datasource: Driver<SearchResultSection>,
                                         updateSearchText: Observable<String>,
                                         errorMessage: Observable<String>)

protocol SearchResultViewModelType {
    var input: SearchResultViewModelInput { get }
    var output: SearchResultViewModelOutput { get }
}

final class SearchResultViewModel: SearchResultViewModelType {
    
    @Inject var service: ItunesService
    
    private let disposeBag = DisposeBag()
    
    // MARK: INPUT
    private let error = PublishSubject<Error>()
    private let searchText = PublishSubject<String>()
    private let searchClick = PublishSubject<Int>()
    private let search = PublishSubject<String>()
    
    var input: SearchResultViewModelInput {
        return (error.asObserver(),
                searchText.asObserver(),
                searchClick.asObserver(),
                search.asObserver())
    }
    
    // MARK: OUTPUT
    private let datasource = BehaviorRelay<SearchResultSection>(value: SearchResultSection.EMPTY)
    private let updateSearchText = PublishSubject<String>()
    private let errorMessage = PublishSubject<String>()
    
    var output: SearchResultViewModelOutput {
        return (datasource: datasource.asDriver(onErrorJustReturn: SearchResultSection.EMPTY),
                updateSearchText: updateSearchText.asObserver(),
                errorMessage: errorMessage.asObserver())
    }
    
    init() {
        
        searchText
            .filter{ $0 != "" }
            .flatMapLatest { [unowned self] text in
                self.service
                    .search(text)
                    .materialize()
            }
            .subscribe(onNext: { [weak self] materializedEvent in
                guard let self = self else { return }
                switch materializedEvent {
                case let .next(response):
                    guard let results = response.results else {
                        break
                    }
                    let items = results.map {
                        SearchTermItem(searchTerm: $0.trackName)
                    }
                    self.datasource.accept(
                        SearchResultSection(type: .searchTerm,
                                            items: items)
                    )
                case let .error(error):
                    self.error.onNext(error)
                case .completed: break
                }
            })
            .disposed(by: disposeBag)
        
        searchText
            .filter{ $0 == "" }
            .subscribe(onNext: { [weak self] _ in
                self?.datasource.accept(SearchResultSection.EMPTY)
            })
            .disposed(by: disposeBag)
        
        searchClick
            .subscribe(onNext: { [weak self] index in
                guard
                    let item = self?.datasource.value.items[index] as? SearchTermItem,
                    let searchTerm = item.searchTerm else {
                    return
                }
                self?.search.onNext(searchTerm)
                self?.updateSearchText.onNext(searchTerm)
            })
            .disposed(by: disposeBag)
        
        search
            .flatMapLatest { [unowned self] searchTerm in
                self.service
                    .search(searchTerm)
                    .materialize()
            }
            .subscribe(onNext: { [weak self] materializedEvent in
                guard let self = self else { return }
                switch materializedEvent {
                case let .next(response):
                    guard let results = response.results else {
                        break
                    }
                    let items = results.map {
                        SearchAppItem(icon: $0.artworkUrl512,
                                      title: $0.trackName,
                                      desc: $0.description,
                                      preview: $0.screenshotUrls)
                    }
                    self.datasource.accept(
                        SearchResultSection(type: .searchAppItem,
                                            items: items)
                    )
                case let .error(error):
                    self.error.onNext(error)
                case .completed: break
                }
            })
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

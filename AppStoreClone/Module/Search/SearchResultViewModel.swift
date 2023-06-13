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
                                        activated: AnyObserver<Bool>,
                                        searchText: AnyObserver<String>,
                                        selectIndex: AnyObserver<Int>,
                                        search: AnyObserver<String>,
                                        appendTermItem: AnyObserver<ItunesResponse>,
                                        appendAppItem: AnyObserver<ItunesResponse>,
                                        pickPreview: AnyObserver<[String]?>)
typealias SearchResultViewModelOutput = (appData: Driver<[Result]>,
                                         loading: Observable<Bool>,
                                         datasource: Driver<SearchResultSection>,
                                         updateSearchText: Observable<String>,
                                         errorMessage: Observable<String>,
                                         preview: Driver<[String]>,
                                         selectedItem: Observable<Result>)

protocol SearchResultViewModelType {
    var input: SearchResultViewModelInput { get }
    var output: SearchResultViewModelOutput { get }
}

final class SearchResultViewModel: SearchResultViewModelType {
    
    @Inject var service: ItunesService
    
    private let disposeBag = DisposeBag()
    
    // MARK: INPUT
    private let error = PublishSubject<Error>()
    private let activated = PublishSubject<Bool>()
    private let searchText = PublishSubject<String>()
    private let selectIndex = PublishSubject<Int>()
    private let search = PublishSubject<String>()
    private let appendTermItem = PublishSubject<ItunesResponse>()
    private let appendAppItem = PublishSubject<ItunesResponse>()
    private let pickPreview = PublishSubject<[String]?>()
    
    var input: SearchResultViewModelInput {
        return (error.asObserver(),
                activated.asObserver(),
                searchText.asObserver(),
                selectIndex.asObserver(),
                search.asObserver(),
                appendTermItem.asObserver(),
                appendAppItem.asObserver(),
                pickPreview.asObserver())
    }
    
    // MARK: OUTPUT
    private let appData = BehaviorRelay<[Result]>(value: [])
    private let loading = PublishSubject<Bool>()
    private let datasource = BehaviorRelay<SearchResultSection>(value: SearchResultSection.EMPTY)
    private let updateSearchText = PublishSubject<String>()
    private let errorMessage = PublishSubject<String>()
    private let preview = BehaviorRelay<[String]>(value: [])
    private let selectedItem = PublishSubject<Result>()
    
    var output: SearchResultViewModelOutput {
        return (appData: appData.asDriver(onErrorJustReturn: []),
                loading: loading.asObserver(),
                datasource: datasource.asDriver(onErrorJustReturn: SearchResultSection.EMPTY),
                updateSearchText: updateSearchText.asObserver(),
                errorMessage: errorMessage.asObserver(),
                preview: preview.asDriver(onErrorJustReturn: []),
                selectedItem: selectedItem.asObserver())
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
                switch materializedEvent {
                case let .next(response):
                    self?.appendTermItem.onNext(response)
                case let .error(error):
                    self?.error.onNext(error)
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
        
        selectIndex
            .filter { [weak self] _ in self?.datasource.value.type == .searchTerm }
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
        
        selectIndex
            .filter { [weak self] _ in self?.datasource.value.type == .searchAppItem }
            .subscribe(onNext: { [weak self] index in
                guard let item = self?.appData.value[index] else {
                    return
                }
                self?.selectedItem.onNext(item)
            })
            .disposed(by: disposeBag)
        
        search
            .do(onNext: { [weak self] _ in
                self?.activated.onNext(true)
            })
            .flatMapLatest { [unowned self] searchTerm in
                self.service
                    .search(searchTerm)
                    .materialize()
            }
            .do(onNext: { [weak self] _ in
                self?.activated.onNext(false)
            })
            .subscribe(onNext: { [weak self] materializedEvent in
                switch materializedEvent {
                case let .next(response):
                    self?.appendAppItem.onNext(response)
                case let .error(error):
                    self?.error.onNext(error)
                case .completed: break
                }
            })
            .disposed(by: disposeBag)
                
        appendTermItem
            .compactMap { $0.results }
            .subscribe(onNext: { [weak self] results in
                let items = results.map {
                    SearchTermItem(searchTerm: $0.trackName)
                }
                self?.datasource.accept(
                    SearchResultSection(type: .searchTerm,
                                        items: items)
                )
            })
            .disposed(by: disposeBag)
                
        appendAppItem
            .compactMap { $0.results }
            .subscribe(onNext: { [weak self] results in
                self?.appData.accept(results)
                let items = results.map {
                    self?.pickPreview.onNext($0.screenshotUrls)
                    return SearchAppItem(icon: $0.artworkUrl512,
                                         title: $0.trackName,
                                         desc: $0.description,
                                         starRating: $0.averageUserRatingForCurrentVersion,
                                         preview: self?.preview.value)
                }
                self?.datasource.accept(
                    SearchResultSection(type: .searchAppItem,
                                        items: items)
                )
            })
            .disposed(by: disposeBag)
        
        activated
            .subscribe(onNext: { [weak self] status in
                if status {
                    self?.datasource.accept(SearchResultSection.EMPTY)
                    self?.loading.onNext(status)
                } else {
                    self?.loading.onNext(status)
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
        
        pickPreview
            .subscribe(onNext: { [weak self] urls in
                guard let urls = urls,
                      let splitedUrl = urls.first?.components(separatedBy: ["/"]).last else {
                    self?.preview.accept([])
                    return
                }
                
                let rect = splitedUrl.components(separatedBy: ["x", "b"]).compactMap { str in Int(str) }
                guard let width = rect.first,
                      let height = rect.last else {
                    self?.preview.accept([])
                    return
                }
                
                if width < height {
                    self?.preview.accept(Array(urls[0..<min(3, urls.count)]))
                } else {
                    self?.preview.accept([urls[0]])
                }
            })
            .disposed(by: disposeBag)
    }
}

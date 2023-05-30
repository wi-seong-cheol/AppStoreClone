//
//  SearchViewModel.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import RxCocoa
import RxSwift

typealias SearchViewModelInput = (firstInput: AnyObserver<Void>,
                                  secondInput: AnyObserver<Void>)
typealias SearchViewModelOutput = (datasource: Driver<[SearchSection]>,
                                   secondOutput: Observable<Void>)

protocol SearchViewModelType {
    var input: SearchViewModelInput { get }
    var output: SearchViewModelOutput { get }
}

final class SearchViewModel: SearchViewModelType {
    
    @Inject var service: ItunesService
    
    private let disposeBag = DisposeBag()
    
    // MARK: INPUT
    private let firstInput = PublishSubject<Void>()
    private let secondInput = PublishSubject<Void>()
    
    var input: SearchViewModelInput {
        return (firstInput.asObserver(),
                secondInput.asObserver())
    }
    
    // MARK: OUTPUT
    private let datasource = BehaviorRelay<[SearchSection]>(value: [
        SearchSection(type: .new, items: [
            NewItem(title: "배달"),
            NewItem(title: "fifa"),
            NewItem(title: "씽씽"),
            NewItem(title: "아이돌 키우기"),
        ]),
        
        SearchSection(type: .suggestion, items: [
            SuggestionItem(title: "abcdlsjfnldanslfnldasn"),
            SuggestionItem(title: "abcsdafsafsafsaf"),
            SuggestionItem(title: "abc"),
            SuggestionItem(title: "abc"),
        ])
    ])
    private let secondOutput = PublishSubject<Void>()
    
    var output: SearchViewModelOutput {
        return (datasource: datasource.asDriver(onErrorJustReturn: []),
                secondOutput: secondOutput.asObservable())
    }
    
    init() {
    }
}

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
            SuggestionItem(appIcon:  "https://images.applypixels.com/images/originals/1696b13e-7eb7-4fd0-83a1-bb89d5aa5ab8.png",
                           title: "abcdlsjfnldanslfnldasn",
                           desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
            SuggestionItem(appIcon:  "https://images.applypixels.com/images/originals/1696b13e-7eb7-4fd0-83a1-bb89d5aa5ab8.png",
                           title: "abcsdafsafsafsaf",
                           desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
            SuggestionItem(appIcon:  "https://images.applypixels.com/images/originals/1696b13e-7eb7-4fd0-83a1-bb89d5aa5ab8.png",
                           title: "abc",
                           desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
            SuggestionItem(appIcon:  "https://images.applypixels.com/images/originals/1696b13e-7eb7-4fd0-83a1-bb89d5aa5ab8.png",
                           title: "abc",
                           desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
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

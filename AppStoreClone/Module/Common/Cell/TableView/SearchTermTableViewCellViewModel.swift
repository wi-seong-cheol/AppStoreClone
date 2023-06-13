//
//  SearchTermTableViewCellViewModel.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/06.
//

import RxSwift
import RxCocoa

typealias SearchTermTableViewCellViewModelInput = AnyObserver<SearchTermItem>
typealias SearchTermTableViewCellViewModelOutput = Driver<String>

protocol SearchTermTableViewCellViewModelType {
    var input: SearchTermTableViewCellViewModelInput { get }
    var output: SearchTermTableViewCellViewModelOutput { get }
}

class SearchTermTableViewCellViewModel: SearchTermTableViewCellViewModelType {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Input
    private let item = PublishSubject<SearchTermItem>()
    
    var input: SearchTermTableViewCellViewModelInput {
        return item.asObserver()
    }
    
    // MARK: OUTPUT
    private let searchTerm = BehaviorRelay<String>(value: "")
    
    var output: SearchTermTableViewCellViewModelOutput {
        return searchTerm.asDriver(onErrorJustReturn: "")
    }
    
    // MARK: Init
    init() {
        item
            .compactMap { $0.searchTerm }
            .bind(to: searchTerm)
            .disposed(by: disposeBag)
    }
}

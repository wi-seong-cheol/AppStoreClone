//
//  SearchTermTableViewCellViewModel.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/06.
//

import RxSwift

typealias SearchTermTableViewCellViewModelInput = ()
typealias SearchTermTableViewCellViewModelOutput = Observable<SearchTermItem>

protocol SearchTermTableViewCellViewModelType {
    var input: SearchTermTableViewCellViewModelInput { get }
    var output: SearchTermTableViewCellViewModelOutput { get }
}

class SearchTermTableViewCellViewModel: SearchTermTableViewCellViewModelType {

    // MARK: Input & Output
    var input: SearchTermTableViewCellViewModelInput { return }
    
    // MARK: OUTPUT
    private let item: Observable<SearchTermItem>
    
    var output: SearchTermTableViewCellViewModelOutput {
        return item.asObservable()
    }
    
    // MARK: Init
    init(item: SearchTermItem) {
        self.item = Observable.just(item)
    }
}

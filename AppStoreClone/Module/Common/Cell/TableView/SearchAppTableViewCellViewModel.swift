//
//  SearchAppTableViewCellViewModel.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/06.
//

import RxSwift

typealias SearchAppTableViewCellViewModelInput = ()
typealias SearchAppTableViewCellViewModelOutput = Observable<SearchAppItem>

protocol SearchAppTableViewCellViewModelType {
    var input: SearchAppTableViewCellViewModelInput { get }
    var output: SearchAppTableViewCellViewModelOutput { get }
}

class SearchAppTableViewCellViewModel: SearchAppTableViewCellViewModelType {

    // MARK: Input & Output
    var input: SearchAppTableViewCellViewModelInput { return }
    
    // MARK: OUTPUT
    private let item: Observable<SearchAppItem>
    
    var output: SearchAppTableViewCellViewModelOutput {
        return item.asObservable()
    }
    
    // MARK: Init
    init(item: SearchAppItem) {
        self.item = Observable.just(item)
    }
}

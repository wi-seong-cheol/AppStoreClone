//
//  NewDiscoveryTableViewCellViewModel.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/08.
//

import RxSwift
import RxCocoa

typealias NewDiscoveryTableViewCellViewModelInput = AnyObserver<NewItem>
typealias NewDiscoveryTableViewCellViewModelOutput = Driver<String>

protocol NewDiscoveryTableViewCellViewModelType {
    var input: NewDiscoveryTableViewCellViewModelInput { get }
    var output: NewDiscoveryTableViewCellViewModelOutput { get }
}

class NewDiscoveryTableViewCellViewModel: NewDiscoveryTableViewCellViewModelType {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Input
    private let item = PublishSubject<NewItem>()
    
    var input: NewDiscoveryTableViewCellViewModelInput {
        return item.asObserver()
    }
    
    // MARK: OUTPUT
    private let titleString = BehaviorRelay<String>(value: "")
    
    var output: NewDiscoveryTableViewCellViewModelOutput {
        return titleString.asDriver(onErrorJustReturn: "")
    }
    
    // MARK: Init
    init() {
        item
            .compactMap { $0.title }
            .bind(to: titleString)
            .disposed(by: disposeBag)
    }
}

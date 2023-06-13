//
//  AppDownloadTableViewCellViewModel.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/08.
//

import UIKit

import RxSwift
import RxCocoa

typealias AppRecommendTableViewCellViewModelInput = AnyObserver<RecommendItem>
typealias AppRecommendTableViewCellViewModelOutput = (titleString: Driver<String>,
                                                      descString: Driver<String>,
                                                      iconImage: Driver<UIImage>)

protocol AppRecommendTableViewCellViewModelType {
    var input: AppRecommendTableViewCellViewModelInput { get }
    var output: AppRecommendTableViewCellViewModelOutput { get }
}

class AppRecommendTableViewCellViewModel: AppRecommendTableViewCellViewModelType {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Input
    private let item = PublishSubject<RecommendItem>()
    
    var input: AppRecommendTableViewCellViewModelInput {
        return item.asObserver()
    }
    
    // MARK: OUTPUT
    private let titleString = BehaviorRelay<String>(value: "")
    private let descString = BehaviorRelay<String>(value: "")
    private let iconImage = BehaviorRelay<UIImage>(value: UIImage())
    
    var output: AppRecommendTableViewCellViewModelOutput {
        return (titleString: titleString.asDriver(onErrorJustReturn: ""),
                descString: descString.asDriver(onErrorJustReturn: ""),
                iconImage: iconImage.asDriver(onErrorJustReturn: UIImage()))
    }
    
    // MARK: Init
    init() {
        item
            .compactMap { $0.title }
            .bind(to: titleString)
            .disposed(by: disposeBag)
        
        item
            .compactMap { $0.desc }
            .bind(to: descString)
            .disposed(by: disposeBag)
        
        item
            .compactMap { $0.appIcon }
            .flatMap { ImageLoader.cache_loadImage(from: $0) }
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .bind(to: iconImage)
            .disposed(by: disposeBag)
    }
}

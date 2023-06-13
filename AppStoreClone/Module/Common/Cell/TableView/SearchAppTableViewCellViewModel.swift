//
//  SearchAppTableViewCellViewModel.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/06/06.
//

import UIKit

import RxSwift
import RxCocoa

typealias SearchAppTableViewCellViewModelInput = AnyObserver<SearchAppItem>
typealias SearchAppTableViewCellViewModelOutput = (titleString: Driver<String>,
                                                   descString: Driver<String>,
                                                   iconImage: Driver<UIImage>,
                                                   starRating: Driver<Double>,
                                                   previewImages: Driver<[UIImage]>,
                                                   previewCount: Driver<Int>)

protocol SearchAppTableViewCellViewModelType {
    var input: SearchAppTableViewCellViewModelInput { get }
    var output: SearchAppTableViewCellViewModelOutput { get }
}

class SearchAppTableViewCellViewModel: SearchAppTableViewCellViewModelType {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Input
    private let item = PublishSubject<SearchAppItem>()
    
    var input: SearchAppTableViewCellViewModelInput {
        return item.asObserver()
    }
    
    // MARK: OUTPUT
    private let titleString = BehaviorRelay<String>(value: "")
    private let descString = BehaviorRelay<String>(value: "")
    private let iconImage = BehaviorRelay<UIImage>(value: UIImage())
    private let starRating = BehaviorRelay<Double>(value: 0)
    private let previewImages = BehaviorRelay<[UIImage]>(value: [])
    private let previewCount = BehaviorRelay<Int>(value: 0)
    
    var output: SearchAppTableViewCellViewModelOutput {
        return (titleString: titleString.asDriver(onErrorJustReturn: ""),
                descString: descString.asDriver(onErrorJustReturn: ""),
                iconImage: iconImage.asDriver(onErrorJustReturn: UIImage()),
                starRating: starRating.asDriver(onErrorJustReturn: 0),
                previewImages: previewImages.asDriver(onErrorJustReturn: []),
                previewCount: previewCount.asDriver(onErrorJustReturn: 0))
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
            .compactMap { $0.icon }
            .flatMap { ImageLoader.cache_loadImage(from: $0) }
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .bind(to: iconImage)
            .disposed(by: disposeBag)
        
        item
            .compactMap { $0.starRating }
            .bind(to: starRating)
            .disposed(by: disposeBag)
        
        item
            .map { $0.preview ?? [] }
            .flatMap { previews in
                return Observable.zip(
                    previews.map {
                        ImageLoader.cache_loadImage(from: $0)
                    })
            }
            .subscribe(onNext: { [weak self] images in
                let images = images.compactMap { $0 }
                self?.previewImages.accept(images)
            })
            .disposed(by: disposeBag)
        
        item
            .compactMap { $0.preview }
            .map { $0.count }
            .bind(to: previewCount)
            .disposed(by: disposeBag)
    }
}

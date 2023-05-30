//
//  TodayViewModel.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import RxCocoa
import RxSwift

typealias TodayViewModelInput = (firstInput: AnyObserver<Void>,
                                 secondInput: AnyObserver<Void>)
typealias TodayViewModelOutput = (firstOutput: Observable<Void>,
                                  secondOutput: Observable<Void>)

protocol TodayViewModelType {
    var input: TodayViewModelInput { get }
    var output: TodayViewModelOutput { get }
}

final class TodayViewModel: TodayViewModelType {
    
    @Inject var service: ItunesService
    
    private let disposeBag = DisposeBag()
    private var timerSubscription: Disposable?
    
    // MARK: INPUT
    private let firstInput = PublishSubject<Void>()
    private let secondInput = PublishSubject<Void>()
    
    var input: TodayViewModelInput {
        return (firstInput.asObserver(),
                secondInput.asObserver())
    }
    
    // MARK: OUTPUT
    private let firstOutput = PublishSubject<Void>()
    private let secondOutput = PublishSubject<Void>()
    
    var output: TodayViewModelOutput {
        return (firstOutput: firstOutput.asObservable(),
                secondOutput: secondOutput.asObservable())
    }
    
    init() {
        
    }
}

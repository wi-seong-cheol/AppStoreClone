//
//  SearchViewModel.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import RxCocoa
import RxSwift

typealias SearchViewModelInput = (apiCall: AnyObserver<Void>,
                            startTap: AnyObserver<Void>,
                            endTap: AnyObserver<Void>,
                            resetTap: AnyObserver<Void>)
typealias SearchViewModelOutput = (timer: Driver<Int>,
                             formattedTimer: Driver<String>,
                             isRunning: Driver<Bool>)

protocol SearchViewModelType {
    var input: SearchViewModelInput { get }
    var output: SearchViewModelOutput { get }
}

final class SearchViewModel: SearchViewModelType {
    
    @Inject var service: ItunesService
    
    private let disposeBag = DisposeBag()
    private var timerSubscription: Disposable?
    
    // MARK: INPUT
    private let apiCall = PublishSubject<Void>()
    private let startTap = PublishSubject<Void>()
    private let endTap = PublishSubject<Void>()
    private let resetTap = PublishSubject<Void>()
    
    var input: TodayViewModelInput {
        return (apiCall.asObserver(),
                startTap.asObserver(),
                endTap.asObserver(),
                resetTap.asObserver())
    }
    
    // MARK: OUTPUT
    private let timer = BehaviorRelay<Int>(value: 0)
    private let formattedTimer = BehaviorRelay<String>(value: "0")
    private let isRunning = BehaviorRelay<Bool>(value: false)
    
    var output: TodayViewModelOutput {
        return (timer.asDriver(onErrorJustReturn: 0),
                formattedTimer.asDriver(onErrorJustReturn: "00:00.00"),
                isRunning.asDriver(onErrorJustReturn: false))
    }
    
    init() {
        
    }
}
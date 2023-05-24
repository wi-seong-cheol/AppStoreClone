//
//  Inject.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/23.
//

import Foundation

@propertyWrapper
final class Inject<T> {
    
    let wrappedValue: T
    
    init() {
        self.wrappedValue = DIContainer.shared.resolve()
    }
}

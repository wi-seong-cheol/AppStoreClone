//
//  UICollectionView + Extension.swift
//  AppStoreClone
//
//  Created by wi_seong on 2023/05/28.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func register(withType type: UICollectionViewCell.Type,
                      withReuseIdentifier identifier: String? = nil) {
        let cellId = identifier ?? String(describing: type)
        register(type, forCellWithReuseIdentifier: cellId)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
    
    func register(withType type: UICollectionReusableView.Type,
                                   forSupplementaryViewOfKind elementKind: String = UICollectionView.elementKindSectionHeader,
                                   withReuseIdentifier identifier: String? = nil) {
        let cellId = identifier ?? String(describing: type)
        register(type, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: cellId)
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String = UICollectionView.elementKindSectionHeader,
                                                                       withReuseIdentifier identifier: String? = nil,
                                                                       for indexPath: IndexPath) -> T {
        let cellId = identifier ?? String(describing: T.self)
        guard let cell = dequeueReusableSupplementaryView(ofKind: elementKind,
                                                          withReuseIdentifier: cellId,
                                                          for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(cellId)")
        }
        return cell
    }
}

extension UICollectionReusableView {
    
    static var identifier: String {
        return String(describing: self)
    }
}
